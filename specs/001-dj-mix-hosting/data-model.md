# Data Model: DJ Mix Hosting

**Date**: 2025-11-25 | **Updated**: 2026-02-21
**Phase**: 1 - Design & Contracts
**Status**: COMPLETE — corrections applied 2026-02-21

This document defines the data structures, YAML front matter schemas, and relationships for the DJ mix hosting feature.

---

## Overview

The DJ mix hosting feature uses Jekyll collections to manage mix content. Each mix is stored as a Markdown file with YAML front matter in the `_djmixes/` collection directory. This approach provides:

- Content-first architecture (plain text, portable)
- Version control friendly
- Simple authoring workflow
- Static site generation (no database)

---

## Entity: DJ Mix

### Storage Location
```
_djmixes/YYYY-MM-DD-mix-slug.md
```

**File naming convention**: `YYYY-MM-DD-mix-slug.md`
- Date prefix enables chronological sorting
- Slug becomes URL (via `:name` permalink variable)
- Example: `2025-06-15-summer-vibes.md` → `/music/summer-vibes/`
- Slug is auto-generated from title by `add-mix.sh` (lowercase, spaces→hyphens, special chars stripped)
- **MUST NOT be renamed after first publish** — the URL is permanent

### YAML Front Matter Schema

```yaml
---
# REQUIRED FIELDS

title: string              # Display title for the mix
date: YYYY-MM-DD           # Publication date (ISO 8601 format)
audio_url: string          # Full URL to hosted audio file (Dropbox with dl=1, or S3/CloudFront)
duration_seconds: integer  # Total duration in seconds (for waveform/player)

# OPTIONAL FIELDS (High Priority)

excerpt: string            # Short description (shown in list views, SEO meta)
waveform_file: string      # Path to pre-generated waveform data, relative to assets/djmixes/
                           # Example: "2025-06-15-summer-vibes/waveform.dat"
                           # Full path: assets/djmixes/{waveform_file}
                           # If absent, waveform display section is collapsed entirely

# OPTIONAL FIELDS (Metadata & Display)

header:
  cover: string            # Cover art image URL (shown in mix page, grid/list views, and social shares)
  og_image: string         # Open Graph image for social sharing (usually same as cover)
                           # Both commented-out by default in add-mix.sh output (must be added manually)

duration_display: string   # Human-readable duration (e.g., "1:23:45") — shown on mix page
genre: string              # Music genre (e.g., "Deep House", "Techno")
                           # Can use genres as tags for filtering

mix_image: string          # Optional path to secondary image (e.g. Ableton/DAW screenshot)
                           # Example: /assets/djmixes/2025-06-15-summer-vibes/ableton.png
                           # Displayed below tracklist; clicking opens image in new tab (no lightbox)
mix_image_caption: string  # Caption for mix_image; inherits body font size (no override)

# OPTIONAL FIELDS (External Links & Social)

mixcloud_url: string       # Full URL to Mixcloud upload (if exists)
soundcloud_url: string     # Full URL to SoundCloud upload (if exists)
download_url: string       # Direct download link (if offering downloads)

# OPTIONAL FIELDS (SEO & Organization)

tags: array<string>        # Tags for categorization
  # Examples: [deep house, summer, 2025, vocal house]

classes: string            # Minimal Mistakes layout classes
                           # Default: "wide" (full-width content)
                           # Options: "wide", "wider", "full"

toc: boolean               # Table of contents (default: false)
                           # Set to true if mix description is long

# OPTIONAL FIELDS (Features - Future)

comments: boolean          # Enable Disqus comments (default: false)
                           # Future enhancement per Out of Scope section

share: boolean             # Show social sharing buttons (default: true)
---

# Mix description content (Markdown)

Optional freeform content describing the mix, story, or context.

## Tracklist

Optional tracklist in the format:
[00:00:02] Artist Name - Track Title
[00:05:21] Another Artist - Another Track [Remix Info]
...
```

