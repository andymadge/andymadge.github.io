# Research: DJ Mix Hosting

**Date**: 2025-11-25
**Phase**: 0 - Research & Unknowns
**Status**: COMPLETE

This document captures research findings for all technical unknowns identified in the implementation plan.

---

## 1. JavaScript Audio Player Library Selection

### Decision
**WaveSurfer.js v7**

### Rationale
WaveSurfer.js is the optimal choice because it combines native waveform visualization with a complete audio player in a single, well-maintained package. Key advantages:

- **Size**: ~45-50KB minified + gzipped (under 100KB target)
- **Waveform**: Built-in client-side generation using Web Audio API and Canvas
- **Mobile**: Good support (works on Mobile Safari, Chrome, Firefox)
- **localStorage**: Straightforward to implement using timeupdate/pause events and seekTo() method
- **Documentation**: Excellent - comprehensive with TypeScript types
- **Maintenance**: Active - v7.x released in 2024-2025, regular updates
- **License**: BSD-3-Clause (permissive)

### Alternatives Considered
- **Plyr**: Better localStorage support but no waveform (would need integration with separate library)
- **Howler.js**: Smallest (7KB) but no waveform support, requires custom visualization
- **Peaks.js**: Professional-grade but larger (63KB) and overkill for basic playback needs

---

## 2. Waveform Generation Approach

### Decision
**Pre-Generated Waveform Data using BBC audiowaveform (Primary), Client-Side Generation with WaveSurfer.js (Fallback)**

### Rationale
Pre-generated waveforms are strongly preferred for 30-120 minute DJ mixes, with client-side generation as fallback when pre-generated data is unavailable:

**Why pre-generated is primary:**
- **Performance**: Waveforms display instantly on page load
- **File size**: 100MB audio → 800KB-1MB waveform data (binary .dat format)
- **Static site alignment**: Jekyll builds assets at compile time
- **Mobile compatible**: No memory spikes, works on all devices
- **Memory efficient**: Avoids 70MB audio files consuming ~10GB RAM during Web Audio API decoding

**Client-side generation limitations:**
- AudioBuffer is designed for snippets < 45 seconds, not hour-long mixes
- Can crash browsers on desktop, fails immediately on mobile for large files
- CORS complications with externally-hosted audio files
- Slow generation time for long mixes (3+ hours)

**Fallback strategy (FR-013):**
- If pre-generated waveform data is unavailable, use WaveSurfer.js client-side generation
- WaveSurfer.js will attempt to generate waveform from audio file
- For very long mixes, this may be slow or fail on mobile devices
- Audio playback continues normally regardless of waveform generation success

### Implementation
- **Tool**: BBC audiowaveform CLI (for pre-generation)
- **Format**: Binary .dat files (8-bit depth, gzipped)
- **Storage**: Waveform data in Jekyll repo (`assets/waveforms/`), audio on external hosting
- **Integration**: WaveSurfer.js + MediaElement backend natively supports audiowaveform format
- **Fallback**: WaveSurfer.js handles client-side generation automatically when peaks data not provided

**Command example:**
```bash
audiowaveform -i mix.mp3 -o assets/waveforms/mix.dat -b 8 -z 256
```

---

## 3. External Audio Hosting

### Decision
**Amazon S3 + CloudFront** (NOT Dropbox)

### Rationale
Dropbox has significant limitations for production audio streaming:

**Dropbox limitations:**
- **CORS**: No official CORS header support (intentional)
- **Bandwidth**: Only 20GB/day for Basic accounts (easily exceeded)
- **Reliability**: Not optimized for streaming, slow loads
- **Workarounds**: Unofficial `dl.dropboxusercontent.com` may break without notice

