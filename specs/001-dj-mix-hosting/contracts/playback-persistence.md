# Contract: Playback Persistence Module

**Module**: `assets/js/playback-persistence.js`
**Dependencies**: None (vanilla JavaScript)
**Purpose**: Manage playback position storage and retrieval using browser localStorage

---

## Module Interface

```javascript
/**
 * PlaybackPersistence - localStorage wrapper for mix playback positions
 */
const PlaybackPersistence = {
  /**
   * Storage key (namespaced to avoid conflicts)
   */
  STORAGE_KEY: 'andymadge_mixPositions',

  /**
   * Maximum number of mix positions to store (LRU eviction when exceeded)
   * Updated 2026-02-21: no TTL expiry — EXPIRATION_MS removed
   */
  MAX_POSITIONS: 20,

  /**
   * Check if localStorage is available and writable
   * @returns {boolean} - True if localStorage is usable
   */
  isAvailable() {},

  /**
   * Save playback position for a mix
   * @param {string} mixId - Unique mix identifier
   * @param {number} position - Playback position in seconds
   * @param {number} duration - Total duration in seconds
   * @param {string} [title] - Optional mix title
   * @returns {boolean} - True if save successful
   */
  savePosition(mixId, position, duration, title = '') {},

  /**
   * Get saved playback position for a mix
   * @param {string} mixId - Unique mix identifier
   * @returns {Object|null} - Position data or null if not found/expired
   * @returns {number} return.position - Playback position in seconds
   * @returns {number} return.duration - Total duration in seconds
   * @returns {number} return.lastPlayed - Unix timestamp (ms)
   * @returns {string} return.title - Mix title
   */
  getPosition(mixId) {},

  /**
   * Remove position for a specific mix
   * @param {string} mixId - Unique mix identifier
   * @returns {boolean} - True if removal successful
   */
  removePosition(mixId) {},

  /**
   * Clear all saved positions
   * @returns {boolean} - True if clear successful
   */
  clearAll() {},

  /**
   * Get all saved positions
   * @returns {Object} - All position data
   */
  getAllPositions() {},

  /**
   * Check if a position is expired
   * @param {number} lastPlayed - Unix timestamp (ms)
   * @returns {boolean} - True if expired (> 90 days old)
   */
  isExpired(lastPlayed) {}
};
```

---

## Data Structure

### Stored in localStorage
```javascript
{
  "positions": {
    "summer-2025": {
      "position": 1234.5,
      "duration": 5025,
      "lastPlayed": 1732521600000,
      "title": "Summer Vibes 2025"
    },
    "winter-2024": {
      "position": 890.2,
      "duration": 4200,
      "lastPlayed": 1732435200000,
      "title": "Winter Chill 2024"
    }
  },
  "version": 1
}
```

### Position Object Schema
```typescript
interface PositionData {
  position: number;      // Playback position in seconds (float)
  duration: number;       // Total duration in seconds (int)
  lastPlayed: number;     // Unix timestamp in milliseconds
  title: string;          // Mix title (optional, for debugging)
}

interface StorageData {
  positions: Record<string, PositionData>;
  version: number;        // Schema version (currently 1)
}
```

---

## Usage Example

```javascript
// Save position during playback (called by AudioPlayer)
PlaybackPersistence.savePosition('summer-2025', 1234.5, 5025, 'Summer Vibes 2025');

// Get saved position on page load
const saved = PlaybackPersistence.getPosition('summer-2025');
if (saved) {
  console.log(`Resume from ${saved.position}s`);
  audio.currentTime = saved.position;
} else {
  console.log('No saved position, starting from beginning');
}

// Check if localStorage is available before saving
if (PlaybackPersistence.isAvailable()) {
  PlaybackPersistence.savePosition('summer-2025', 500, 5025);
} else {
  console.warn('localStorage unavailable, positions will not be saved');
}

// Remove specific position
PlaybackPersistence.removePosition('old-mix-2023');

// Clear all saved positions
PlaybackPersistence.clearAll();

// Get all positions (for debugging or admin UI)
const allPositions = PlaybackPersistence.getAllPositions();
console.log(`Tracking ${Object.keys(allPositions.positions).length} mixes`);
```

---

## Implementation Requirements

### Availability Check
```javascript
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
}
```