### Field Specifications

#### Required Fields

| Field | Type | Validation | Description |
|-------|------|------------|-------------|
| `title` | string | Not empty | Display name of the mix |
| `date` | date | YYYY-MM-DD | Publication date (for sorting) |
| `audio_url` | URL | Valid HTTP/HTTPS | Full URL to audio file (Dropbox with dl=1, or S3/CloudFront) |
| `duration_seconds` | integer | > 0 | Total duration in seconds |

#### High Priority Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `excerpt` | string | null | Short description (1-2 sentences) |
| `waveform_file` | string | null | Filename in `assets/waveforms/` (e.g., "mix.dat") |

#### Metadata Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `header.cover` | URL/path | null | Cover art for mix page, grid/list views |
| `header.og_image` | URL/path | null | Social sharing image (Open Graph) |
| `duration_display` | string | null | Human-readable duration (H:MM:SS) |
| `genre` | string | null | Music genre or style |
| `mix_image` | path | null | Optional secondary image (DAW screenshot etc.); opens in new tab |
| `mix_image_caption` | string | null | Caption for `mix_image`; inherits body font size |

#### External Links

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `mixcloud_url` | URL | null | Mixcloud upload URL |
| `soundcloud_url` | URL | null | SoundCloud upload URL |
| `download_url` | URL | null | Direct download link |

#### Organization

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `tags` | array | [] | List of tags for categorization |
| `classes` | string | "wide" | Minimal Mistakes layout class |
| `toc` | boolean | false | Show table of contents |
| `comments` | boolean | false | Enable Disqus (future) |
| `share` | boolean | true | Show share buttons |

### Example: Complete Front Matter

```yaml
---
title: "Summer Vibes 2025 - Deep House Journey"
date: 2025-06-15
audio_url: "https://www.dropbox.com/scl/fi/abc123xyz/summer-vibes-2025.mp3?rlkey=xyz&dl=1"
duration_seconds: 5025
excerpt: "A 90-minute journey through deep house and melodic techno, perfect for summer evenings"
waveform_file: "summer-vibes-2025.dat"
duration: "1:23:45"
genre: "Deep House"
header:
  cover: /assets/images/mixes/covers/summer-vibes-2025.jpg
  og_image: /assets/images/mixes/covers/summer-vibes-2025.jpg
mixcloud_url: "https://www.mixcloud.com/andymadge/summer-vibes-2025/"
tags:
  - deep house
  - summer
  - melodic techno
  - 2025
classes: wide
share: true
---

A carefully curated selection of deep house and melodic techno tracks recorded live in June 2025. This mix captures the essence of summer with warm basslines, atmospheric pads, and uplifting melodies.

Perfect for sunset sessions, beach days, or late-night listening.

## Tracklist

[00:00:02] Nils Hoffmann - Breathing (Original Mix)
[00:05:21] Nosaj Thing & Julianna Barwick - Blue Hour
[00:08:41] Invisible Inc - Stars [Ambient Version]
[00:12:15] Lane 8 - Brightest Lights (feat. POLIÇA)
[00:17:30] Yotto - Hyperfall
...
```

---

## Entity: Track (Optional, for Live Highlighting)

When implementing P3 feature (live track highlighting), tracks are parsed from Markdown content, not stored in front matter.

### Format in Markdown Content
```
[HH:MM:SS] Artist Name - Track Title [Optional Info]
```

### Parsed JavaScript Object
```javascript
{
  timestamp: string,      // "00:05:21"
  timestampSeconds: number, // 321 (converted for comparison)
  artist: string,         // "Nosaj Thing & Julianna Barwick"
  title: string,          // "Blue Hour"
  metadata: string | null // "[Remix]", "[Ambient Version]", or null
}
```

