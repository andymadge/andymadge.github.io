# Contract: Audio Player Module

**Module**: `assets/js/audio-player.js`
**Dependencies**: WaveSurfer.js v7+
**Purpose**: Initialize and manage HTML5 audio playback with waveform visualization

---

## Module Interface

```javascript
/**
 * AudioPlayer - Manages mix playback with waveform visualization
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
   * @returns {Promise<AudioPlayer>} - Resolves when player is ready
   */
  static async init(config) {}

  /**
   * Start playback
   * @returns {void}
   */
  play() {}

  /**
   * Pause playback
   * @returns {void}
   */
  pause() {}

  /**
   * Seek to specific time
   * @param {number} seconds - Time in seconds
   * @returns {void}
   */
  seekTo(seconds) {}

  /**
   * Get current playback position
   * @returns {number} - Current time in seconds
   */
  getCurrentTime() {}

  /**
   * Check if currently playing
   * @returns {boolean}
   */
  isPlaying() {}

  /**
   * Get duration
   * @returns {number} - Total duration in seconds
   */
  getDuration() {}

  /**
   * Destroy player and clean up resources
   * @returns {void}
   */
  destroy() {}

  /**
   * Register event callback
   * @param {string} event - Event name ('play', 'pause', 'timeupdate', 'finish', 'error')
   * @param {Function} callback - Event handler
   * @returns {void}
   */
  on(event, callback) {}
}
```

---

## Events

### `play`
Fired when playback starts.
```javascript
player.on('play', () => {
  console.log('Playback started');
});
```

### `pause`
Fired when playback pauses.
```javascript
player.on('pause', () => {
  console.log('Playback paused');
});
```

### `timeupdate`
Fired periodically during playback (approximately every 250ms).
```javascript
player.on('timeupdate', (currentTime) => {
  console.log(`Current position: ${currentTime}s`);
});
```

### `finish`
Fired when playback reaches the end.
```javascript
player.on('finish', () => {
  console.log('Mix completed');
});
```

### `error`
Fired when audio fails to load or play.
```javascript
player.on('error', (error) => {
  console.error('Playback error:', error);
});
```

---

## Usage Example

```javascript
// Initialize player on mix page
const player = await AudioPlayer.init({
  containerId: 'waveform',
  audioUrl: 'https://d123.cloudfront.net/summer-2025.mp3',
  waveformUrl: '/assets/waveforms/summer-2025.dat',
  duration: 5025,
  mixId: 'summer-2025',
  mixTitle: 'Summer Vibes 2025'
});

// Register event handlers
player.on('play', () => {
  document.getElementById('play-button').textContent = 'Pause';
});

player.on('pause', () => {
  document.getElementById('play-button').textContent = 'Play';
});

player.on('timeupdate', (currentTime) => {
  // Update UI with current position
  updateTimeDisplay(currentTime);
});

player.on('error', (error) => {
  showErrorMessage('Failed to load audio. Please try again later.');
});

// Control playback
document.getElementById('play-button').addEventListener('click', () => {
  if (player.isPlaying()) {
    player.pause();
  } else {
    player.play();
  }
});
```

---

## Implementation Requirements

### Initialization
- Load WaveSurfer.js library (CDN or local)
- Create WaveSurfer instance with MediaElement backend
- Fetch and load pre-generated waveform data
- Configure waveform styling (colors, height, responsive)
- Load saved playback position from localStorage
- Restore position if valid (> 5 seconds, < duration, < 90 days old)

### Waveform Fallback
- If waveform URL returns 404 or fails to load:
  - WaveSurfer.js attempts client-side waveform generation (per FR-013)
  - For very long mixes, generation may be slow or fail on mobile devices
  - Audio playback continues normally regardless of waveform status
  - Log warning to console (not user-facing error)

### Position Persistence
- Integrate with PlaybackPersistence module
- Save position every 10 seconds during playback
- Save on pause event
- Save on page unload (beforeunload)
- Don't save positions < 5 seconds (user just started)

### Mobile Optimization
- Use MediaElement backend (not Web Audio API for decoding)
- Enable responsive waveform sizing
- Handle touch events for waveform interaction
- Test on iOS Safari, Android Chrome

### Error Handling
- Gracefully handle audio loading failures
- Show user-friendly error messages
- Don't crash page on audio errors
- Log technical details to console

---

## Configuration Schema

```typescript
interface AudioPlayerConfig {
  containerId: string;      // Required: DOM element ID
  audioUrl: string;          // Required: Full audio URL
  waveformUrl: string;       // Optional: Pre-generated waveform
  duration: number;          // Required: Duration in seconds
  mixId: string;             // Required: Unique identifier
  mixTitle: string;          // Optional: For display/debugging
  waveformColor?: string;    // Optional: Default '#1976d2'
  progressColor?: string;    // Optional: Default '#4caf50'
  height?: number;           // Optional: Default 128px
  responsive?: boolean;      // Optional: Default true
}
```

---

## Dependencies

- **WaveSurfer.js v7+**: Audio player with waveform visualization
- **PlaybackPersistence**: localStorage wrapper (see playback-persistence.md)
- **TrackHighlighter**: Optional, for P3 feature (see track-highlighter.md)

---

## Testing Checklist

- [ ] Audio plays on button click
- [ ] Waveform renders and is interactive (click to seek)
- [ ] Playback position restores on page reload
- [ ] Player works without waveform data (fallback to client-side generation)
- [ ] Mobile: Touch controls work on iOS/Android
- [ ] Mobile: Waveform is responsive on small screens
- [ ] Error handling: Shows friendly message if audio fails to load
- [ ] localStorage unavailable: Player still works (no errors)
- [ ] Play/pause/seek controls respond within 100ms
- [ ] Audio streams (doesn't require full download before play)