### Save Position
```javascript
savePosition(mixId, position, duration, title = '') {
  if (!this.isAvailable()) return false;

  try {
    const data = this.loadPositions();
    data.positions[mixId] = {
      position: position,
      duration: duration,
      lastPlayed: Date.now(),
      title: title
    };
    localStorage.setItem(this.STORAGE_KEY, JSON.stringify(data));
    return true;
  } catch (e) {
    if (e.name === 'QuotaExceededError' || e.code === 22) {
      return this.handleQuotaExceeded(mixId, position, duration, title);
    }
    console.error('Failed to save position:', e);
    return false;
  }
}
```

### Get Position with Expiration Check
```javascript
getPosition(mixId) {
  const data = this.loadPositions();
  const mixData = data.positions[mixId];

  if (!mixData) return null;

  // Check expiration
  if (this.isExpired(mixData.lastPlayed)) {
    this.removePosition(mixId); // Lazy cleanup
    return null;
  }

  return mixData;
}
```

### Quota Exceeded Handling
```javascript
handleQuotaExceeded(mixId, position, duration, title) {
  try {
    const data = this.loadPositions();

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
    localStorage.setItem(this.STORAGE_KEY, JSON.stringify(data));
    console.log(`Cleaned up ${toRemove} old positions to make space`);
    return true;
  } catch (e) {
    console.error('Failed to recover from quota error:', e);
    return false;
  }
}
```

### Lazy Expiration Cleanup
```javascript
cleanExpired(data) {
  let cleaned = false;

  for (const [mixId, mixData] of Object.entries(data.positions)) {
    if (this.isExpired(mixData.lastPlayed)) {
      delete data.positions[mixId];
      cleaned = true;
    }
  }

  // Save cleaned data
  if (cleaned && this.isAvailable()) {
    try {
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(data));
    } catch (e) {
      console.error('Failed to save cleaned data:', e);
    }
  }
}
```

---

## Error Handling

### localStorage Unavailable
- **Causes**: Private browsing mode, disabled localStorage, SecurityError
- **Behavior**: `isAvailable()` returns `false`, all operations silently fail
- **User Impact**: Positions not saved, but playback continues normally
- **No errors thrown**: Graceful degradation

### Quota Exceeded
- **Cause**: localStorage limit reached (typically 5-10MB)
- **Behavior**: Automatic cleanup of oldest 25% of positions, retry save
- **User Impact**: Oldest positions lost, but current position saved
- **Fallback**: If retry fails, silently degrade

### Corrupted Data
- **Cause**: Invalid JSON, schema changes, manual editing
- **Behavior**: Return empty structure, don't crash
- **User Impact**: All positions lost, start fresh
- **Recovery**: Automatic recovery on next save

### Multiple Tabs
- **Behavior**: Last write wins (acceptable)
- **Sync**: Optional `storage` event listener for cross-tab sync
- **User Impact**: Position from most recently active tab persists

---

## Constants

```javascript
const PlaybackPersistence = {
  STORAGE_KEY: 'andymadge_mixPositions',
  EXPIRATION_MS: 90 * 24 * 60 * 60 * 1000, // 90 days
  MIN_SAVE_POSITION: 5, // Don't save if < 5 seconds
  SAVE_THROTTLE_MS: 10000 // Save every 10 seconds max
};
```

---

## Testing Checklist

- [ ] `isAvailable()` returns false in private browsing mode
- [ ] Save/get position works for single mix
- [ ] Positions expire after 90 days
- [ ] Expired positions are cleaned up lazily
- [ ] Quota exceeded triggers automatic cleanup
- [ ] Corrupted data returns empty structure (doesn't crash)
- [ ] `clearAll()` removes all positions
- [ ] Multiple saves to same mixId update existing entry
- [ ] Position < 5 seconds is not saved (optional feature)
- [ ] Works across browser sessions (close/reopen browser)

---

## Dependencies

None (vanilla JavaScript, no external libraries required)

---

## Browser Compatibility

- Chrome/Edge: Full support
- Firefox: Full support
- Safari: Full support (excluding private mode)
- iOS Safari: Full support (excluding private mode)
- Android Chrome: Full support

**Private Mode Limitations**: localStorage is disabled or severely restricted in private/incognito mode. Module detects this and degrades gracefully.