### Parsing Rules
1. Find all lines matching pattern: `[HH:MM:SS] ... - ... `
2. Extract timestamp, artist, title
3. Optional metadata in brackets at end
4. Convert timestamp to seconds for comparison
5. Validate timestamps are chronological
6. Handle edge cases: missing tracks, overlaps, malformed lines

---

## Entity: Mix Position (localStorage)

Playback positions are stored client-side in browser localStorage.

### Storage Key
```
"andymadge_mixPositions"
```

### Data Structure
```javascript
{
  "positions": {
    "[mixId]": {
      "position": number,        // Playback position in seconds
      "duration": number,         // Total duration in seconds
      "lastPlayed": number,       // Unix timestamp (milliseconds)
      "title": string             // Mix title (for debugging)
    }
  },
  "version": number               // Schema version (currently 1)
}
```

### Example
```javascript
{
  "positions": {
    "summer-vibes-2025": {
      "position": 1234.5,
      "duration": 5025,
      "lastPlayed": 1732521600000,
      "title": "Summer Vibes 2025"
    },
    "winter-chill-2024": {
      "position": 890.2,
      "duration": 4200,
      "lastPlayed": 1732435200000,
      "title": "Winter Chill 2024"
    }
  },
  "version": 1
}
```

### Field Specifications

| Field | Type | Description |
|-------|------|-------------|
| `position` | float | Current playback position in seconds (with decimal precision) |
| `duration` | integer | Total mix duration in seconds (for validation) |
| `lastPlayed` | integer | Unix timestamp in milliseconds (for expiration check) |
| `title` | string | Human-readable title (optional, for debugging) |
| `version` | integer | Schema version for future migrations |

### State Transitions

```
[New Visitor] → No saved position → Start from 0:00
[Returning visitor] → Load saved position → Resume playback (no TTL expiry)
[>20 mixes saved, new save] → LRU eviction of oldest entry → Save new position
[localStorage unavailable] → No persistence → Start from 0:00
[Quota exceeded] → Cleanup oldest 25% of positions → Retry save
```
*(Updated 2026-02-21: no 90-day TTL — positions stored indefinitely, evicted by LRU cap only)*

---

## Relationships

### Mix → Audio File (External)
- **Type**: Reference (URL)
- **Cardinality**: 1:1 (each mix has one audio file)
- **Storage**: Audio file hosted on Dropbox (or S3/CloudFront for advanced users) - external to repository
- **Link**: `audio_url` field in front matter
- **Format**: Dropbox shareable link with `dl=1` parameter for direct download

### Mix → Waveform Data (Optional)
- **Type**: Reference (path)
- **Cardinality**: 1:0..1 (mix may have pre-generated waveform)
- **Storage**: Waveform `.dat` files in `assets/djmixes/{slug}/waveform.dat` (committed to repository)
- **Link**: `waveform_file` field in front matter (path relative to `assets/djmixes/`)
- **Fallback**: If missing or unavailable, waveform section collapsed entirely (no client-side generation)

### Mix → Tracks
- **Type**: Composition (embedded in Markdown content)
- **Cardinality**: 1:0..* (mix may have tracklist)
- **Storage**: Tracklist in Markdown body (parsed client-side for highlighting)
- **Format**: `[HH:MM:SS] Artist - Title` pattern

### Mix → Saved Position (localStorage)
- **Type**: Client-side state
- **Cardinality**: 1:0..1 per browser/device (position may not exist)
- **Storage**: Browser localStorage (per-device, per-browser)
- **Key**: Mix slug/filename used as identifier
- **Lifecycle**: Indefinite; LRU eviction when >20 mixes stored

---

## Validation Rules

### Jekyll Build-Time Validation

```yaml
# Required field presence check
- title: MUST be present and non-empty
- date: MUST be present and valid YYYY-MM-DD format
- audio_url: MUST be present and valid URL
- duration_seconds: MUST be present and > 0

# Optional field format check
- waveform_file: IF present, MUST match pattern *.dat
- header.cover: IF present, MUST be valid path or URL
- tags: IF present, MUST be array of strings
- genre: IF present, MUST be string
```