**S3 + CloudFront advantages:**
- **Free tier**: 5GB storage + CDN at $0/month (beats Dropbox's 2GB)
- **Proper CORS**: Full support, production-ready
- **No overage charges**: Flat-rate pricing, no bandwidth surprises
- **Streaming optimized**: Purpose-built CDN for media delivery
- **Scalable**: Easy upgrade to $15/month Pro when needed

### Alternative for Testing
Internet Archive acceptable for initial testing (free, unlimited), but reliability issues reported for production use.

### Setup Process
1. Create S3 bucket, upload audio files
2. Create CloudFront distribution pointing to bucket
3. Use CloudFront URLs in Jekyll front matter
4. No special CORS configuration needed (automatic)

---

## 4. Jekyll Collections Configuration

### Decision
**Use Jekyll collection (`_djmixes/`) with Minimal Mistakes theme integration**

### Rationale
Collections are ideal for DJ mixes because:
- Designed for grouped content of the same type
- Date-optional (flexible for chronological sorting)
- Custom front matter schemas
- Minimal Mistakes has built-in collection layout support

**Configuration in `_config.yml`:**
```yaml
collections:
  mixes:
    output: true
    permalink: /music/:name/

defaults:
  - scope:
      path: ""
      type: mixes
    values:
      layout: single
      author_profile: true
      share: true
      comments: false
      classes: wide
```

### Front Matter Schema
```yaml
---
title: "Summer Vibes 2025"
date: 2025-06-15
excerpt: "A deep house journey through summer sounds"
header:
  teaser: /assets/images/mixes/summer-vibes-2025-teaser.jpg
duration: "1:23:45"
audio_url: "https://d123456.cloudfront.net/summer-2025.mp3"
waveform_file: "summer-2025.dat"
duration_seconds: 5025
tags:
  - deep house
  - summer
---
```

### Sorting Strategy
Reverse chronological by date (newest first):

**Option 1 - Using Minimal Mistakes collection layout:**
```yaml
# _pages/music.md
---
layout: collection
collection: mixes
sort_by: date
sort_order: reverse
---
```

**Option 2 - Custom Liquid:**
```liquid
{% raw %}{% assign sorted_djmixes = site.djmixes | sort: 'date' | reverse %}{% endraw %}
```

### File Organization
```
_djmixes/
├── 2025-06-15-summer-vibes.md
├── 2024-12-20-winter-chill.md
└── 2024-09-10-sunset-sessions.md
```

Generates URLs:
- `/music/summer-vibes/`
- `/music/winter-chill/`
- `/music/sunset-sessions/`

---

## 5. localStorage Best Practices

### Decision
**Single namespaced key with JSON structure, 90-day expiration**

### Data Structure
```javascript
// Stored under key: 'andymadge_mixPositions'
{
  "positions": {
    "summer-2025": {
      "position": 1234.5,        // seconds
      "duration": 3600,           // seconds
      "lastPlayed": 1732521600000, // timestamp (ms)
      "title": "Summer Mix 2025"  // optional
    },
    "winter-2024": {
      "position": 890.2,
      "duration": 4200,
      "lastPlayed": 1732435200000,
      "title": "Winter Mix 2024"
    }
  },
  "version": 1
}
```

### Key Naming
**Convention**: `andymadge_mixPositions` (single key, domain-prefixed)

**Rationale**:
- Prevents collision with other scripts
- More efficient than multiple keys (uses less quota)
- Simpler cleanup and expiration management

### Expiration Strategy
**90 days of inactivity with lazy expiration**

- Check `lastPlayed` timestamp when loading positions
- Remove expired items during `loadPositions()` call
- Balances user convenience with storage hygiene
- Automatic cleanup when quota issues occur (remove oldest 25%)

### Implementation Pattern
```javascript
const MixPositionStore = {
  STORAGE_KEY: 'andymadge_mixPositions',
  EXPIRATION_MS: 90 * 24 * 60 * 60 * 1000,

  isAvailable() {
    try {
      localStorage.setItem('__test__', '__test__');
      localStorage.removeItem('__test__');
      return true;
    } catch (e) {
      return false; // Handles disabled, private mode, quota
    }
  },

  savePosition(mixId, position, duration, title) {
    if (!this.isAvailable()) return false;

    try {
      const data = this.loadPositions();
      data.positions[mixId] = {
        position,
        duration,
        lastPlayed: Date.now(),
        title
      };
      localStorage.setItem(this.STORAGE_KEY, JSON.stringify(data));
      return true;
    } catch (e) {
      if (e.name === 'QuotaExceededError') {
        return this.handleQuotaExceeded(mixId, position, duration, title);
      }
      return false;
    }
  },

  getPosition(mixId) {
    const data = this.loadPositions();
    const mixData = data.positions[mixId];

    if (!mixData || this.isExpired(mixData.lastPlayed)) {
      return null;
    }

    return mixData;
  },

  // ... (full implementation in separate code file)
};
```

### Edge Case Handling
- **localStorage disabled**: Graceful degradation, no errors thrown
- **Quota exceeded**: Automatic cleanup of oldest 25% of positions, retry save
- **Corrupted data**: JSON parse errors caught, return empty structure
- **Multiple tabs**: Last write wins (acceptable behavior)
- **Private browsing**: Detection via try/catch, silent failure

### Save Frequency
- **Throttle**: Every 10 seconds during playback (sufficient granularity)
- **Critical saves**: On pause, on page unload (`beforeunload` event)
- **Skip tiny positions**: Don't save if < 5 seconds

---

## Summary of Decisions

| Unknown | Decision | Key Factor |
|---------|----------|------------|
| Audio Player Library | WaveSurfer.js v7 | Native waveform + player in one package |
| Waveform Generation | Pre-generated (audiowaveform) | Memory limits make client-side unsuitable for long mixes |
| Audio Hosting | Amazon S3 + CloudFront | Proper CORS, free tier, production-ready (NOT Dropbox) |
| Jekyll Structure | Collections (`_djmixes/`) | Best for grouped content, theme integration |
| localStorage Pattern | Single namespaced key, 90-day TTL | Efficient, simple cleanup, graceful degradation |

---

## Next Steps

Phase 1 can now proceed with:
1. **data-model.md**: Define YAML front matter schema in detail
2. **contracts/**: JavaScript module APIs (audio player, waveform, localStorage)
3. **quickstart.md**: Step-by-step guide for adding a new mix
4. **Agent context update**: Run update script for Claude context

All technical unknowns resolved. Implementation can proceed with confidence.
