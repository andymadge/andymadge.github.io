/**
 * AudioPlayer - Manages mix playback with waveform visualization
 *
 * Uses WaveSurfer.js v7+ with MediaElement backend for audio streaming
 * Implements contract defined in specs/001-dj-mix-hosting/contracts/audio-player.md
 */

class AudioPlayer {
  /**
   * Initialize audio player for a mix page
   * @param {Object} config - Configuration object
   * @param {string} config.containerId - DOM element ID for waveform container
   * @param {string} config.audioUrl - Full URL to audio file (Dropbox with dl=1, or S3/CloudFront)
   * @param {string} config.waveformUrl - URL to pre-generated waveform data (.dat file)
   * @param {number} config.duration - Total duration in seconds
   * @param {string} config.mixId - Unique mix identifier (for localStorage)
   * @param {string} config.mixTitle - Mix title (for localStorage)
   * @param {string} config.waveformColor - Waveform color (default: '#1976d2')
   * @param {string} config.progressColor - Progress color (default: '#4caf50')
   * @param {number} config.height - Waveform height in pixels (default: 128)
   * @returns {Promise<AudioPlayer>} - Resolves when player is ready
   */
  static async init(config) {
    const player = new AudioPlayer();
    player.config = {
      waveformColor: '#1976d2',
      progressColor: '#4caf50',
      height: 128,
      responsive: true,
      ...config
    };

    player.eventHandlers = {};

    try {
      // Try to load pre-generated waveform data if available
      let peaks = null;
      let waveformAvailable = false;
      if (config.waveformUrl) {
        try {
          console.log('Attempting to load waveform data from:', config.waveformUrl);
          const response = await fetch(config.waveformUrl);
          if (response.ok) {
            const arrayBuffer = await response.arrayBuffer();
            // Parse BBC audiowaveform binary format:
            // - 20-byte header: version(int32), flags(int32), sample_rate(int32),
            //   samples_per_pixel(int32), length(int32)
            // - Data: pairs of signed int8 (min, max) per pixel
            const HEADER_SIZE = 20;
            const rawInt8 = new Int8Array(arrayBuffer, HEADER_SIZE);
            // Normalize from int8 range [-128, 127] to WaveSurfer range [-1, 1]
            const normalizedPeaks = new Float32Array(rawInt8.length);
            for (let i = 0; i < rawInt8.length; i++) {
              normalizedPeaks[i] = rawInt8[i] / 128;
            }
            peaks = normalizedPeaks;
            console.log('Waveform data loaded successfully:', peaks.length, 'data points');
            waveformAvailable = true;
          } else {
            console.warn('Waveform file not found (404), showing placeholder');
          }
        } catch (error) {
          console.warn('Failed to load waveform data, showing placeholder:', error);
        }
      }

      // If waveform is not available, show placeholder and skip WaveSurfer initialization
      if (!waveformAvailable) {
        player._showWaveformPlaceholder(config.containerId);
        return player;
      }

      // Create gradient for waveform (Soundcloud-style with blue/green colors)
      const canvas = document.createElement('canvas');
      const ctx = canvas.getContext('2d');

      // Define the waveform gradient (Soundcloud style with blue tones)
      const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height * 1.35);
      gradient.addColorStop(0, '#1976d2'); // Top color - blue
      gradient.addColorStop((canvas.height * 0.63) / canvas.height, '#1976d2'); // Top color
      gradient.addColorStop((canvas.height * 0.63 + 1) / canvas.height, '#ffffff'); // White line
      gradient.addColorStop((canvas.height * 0.63 + 2) / canvas.height, '#ffffff'); // White line
      gradient.addColorStop((canvas.height * 0.63 + 3) / canvas.height, '#90caf9'); // Bottom color - light blue
      gradient.addColorStop(1, '#90caf9'); // Bottom color

      // Define the progress gradient (Soundcloud style with green tones)
      const progressGradient = ctx.createLinearGradient(0, 0, 0, canvas.height * 1.35);
      progressGradient.addColorStop(0, '#4caf50'); // Top color - green
      progressGradient.addColorStop((canvas.height * 0.63) / canvas.height, '#388e3c'); // Mid color - darker green
      progressGradient.addColorStop((canvas.height * 0.63 + 1) / canvas.height, '#ffffff'); // White line
      progressGradient.addColorStop((canvas.height * 0.63 + 2) / canvas.height, '#ffffff'); // White line
      progressGradient.addColorStop((canvas.height * 0.63 + 3) / canvas.height, '#a5d6a7'); // Bottom color - light green
      progressGradient.addColorStop(1, '#a5d6a7'); // Bottom color

      // Initialize WaveSurfer (v7 API - no 'backend' option, streaming via peaks+duration)
      const wavesurferConfig = {
        container: `#${config.containerId}`,
        waveColor: gradient,
        progressColor: progressGradient,
        barWidth: 2,
        height: player.config.height,
        interact: true,
        cursorWidth: 1,
        cursorColor: '#333',
        barGap: 1,
        normalize: true,
        hideScrollbar: true
      };

      player.wavesurfer = WaveSurfer.create(wavesurferConfig);

      // Load audio with peaks if available.
      // In WaveSurfer v7, passing peaks+duration to load() enables streaming mode
      // (audio element backend) rather than full WebAudio decoding of the entire file.
      // Without peaks, v7 downloads and fully decodes the file — unusable for large mixes.
      if (peaks) {
        player.wavesurfer.load(config.audioUrl, [peaks], config.duration);
      } else {
        player.wavesurfer.load(config.audioUrl);
      }

      // Set up event forwarding
      player._setupEvents();

      // Wait for ready
      await new Promise((resolve, reject) => {
        player.wavesurfer.on('ready', () => {
          console.log('Audio player ready, duration:', player.getDuration());
          resolve();
        });
        player.wavesurfer.on('error', (error) => {
          console.error('WaveSurfer error:', error);
          reject(error);
        });
      });

      return player;
    } catch (error) {
      console.error('Failed to initialize audio player:', error);
      player._triggerEvent('error', error);
      throw error;
    }
  }

  /**
   * Set up internal event listeners and forward to registered handlers
   * @private
   */
  _setupEvents() {
    this.wavesurfer.on('play', () => this._triggerEvent('play'));
    this.wavesurfer.on('pause', () => this._triggerEvent('pause'));
    this.wavesurfer.on('finish', () => this._triggerEvent('finish'));
    this.wavesurfer.on('error', (error) => this._triggerEvent('error', error));

    // Timeupdate event (approximately every 250ms)
    this.wavesurfer.on('audioprocess', (currentTime) => {
      this._triggerEvent('timeupdate', currentTime);
    });

    // Also trigger on seek
    this.wavesurfer.on('seek', () => {
      this._triggerEvent('timeupdate', this.getCurrentTime());
    });
  }

  /**
   * Trigger registered event callbacks
   * @private
   */
  _triggerEvent(event, data) {
    const handlers = this.eventHandlers[event] || [];
    handlers.forEach(callback => callback(data));
  }

  /**
   * Start playback
   * @returns {void}
   */
  play() {
    if (this.wavesurfer) {
      this.wavesurfer.play();
    }
  }

  /**
   * Pause playback
   * @returns {void}
   */
  pause() {
    if (this.wavesurfer) {
      this.wavesurfer.pause();
    }
  }

  /**
   * Seek to specific time
   * @param {number} seconds - Time in seconds
   * @returns {void}
   */
  seekTo(seconds) {
    if (this.wavesurfer) {
      const duration = this.getDuration();
      const progress = seconds / duration;
      this.wavesurfer.seekTo(progress);
    }
  }

  /**
   * Get current playback position
   * @returns {number} - Current time in seconds
   */
  getCurrentTime() {
    return this.wavesurfer ? this.wavesurfer.getCurrentTime() : 0;
  }

  /**
   * Check if currently playing
   * @returns {boolean}
   */
  isPlaying() {
    return this.wavesurfer ? this.wavesurfer.isPlaying() : false;
  }

  /**
   * Get duration
   * @returns {number} - Total duration in seconds
   */
  getDuration() {
    return this.wavesurfer ? this.wavesurfer.getDuration() : 0;
  }

  /**
   * Destroy player and clean up resources
   * @returns {void}
   */
  destroy() {
    if (this.wavesurfer) {
      this.wavesurfer.destroy();
      this.wavesurfer = null;
    }
    this.eventHandlers = {};
  }

  /**
   * Register event callback
   * @param {string} event - Event name ('play', 'pause', 'timeupdate', 'finish', 'error')
   * @param {Function} callback - Event handler
   * @returns {void}
   */
  on(event, callback) {
    if (!this.eventHandlers[event]) {
      this.eventHandlers[event] = [];
    }
    this.eventHandlers[event].push(callback);
  }

  /**
   * Show placeholder text when waveform is not available
   * @param {string} containerId - DOM element ID for waveform container
   * @private
   */
  _showWaveformPlaceholder(containerId) {
    const container = document.getElementById(containerId);
    if (container) {
      // Add placeholder class for styling
      container.classList.add('waveform-placeholder');

      // Create and insert placeholder text
      const placeholder = document.createElement('div');
      placeholder.className = 'waveform-placeholder-text';
      placeholder.textContent = 'Waveform not available';

      // Clear any existing content and add placeholder
      container.innerHTML = '';
      container.appendChild(placeholder);

      console.log('Waveform placeholder displayed');
    }
  }
}

/**
 * Format seconds to MM:SS or H:MM:SS
 * @param {number} seconds - Time in seconds
 * @returns {string} - Formatted time string
 */
function formatTime(seconds) {
  if (isNaN(seconds) || seconds < 0) return '0:00';

  const hours = Math.floor(seconds / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  const secs = Math.floor(seconds % 60);

  if (hours > 0) {
    return `${hours}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }
  return `${minutes}:${secs.toString().padStart(2, '0')}`;
}

/**
 * Display user-friendly error message
 * @param {string} message - Error message to display
 */
function showError(message) {
  const errorContainer = document.getElementById('audio-error');
  const errorMessage = document.getElementById('error-message');

  if (errorContainer && errorMessage) {
    errorMessage.textContent = message;
    errorContainer.style.display = 'block';
  }
}

// Export for use in page initialization scripts
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { AudioPlayer, formatTime, showError };
}
