# Research: DJ Mix Hosting

**Date**: 2025-11-25 | **Updated**: 2026-02-21
**Phase**: 0 - Research & Unknowns
**Status**: COMPLETE — corrections applied 2026-02-21 (see individual sections)

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
**Pre-Generated Waveform Data using BBC audiowaveform (Primary); waveform section collapsed if data unavailable** *(Updated 2026-02-21: fallback is collapse, not client-side generation — see FR-013)*

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

**Fallback strategy (FR-013):** *(Updated 2026-02-21)*
- If pre-generated waveform data is unavailable, the waveform display section is collapsed entirely
- There is no client-side waveform generation fallback
- Audio playback continues normally with controls but without waveform

### Implementation
- **Tool**: BBC audiowaveform CLI (for pre-generation)
- **Format**: Binary .dat files (8-bit depth, gzipped)
- **Storage**: Waveform data in Jekyll repo (`assets/djmixes/{slug}/waveform.dat`), audio on external hosting
- **Integration**: WaveSurfer.js + MediaElement backend natively supports audiowaveform format
- **Fallback**: WaveSurfer.js handles client-side generation automatically when peaks data not provided

**Command example:**
```bash
audiowaveform -i mix.mp3 -o assets/waveforms/mix.dat -b 8 -z 256
```

---

## 3. External Audio Hosting

### Decision
**Dropbox (Primary)** with S3 + CloudFront as optional migration path *(confirmed 2026-02-21: Dropbox is the actual primary hosting; the summary table below was wrong — see correction at end of document)*

### Rationale for Dropbox
Dropbox is acceptable for this personal blog use case given the specific constraints and scale:

**Why Dropbox works for this use case:**
- **Scale**: Personal blog with 10-50 mixes expected (not commercial/viral)
- **Bandwidth**: 20GB/day limit sufficient for personal traffic (100-200 plays/day max)
- **Simplicity**: Zero cost, no AWS account needed, familiar interface
- **CORS workaround**: Shareable links with `?dl=1` parameter work reliably
- **Reliability**: Adequate for non-critical personal content
- **File management**: Easy to organize, update, and manage mix files

**Dropbox limitations acknowledged:**
- **CORS**: Not officially supported, relies on `?dl=1` parameter workaround
- **Bandwidth**: 20GB/day cap for Basic accounts (~67 hours of streaming at 320kbps)
- **Scalability**: Not suitable for viral/commercial content
- **Reliability**: Not optimized for streaming, may have slower initial loads

**Trade-off analysis:**
- **For personal blogs**: Dropbox's simplicity outweighs S3's technical advantages
- **For scaling up**: S3/CloudFront migration path available (see Appendix)
- **Cost comparison**: $0 (Dropbox) vs $1-5/month (S3) for expected traffic

### Dropbox Implementation

**Getting shareable Dropbox links:**

1. **Upload audio file to Dropbox**
   - Organize in folder: `/Apps/DJ Mixes/` (or your preference)
   - Right-click file → "Share" or "Copy link"

2. **Convert to direct download link**
   - Original link: `https://www.dropbox.com/scl/fi/abc123xyz/summer-vibes-2025.mp3?rlkey=xyz&st=abc`
   - Add `&dl=1` parameter to make it a direct download/streaming link
   - Final link: `https://www.dropbox.com/scl/fi/abc123xyz/summer-vibes-2025.mp3?rlkey=xyz&st=abc&dl=1`

3. **Link format variations**
   - **Old format**: `https://www.dropbox.com/s/abc123/file.mp3?dl=1`
   - **New format**: `https://www.dropbox.com/scl/fi/.../file.mp3?rlkey=...&dl=1`
   - Both formats work with `dl=1` parameter

**Important parameters:**
- `dl=1` - Forces direct download/stream (bypasses Dropbox preview page)
- `dl=0` (default) - Opens Dropbox preview page (NOT suitable for audio player)
- `raw=1` - Legacy parameter, use `dl=1` instead

### Migration Path: S3 + CloudFront (Appendix)

When to migrate from Dropbox to S3/CloudFront:
- Traffic exceeds 20GB/day bandwidth limit
- Need professional CDN performance
- Expanding to commercial use
- Require guaranteed CORS support
- Need advanced analytics

**S3 + CloudFront advantages:**
- **Free tier**: 5GB storage + CDN, then $1-5/month for typical blog traffic
- **Proper CORS**: Full support, production-ready
- **No bandwidth caps**: Predictable pricing, no daily limits
- **Streaming optimized**: Purpose-built CDN for media delivery
- **Scalable**: Easy upgrade when needed

**Setup process (see quickstart.md Appendix A for full instructions):**
1. Create S3 bucket, upload audio files
2. Create CloudFront distribution pointing to bucket
3. Update audio_url in mix files to CloudFront URLs
4. No code changes needed (just URL updates)

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
  cover: /assets/images/mixes/covers/summer-vibes-2025.jpg
  og_image: /assets/images/mixes/covers/summer-vibes-2025.jpg
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
**Single namespaced key with JSON structure, indefinite storage, LRU cap at 20 mixes** *(Updated 2026-02-21: no TTL expiry — positions stored indefinitely, evicted only by LRU cap)*

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

### Eviction Strategy *(Updated 2026-02-21: TTL removed)*
**Indefinite storage with LRU cap at 20 mixes**

- Positions are stored indefinitely — no time-based expiry
- When saving would exceed 20 stored positions, evict the least-recently-used entry
- Automatic cleanup when quota issues occur (remove oldest 25%)
- `lastPlayed` timestamp retained for LRU ordering only, not for expiry

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
| Waveform Generation | Pre-generated (audiowaveform); collapse if missing | Memory limits make client-side unsuitable for long mixes |
| Audio Hosting | **Dropbox (primary)**, S3/CloudFront as migration path | Zero cost, sufficient for personal scale; `dl=1` normalised by tooling |
| Jekyll Structure | Collections (`_djmixes/`) | Best for grouped content, theme integration |
| localStorage Pattern | Single namespaced key, indefinite + LRU cap 20 | Efficient, LRU eviction, graceful degradation |

---

## Next Steps

Phase 1 can now proceed with:
1. **data-model.md**: Define YAML front matter schema in detail
2. **contracts/**: JavaScript module APIs (audio player, waveform, localStorage)
3. **quickstart.md**: Step-by-step guide for adding a new mix
4. **Agent context update**: Run update script for Claude context

All technical unknowns resolved. Implementation can proceed with confidence.
