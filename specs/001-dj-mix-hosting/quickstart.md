# Quickstart: Adding a New DJ Mix

**Date**: 2025-11-25
**Phase**: 1 - Design & Contracts
**Audience**: Content author (you!)

This guide walks through adding a new DJ mix to your personal blog, from audio file to published page.

---

## Prerequisites

- Jekyll site running locally (`bundle exec jekyll serve`)
- Audio file (MP3 or AAC/M4A format)
- Cover art image (optional but recommended)
- Tracklist with timestamps (optional)
- AWS S3 + CloudFront account (or alternative hosting)
- BBC audiowaveform tool installed (for waveform generation)

---

## Step 1: Prepare Audio File

### 1.1 Upload to S3/CloudFront

```bash
# Example using AWS CLI
aws s3 cp summer-vibes-2025.mp3 s3://your-bucket/mixes/

# Get CloudFront URL (configured during setup)
# Example: https://d1a2b3c4d5e6.cloudfront.net/mixes/summer-vibes-2025.mp3
```

**Note**: If using Dropbox initially (not recommended for production), use `?raw=1` parameter:
```
https://www.dropbox.com/s/abc123/summer-vibes-2025.mp3?raw=1
```

### 1.2 Get Audio Duration

```bash
# Using ffprobe (part of FFmpeg)
ffprobe -v error -show_entries format=duration \
  -of default=noprint_wrappers=1:nokey=1 summer-vibes-2025.mp3

# Output: 5025.28 (seconds)
# Round to integer: 5025
```

Or use any audio player/editor to check duration.

---

## Step 2: Generate Waveform Data

### 2.1 Install audiowaveform (First Time Only)

**macOS**:
```bash
brew install audiowaveform
```

**Ubuntu/Debian**:
```bash
sudo apt-get install audiowaveform
```

