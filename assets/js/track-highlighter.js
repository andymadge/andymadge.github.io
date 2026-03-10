/**
 * TrackHighlighter - Automatically highlight current track during playback
 *
 * Parses tracklist timestamps and updates highlighting based on playback position
 * Implements contract defined in specs/001-dj-mix-hosting/contracts/track-highlighter.md
 */

class TrackHighlighter {
  /**
   * Initialize track highlighter
   * @param {AudioPlayer} player - Audio player instance
   * @returns {TrackHighlighter} - Initialized highlighter instance
   */
  static init(player) {
    const highlighter = new TrackHighlighter();
    highlighter.player = player;
    highlighter.tracks = [];
    highlighter.currentTrackIndex = -1;

    // Parse tracklist from DOM
    highlighter._parseTracklist();

    if (highlighter.tracks.length === 0) {
      console.log('No tracklist found, track highlighting disabled');
      return highlighter;
    }

    console.log(`Parsed ${highlighter.tracks.length} tracks from tracklist`);

    // Register event handlers
    highlighter._setupEventListeners();

    return highlighter;
  }

  /**
   * Parse tracklist from DOM and extract track information
   * @private
   */
  _parseTracklist() {
    const tracklistItems = document.querySelectorAll('.tracklist-items li');

    tracklistItems.forEach((li, index) => {
      const timestamp = li.getAttribute('data-timestamp');
      const artistTitle = li.querySelector('.artist-title');

      if (timestamp && artistTitle) {
        const seconds = this._timestampToSeconds(timestamp);

        if (seconds !== null) {
          this.tracks.push({
            element: li,
            timestamp: timestamp,
            timestampSeconds: seconds,
            text: artistTitle.textContent.trim(),
            index: index
          });
        }
      }
    });

    // Sort tracks by timestamp (should already be sorted, but ensure it)
    this.tracks.sort((a, b) => a.timestampSeconds - b.timestampSeconds);
  }

  /**
   * Convert timestamp string to seconds
   * @param {string} timestamp - Timestamp in HH:MM:SS or MM:SS format
   * @returns {number|null} - Seconds, or null if invalid
   * @private
   */
  _timestampToSeconds(timestamp) {
    const parts = timestamp.split(':').map(p => parseInt(p, 10));

    if (parts.some(isNaN)) {
      return null;
    }

    if (parts.length === 3) {
      // HH:MM:SS
      return parts[0] * 3600 + parts[1] * 60 + parts[2];
    } else if (parts.length === 2) {
      // MM:SS
      return parts[0] * 60 + parts[1];
    }

    return null;
  }

  /**
   * Set up event listeners for playback position updates
   * @private
   */
  _setupEventListeners() {
    // Update highlighting during playback
    this.player.on('timeupdate', (currentTime) => {
      this._updateHighlighting(currentTime);
    });

    // Also update immediately on seek
    this.player.on('seek', () => {
      const currentTime = this.player.getCurrentTime();
      this._updateHighlighting(currentTime);
    });
  }

  /**
   * Update track highlighting based on current playback position
   * @param {number} currentTime - Current playback position in seconds
   * @private
   */
  _updateHighlighting(currentTime) {
    // Find the current track based on timestamp
    let newTrackIndex = -1;

    for (let i = this.tracks.length - 1; i >= 0; i--) {
      if (currentTime >= this.tracks[i].timestampSeconds) {
        newTrackIndex = i;
        break;
      }
    }

    // Only update if the track changed
    if (newTrackIndex !== this.currentTrackIndex) {
      // Remove highlighting from previous track
      if (this.currentTrackIndex >= 0 && this.tracks[this.currentTrackIndex]) {
        this.tracks[this.currentTrackIndex].element.classList.remove('current-track');
      }

      // Add highlighting to new track
      if (newTrackIndex >= 0 && this.tracks[newTrackIndex]) {
        this.tracks[newTrackIndex].element.classList.add('current-track');

        // Scroll track into view (smooth scroll)
        this.tracks[newTrackIndex].element.scrollIntoView({
          behavior: 'smooth',
          block: 'nearest',
          inline: 'nearest'
        });

        console.log(`Now playing: ${this.tracks[newTrackIndex].text}`);
      }

      this.currentTrackIndex = newTrackIndex;
    }
  }

  /**
   * Manually set highlighting for a specific track index
   * @param {number} index - Track index to highlight
   */
  highlightTrack(index) {
    if (index >= 0 && index < this.tracks.length) {
      const currentTime = this.tracks[index].timestampSeconds;
      this._updateHighlighting(currentTime);
    }
  }

  /**
   * Remove all highlighting
   */
  clearHighlighting() {
    this.tracks.forEach(track => {
      track.element.classList.remove('current-track');
    });
    this.currentTrackIndex = -1;
  }

  /**
   * Get currently highlighted track
   * @returns {Object|null} - Current track object or null
   */
  getCurrentTrack() {
    if (this.currentTrackIndex >= 0 && this.currentTrackIndex < this.tracks.length) {
      return this.tracks[this.currentTrackIndex];
    }
    return null;
  }
}

// Export for use in page initialization scripts
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { TrackHighlighter };
}