### Client-Side Validation

```javascript
// Waveform file existence
if (mix.waveform_file) {
  const waveformUrl = `/assets/waveforms/${mix.waveform_file}`;
  // Fetch waveform, fallback to client-side generation if 404
}

// Audio URL accessibility
// Handled by HTML5 audio player with error event

// Tracklist format
// Parse lines, skip malformed entries gracefully
```

### localStorage Validation

```javascript
// No TTL expiry — positions stored indefinitely
// LRU eviction only: if positions.length > 20, remove least-recently-used

// Position bounds check (still applies):

// Position bounds check
if (mixData.position > mixData.duration || mixData.position < 0) {
  // Invalid position, start from beginning
}

// Quota check
try {
  localStorage.setItem(key, value);
} catch (QuotaExceededError) {
  // Cleanup oldest positions, retry
}
```

---

## Data Flow

### Adding a New Mix

```
1. Create file: _djmixes/2025-06-15-summer-vibes.md
2. Add front matter: title, date, audio_url, duration_seconds, etc.
3. Upload audio to Dropbox, get shareable link with dl=1 parameter
4. Generate waveform: audiowaveform -i audio.mp3 -o assets/waveforms/summer-vibes.dat
5. Add waveform_file: "summer-vibes.dat" to front matter
6. Write tracklist in Markdown: [HH:MM:SS] Artist - Title
7. Commit to git
8. Jekyll generates: /music/summer-vibes/ page
9. Page loads: fetches audio from Dropbox, waveform from local assets
```

### Playback Flow

```
1. User visits /music/summer-vibes/
2. Page loads → Check localStorage for saved position
3. If found & < 90 days old → Load audio at saved position
4. Else → Load audio at 0:00
5. User plays/pauses → Save position to localStorage (throttled)
6. User closes page → Save final position on beforeunload
7. User returns → Resume from saved position (Step 2)
```

### Waveform Display Flow

```
1. Page loads → Check for waveform_file in front matter
2. If absent → Collapse waveform section; skip to audio player only
3. If present → Fetch /assets/djmixes/[waveform_file]
4. If 200 OK → Parse binary .dat header, normalize peaks, initialize WaveSurfer
5. If 404/error → Collapse waveform section (no client-side fallback generation)
6. User clicks waveform → Seek audio to timestamp
7. Audio plays → Update waveform progress indicator
```

---

## Migration & Versioning

### Current Version: 1

No migrations needed for initial implementation.

### Future Migration Scenarios

#### Adding New Required Field
```yaml
# If adding new required field (e.g., "category")
# Migration script needed to add default value to existing mixes
---
category: "uncategorized"  # Default for old mixes
---
```

#### localStorage Schema Change
```javascript
// If changing position data structure
// Check version field in stored data
if (data.version === 1) {
  // Migrate to version 2 format
  data = migrateV1toV2(data);
}
```

#### Waveform Format Change
```bash
# If changing from .dat to .json format
# Regenerate all waveforms with new format
for file in assets/waveforms/*.dat; do
  audiowaveform -i "${file%.dat}.mp3" -o "${file%.dat}.json" --format json
done
```

---

## Summary

This data model provides:

- ✅ **Content-first**: Plain text Markdown with YAML front matter
- ✅ **Version control friendly**: Text files, easy diffs, no binary data (except waveforms)
- ✅ **Static site compatible**: No database, all data in files
- ✅ **Extensible**: Easy to add new optional fields
- ✅ **Portable**: Standard Jekyll collections, works with any Jekyll theme
- ✅ **Client-side state**: localStorage for playback positions (no server needed)
- ✅ **Graceful degradation**: All optional features (waveform, tracklist, positions) degrade gracefully if unavailable

Next phase (quickstart.md) will document the practical workflow for adding mixes using this data model.
