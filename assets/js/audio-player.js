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
   * @param {string} config.audioUrl - Full URL to audio file (S3/CloudFront)
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
      // Initialize WaveSurfer with MediaElement backend
      player.wavesurfer = WaveSurfer.create({
        container: `#${config.containerId}`,
        waveColor: player.config.waveformColor,
        progressColor: player.config.progressColor,
        height: player.config.height,
        responsive: player.config.responsive,
        backend: 'MediaElement', // Use MediaElement for streaming
        mediaControls: false,
        interact: true,
        cursorWidth: 1,
        barWidth: 2,
        barGap: 1,
        normalize: true
      });

      // Load audio
      player.wavesurfer.load(config.audioUrl);

      // Set up event forwarding
      player._setupEvents();

      // Wait for ready
      await new Promise((resolve, reject) => {
        player.wavesurfer.on('ready', () => resolve());
        player.wavesurfer.on('error', (error) => reject(error));
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
