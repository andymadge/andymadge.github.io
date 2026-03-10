/**
 * PlaybackPersistence - localStorage wrapper for mix playback positions
 *
 * Manages saving and restoring playback positions across browser sessions
 * Implements contract defined in specs/001-dj-mix-hosting/contracts/playback-persistence.md
 */

const PlaybackPersistence = {
  /**
   * Storage key (namespaced to avoid conflicts)
   */
  STORAGE_KEY: 'andymadge_mixPositions',

  /**
   * Expiration time in milliseconds (90 days)
   */
  EXPIRATION_MS: 90 * 24 * 60 * 60 * 1000,

  /**
   * Minimum position to save (don't save if < 5 seconds)
   */
  MIN_SAVE_POSITION: 5,

  /**
   * Check if localStorage is available and writable
   * @returns {boolean} - True if localStorage is usable
   */
  isAvailable() {
    try {
      const test = '__localStorage_test__';
      localStorage.setItem(test, test);
      localStorage.removeItem(test);
      return true;
    } catch (e) {
      // Handles: disabled localStorage, private browsing, SecurityError
      console.warn('localStorage unavailable:', e.name);
      return false;
    }
  },

  /**
   * Load all positions from localStorage
   * @returns {Object} - Position data structure
   * @private
   */
  _loadPositions() {
    if (!this.isAvailable()) {
      return { positions: {}, version: 1 };
    }

    try {
      const data = localStorage.getItem(this.STORAGE_KEY);
      if (!data) {
        return { positions: {}, version: 1 };
      }

      const parsed = JSON.parse(data);

      // Validate structure
      if (!parsed.positions || typeof parsed.positions !== 'object') {
        console.warn('Invalid position data structure, resetting');
        return { positions: {}, version: 1 };
      }

      // Clean up expired positions
      this._cleanExpired(parsed);

      return parsed;
    } catch (e) {
      console.error('Failed to load positions from localStorage:', e);
      return { positions: {}, version: 1 };
    }
  },

  /**
   * Save positions to localStorage
   * @param {Object} data - Position data structure
   * @returns {boolean} - True if save successful
   * @private
   */
  _savePositions(data) {
    if (!this.isAvailable()) {
      return false;
    }

    try {
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(data));
      return true;
    } catch (e) {
      console.error('Failed to save positions to localStorage:', e);
      return false;
    }
  },

  /**
   * Save playback position for a mix
   * @param {string} mixId - Unique mix identifier
   * @param {number} position - Playback position in seconds
   * @param {number} duration - Total duration in seconds
   * @param {string} [title] - Optional mix title
   * @returns {boolean} - True if save successful
   */
  savePosition(mixId, position, duration, title = '') {
    if (!this.isAvailable()) {
      return false;
    }

    // Don't save tiny positions (user just started)
    if (position < this.MIN_SAVE_POSITION) {
      return false;
    }

    // Don't save if position is beyond duration (invalid)
    if (position > duration) {
      return false;
    }

    try {
      const data = this._loadPositions();
      data.positions[mixId] = {
        position: position,
        duration: duration,
        lastPlayed: Date.now(),
        title: title
      };

      return this._savePositions(data);
    } catch (e) {
      if (e.name === 'QuotaExceededError' || e.code === 22) {
        return this._handleQuotaExceeded(mixId, position, duration, title);
      }
      console.error('Failed to save position:', e);
      return false;
    }
  },

  /**
   * Get saved playback position for a mix
   * @param {string} mixId - Unique mix identifier
   * @returns {Object|null} - Position data or null if not found/expired
   */
  getPosition(mixId) {
    const data = this._loadPositions();
    const mixData = data.positions[mixId];

    if (!mixData) {
      return null;
    }

    // Check expiration
    if (this.isExpired(mixData.lastPlayed)) {
      this.removePosition(mixId); // Lazy cleanup
      return null;
    }

    return mixData;
  },

  /**
   * Remove position for a specific mix
   * @param {string} mixId - Unique mix identifier
   * @returns {boolean} - True if removal successful
   */
  removePosition(mixId) {
    if (!this.isAvailable()) {
      return false;
    }

    try {
      const data = this._loadPositions();
      delete data.positions[mixId];
      return this._savePositions(data);
    } catch (e) {
      console.error('Failed to remove position:', e);
      return false;
    }
  },

  /**
   * Clear all saved positions
   * @returns {boolean} - True if clear successful
   */
  clearAll() {
    if (!this.isAvailable()) {
      return false;
    }

    try {
      localStorage.removeItem(this.STORAGE_KEY);
      return true;
    } catch (e) {
      console.error('Failed to clear positions:', e);
      return false;
    }
  },

  /**
   * Get all saved positions
   * @returns {Object} - All position data
   */
  getAllPositions() {
    return this._loadPositions();
  },

  /**
   * Check if a position is expired
   * @param {number} lastPlayed - Unix timestamp (ms)
   * @returns {boolean} - True if expired (> 90 days old)
   */
  isExpired(lastPlayed) {
    return (Date.now() - lastPlayed) > this.EXPIRATION_MS;
  },

  /**
   * Clean up expired positions
   * @param {Object} data - Position data structure
   * @private
   */
  _cleanExpired(data) {
    let cleaned = false;

    for (const [mixId, mixData] of Object.entries(data.positions)) {
      if (this.isExpired(mixData.lastPlayed)) {
        delete data.positions[mixId];
        cleaned = true;
      }
    }

    // Save cleaned data
    if (cleaned && this.isAvailable()) {
      this._savePositions(data);
      console.log('Cleaned up expired positions');
    }
  },

  /**
   * Handle quota exceeded error by cleaning up oldest positions
   * @param {string} mixId - Mix ID to save
   * @param {number} position - Position to save
   * @param {number} duration - Duration
   * @param {string} title - Title
   * @returns {boolean} - True if retry successful
   * @private
   */
  _handleQuotaExceeded(mixId, position, duration, title) {
    try {
      const data = this._loadPositions();

      // Sort by lastPlayed (oldest first)
      const sortedMixes = Object.entries(data.positions)
        .sort((a, b) => a[1].lastPlayed - b[1].lastPlayed);

      // Remove oldest 25%
      const toRemove = Math.ceil(sortedMixes.length * 0.25);
      for (let i = 0; i < toRemove && i < sortedMixes.length; i++) {
        delete data.positions[sortedMixes[i][0]];
      }

      // Add current position
      data.positions[mixId] = {
        position,
        duration,
        lastPlayed: Date.now(),
        title
      };

      // Retry save
      if (this._savePositions(data)) {
        console.log(`Cleaned up ${toRemove} old positions to make space`);
        return true;
      }

      return false;
    } catch (e) {
      console.error('Failed to recover from quota error:', e);
      return false;
    }
  }
};

// Export for use in page initialization scripts
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { PlaybackPersistence };
}