**Windows**: Download from [GitHub releases](https://github.com/bbc/audiowaveform/releases)

### 2.2 Generate Waveform File

```bash
# Generate binary waveform data
audiowaveform -i summer-vibes-2025.mp3 \
              -o assets/waveforms/summer-vibes-2025.dat \
              -b 8 \
              -z 256

# Parameters explained:
# -i: Input audio file
# -o: Output waveform file (.dat extension)
# -b 8: 8-bit depth (smaller file size, recommended)
# -z 256: Zoom level (172 data points per second at 44.1kHz)
```

**Expected output**: File size ~800KB-1MB for a 60-minute mix

---

## Step 3: Prepare Cover Art (Optional)

### 3.1 Resize Images

**Recommended sizes**:
- **Teaser**: 400x400px (for list/grid views)
- **Header**: 1200x400px (for full-width header on mix page)

```bash
# Using ImageMagick
convert original-cover.jpg -resize 400x400^ -gravity center \
  -extent 400x400 assets/images/mixes/teasers/summer-vibes-2025.jpg

convert original-cover.jpg -resize 1200x400^ -gravity center \
  -extent 1200x400 assets/images/mixes/headers/summer-vibes-2025.jpg
```

Or use any image editor (Photoshop, GIMP, etc.).

### 3.2 Optimize Images

```bash
# Optimize JPEGs
jpegoptim --max=85 assets/images/mixes/**/*.jpg

# Or use online tools: TinyPNG, ImageOptim, etc.
```

---

## Step 4: Create Mix Content File

### 4.1 Create File with Date Prefix

```bash
# File naming: YYYY-MM-DD-mix-slug.md
cd _djmixes/
touch 2025-06-15-summer-vibes.md
```

### 4.2 Add Front Matter

Edit `_djmixes/2025-06-15-summer-vibes.md`:

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
[00:22:45] Ben Böhmer - Beyond Beliefs
[00:28:10] Tinlicker - Be Here And Now
[00:33:50] Cubicolor - Got This Feeling
[00:39:20] Le Youth - C O O L
[00:44:30] Marsh - Lailonie
[00:49:50] Moon Boots - Keep The Faith
[00:55:10] Croquet Club - Caprice
[01:00:25] RÜFÜS DU SOL - Underwater
[01:05:40] Yotto - The One You Left Behind
[01:11:15] Lane 8 - Fingerprint
[01:16:50] Nils Hoffmann - Breathing (Reprise)
```

### 4.3 Required vs Optional Fields

**Required**:
- `title`
- `date`
- `audio_url`
- `duration_seconds`

**Highly Recommended**:
- `excerpt` (for SEO and list views)
- `waveform_file` (for interactive waveform)
- `header.teaser` (for visual appeal)

**Optional**:
- `header.image`
- `duration` (human-readable)
- `genre`
- `tags`
- External links (mixcloud_url, soundcloud_url, download_url)

---

## Step 5: Test Locally

### 5.1 Start Jekyll Server

```bash
bundle exec jekyll serve
```

### 5.2 Access Mix Page

```
http://localhost:4000/music/summer-vibes/
```

### 5.3 Verify

- [ ] Mix page loads without errors
- [ ] Audio player displays
- [ ] Waveform renders (or shows progress bar if missing)
- [ ] Play/pause buttons work
- [ ] Audio streams from S3/CloudFront
- [ ] Tracklist displays (if provided)
- [ ] Cover art shows in header/teaser
- [ ] Page appears in `/music/` index

### 5.4 Check Browser Console

- No JavaScript errors
- Audio loads successfully
- Waveform data loads (check Network tab)

### 5.5 Test Mobile

```bash
# Access from mobile device on same network
# Find your local IP:
ifconfig | grep "inet " | grep -v 127.0.0.1

# Access: http://YOUR_LOCAL_IP:4000/music/summer-vibes/
```

---

## Step 6: Commit and Deploy

### 6.1 Add Files to Git

```bash
git add _djmixes/2025-06-15-summer-vibes.md
git add assets/waveforms/summer-vibes-2025.dat
git add assets/images/mixes/teasers/summer-vibes-2025.jpg
git add assets/images/mixes/headers/summer-vibes-2025.jpg
```

### 6.2 Commit

```bash
git commit -m "Add new mix: Summer Vibes 2025

- Deep house and melodic techno mix
- Duration: 1:23:45
- Includes waveform data and cover art
- 17-track tracklist with timestamps"
```

### 6.3 Push to Master

```bash
git push origin master
```

GitHub Pages will automatically build and deploy (1-3 minutes).

### 6.4 Verify Production

```
https://www.andymadge.com/music/summer-vibes/
```

---

## Common Issues & Troubleshooting

### Audio Doesn't Play

**Symptom**: Player shows but audio won't load
**Causes**:
- CORS issue with audio host
- Invalid audio URL
- Unsupported audio format

**Solutions**:
1. Check browser console for errors
2. Verify audio URL works in new tab
3. Ensure S3/CloudFront has CORS enabled
4. Test with different audio format (MP3 vs AAC)

### Waveform Doesn't Display

**Symptom**: Simple progress bar instead of waveform
**Causes**:
- Waveform file not generated
- Wrong filename in front matter
- File not committed to git

**Solutions**:
1. Check `assets/waveforms/[filename].dat` exists
2. Verify `waveform_file` matches actual filename
3. Re-run `audiowaveform` command if needed
4. Fallback is intentional - audio still works

### Mix Not in Index

**Symptom**: Mix page works, but doesn't appear in `/music/` listing
**Causes**:
- Missing `date` field
- File not in `_djmixes/` directory
- Jekyll collection not configured

**Solutions**:
1. Add `date: YYYY-MM-DD` to front matter
2. Move file to `_djmixes/` directory
3. Rebuild Jekyll: `bundle exec jekyll clean && bundle exec jekyll serve`

### Position Doesn't Save

**Symptom**: Playback position resets on page reload
**Causes**:
- Private browsing mode (localStorage disabled)
- JavaScript errors preventing save
- Browser security settings

**Solutions**:
1. Test in normal (non-private) browser window
2. Check browser console for JavaScript errors
3. Verify localStorage is enabled in browser settings
4. This is optional feature - graceful degradation is expected

---

## Quick Reference

### Minimum Viable Mix (No Waveform, No Cover Art)

```yaml
---
title: "Quick Test Mix"
date: 2025-06-15
audio_url: "https://example.com/mix.mp3"
duration_seconds: 3600
---

Simple mix with no extras.
```

Generates functional page at `/music/quick-test-mix/` with basic audio player.

### Full-Featured Mix

```yaml
---
title: "Full Example Mix"
date: 2025-06-15
audio_url: "https://cloudfront.net/mix.mp3"
duration_seconds: 5025
excerpt: "Complete example with all features"
waveform_file: "example.dat"
duration: "1:23:45"
genre: "House"
header:
  image: /assets/images/mixes/headers/example.jpg
  teaser: /assets/images/mixes/teasers/example.jpg
mixcloud_url: "https://mixcloud.com/..."
tags: [house, 2025]
---

Full description with tracklist.

## Tracklist
[00:00] Artist - Track
...
```

---

## Automation Ideas (Future)

### Script to Generate Mix from Audio File

```bash
#!/bin/bash
# add-mix.sh - Automate mix creation

AUDIO_FILE=$1
MIX_SLUG=$2
TITLE=$3

# Get duration
DURATION=$(ffprobe -v error -show_entries format=duration \
  -of default=noprint_wrappers=1:nokey=1 "$AUDIO_FILE" | cut -d. -f1)

# Generate waveform
audiowaveform -i "$AUDIO_FILE" -o "assets/waveforms/${MIX_SLUG}.dat" -b 8 -z 256

# Create mix file
DATE=$(date +%Y-%m-%d)
cat > "_djmixes/${DATE}-${MIX_SLUG}.md" <<EOF
---
title: "$TITLE"
date: $DATE
audio_url: "REPLACE_WITH_S3_URL"
duration_seconds: $DURATION
waveform_file: "${MIX_SLUG}.dat"
---

Mix description here.
EOF

echo "Created: _djmixes/${DATE}-${MIX_SLUG}.md"
echo "TODO: Upload audio to S3 and update audio_url"
```

Usage:
```bash
./add-mix.sh summer-2025.mp3 summer-vibes "Summer Vibes 2025"
```

---

## Next Steps

After adding your first mix:

1. **Test all features**: Play, pause, seek, waveform interaction
2. **Check mobile**: Verify responsive design on phone/tablet
3. **Monitor analytics**: See how visitors interact with mixes
4. **Iterate**: Add more mixes, refine tracklist format, improve descriptions
5. **Future enhancements**: Implement P2 (waveform), P3 (track highlighting), P4 (persistence)

For implementation details, see:
- `data-model.md` - Full schema documentation
- `contracts/` - JavaScript module specifications
- `research.md` - Technical decision rationale

Happy mixing! 🎵
