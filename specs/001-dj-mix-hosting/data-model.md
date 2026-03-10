# Data Model: DJ Mix Hosting

**Date**: 2025-11-25
**Phase**: 1 - Design & Contracts
**Status**: COMPLETE

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

### YAML Front Matter Schema

```yaml
---
# REQUIRED FIELDS

title: string              # Display title for the mix
date: YYYY-MM-DD           # Publication date (ISO 8601 format)
audio_url: string          # Full URL to hosted audio file (S3/CloudFront)
duration_seconds: integer  # Total duration in seconds (for waveform/player)

# OPTIONAL FIELDS (High Priority)

excerpt: string            # Short description (shown in list views, SEO meta)
waveform_file: string      # Filename of pre-generated waveform data (relative to assets/waveforms/)
                           # Example: "summer-2025.dat"

# OPTIONAL FIELDS (Metadata & Display)

header:
  image: string            # Full-width header image URL (optional)
  teaser: string           # Thumbnail/card image URL (shown in grid/list views)

duration: string           # Human-readable duration (e.g., "1:23:45")
genre: string              # Music genre (e.g., "Deep House", "Techno")
                     # Can use genres as tags for filtering

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
| `audio_url` | URL | Valid HTTP/HTTPS | Full URL to audio file (S3/CloudFront) |
| `duration_seconds` | integer | > 0 | Total duration in seconds |

#### High Priority Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `excerpt` | string | null | Short description (1-2 sentences) |
| `waveform_file` | string | null | Filename in `assets/waveforms/` (e.g., "mix.dat") |

#### Metadata Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `header.image` | URL | null | Full-width header image |
| `header.teaser` | URL | null | Thumbnail for grid/list views |
| `duration` | string | null | Human-readable duration (H:MM:SS) |
| `genre` | string | null | Music genre or style |

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
audio_url: "https://d1a2b3c4d5e6.cloudfront.net/mixes/summer-vibes-2025.mp3"
duration_seconds: 5025
excerpt: "A 90-minute journey through deep house and melodic techno, perfect for summer evenings"
waveform_file: "summer-vibes-2025.dat"
duration: "1:23:45"
genre: "Deep House"
header:
  image: /assets/images/mixes/headers/summer-vibes-2025.jpg
  teaser: /assets/images/mixes/teasers/summer-vibes-2025.jpg
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
[Returning < 90 days] → Load saved position → Resume playback
[Returning > 90 days] → Position expired → Start from 0:00
[localStorage unavailable] → No persistence → Start from 0:00
[Quota exceeded] → Cleanup oldest 25% → Retry save
```

---

## Relationships

### Mix → Audio File (External)
- **Type**: Reference (URL)
- **Cardinality**: 1:1 (each mix has one audio file)
- **Storage**: Audio file hosted on S3/CloudFront (external to repository)
- **Link**: `audio_url` field in front matter

### Mix → Waveform Data (Optional)
- **Type**: Reference (filename)
- **Cardinality**: 1:0..1 (mix may have pre-generated waveform)
- **Storage**: Waveform `.dat` files in `assets/waveforms/` (committed to repository)
- **Link**: `waveform_file` field in front matter
- **Fallback**: If missing, player shows simple progress bar

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
- **Lifecycle**: 90-day TTL from last playback

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
- header.teaser: IF present, MUST be valid path or URL
- tags: IF present, MUST be array of strings
- genre: IF present, MUST be string
```

### Client-Side Validation

```javascript
// Waveform file existence
if (mix.waveform_file) {
  const waveformUrl = `/assets/waveforms/${mix.waveform_file}`;
  // Fetch waveform, fallback to progress bar if 404
}

// Audio URL accessibility
// Handled by HTML5 audio player with error event

// Tracklist format
// Parse lines, skip malformed entries gracefully
```

### localStorage Validation

```javascript
// Expiration check
if (Date.now() - mixData.lastPlayed > 90 * 24 * 60 * 60 * 1000) {
  // Remove expired position
}

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
3. Generate waveform: audiowaveform -i audio.mp3 -o assets/waveforms/summer-vibes.dat
4. Add waveform_file: "summer-vibes.dat" to front matter
5. Write tracklist in Markdown: [HH:MM:SS] Artist - Title
6. Commit to git
7. Jekyll generates: /music/summer-vibes/ page
8. Page loads: fetches audio from S3, waveform from local assets
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
2. If present → Fetch /assets/waveforms/[filename]
3. If 200 OK → Initialize WaveSurfer with pre-generated peaks
4. If 404 → Fallback to simple progress bar
5. User clicks waveform → Seek audio to timestamp
6. Audio plays → Update waveform progress indicator
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
