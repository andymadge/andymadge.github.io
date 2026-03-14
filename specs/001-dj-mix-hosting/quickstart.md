# Quickstart: Adding a New DJ Mix

**Date**: 2025-11-25 | **Updated**: 2026-02-21
**Phase**: 1 - Design & Contracts
**Audience**: Content author (you!)

This guide walks through adding a new DJ mix to your personal blog, from audio file to published page.

---

## Prerequisites

- Jekyll site running locally (`bundle exec jekyll serve`)
- Audio file (MP3 or AAC/M4A format)
- Cover art image (optional but recommended)
- Tracklist with timestamps (optional)
- Dropbox account (free tier sufficient)
- BBC audiowaveform tool installed (for waveform generation)

---

## Step 1: Prepare Audio File

### 1.1 Upload to Dropbox and Get Shareable Link

```bash
# 1. Upload audio file to Dropbox
# - Use Dropbox desktop app, web interface, or mobile app
# - Recommended location: /Apps/DJ Mixes/ or any organized folder

# 2. Get shareable link
# - Right-click file in Dropbox → "Share" or "Copy link"
# - You'll get a link like:
#   https://www.dropbox.com/scl/fi/abc123xyz/summer-vibes-2025.mp3?rlkey=xyz&st=abc

# 3. Convert to direct download link by adding &dl=1
# Example original link:
https://www.dropbox.com/scl/fi/abc123xyz/summer-vibes-2025.mp3?rlkey=xyz&st=abc

# Example direct download link (add &dl=1):
https://www.dropbox.com/scl/fi/abc123xyz/summer-vibes-2025.mp3?rlkey=xyz&st=abc&dl=1
```

**IMPORTANT**: Always add `&dl=1` (or `?dl=1` if no other parameters) to force direct download/streaming instead of Dropbox preview page. The `add-mix.sh` script handles this automatically when a Dropbox URL is provided.

**Link format variations:**
- **New format** (current): `...dropbox.com/scl/fi/...?rlkey=...&dl=1`
- **Old format** (legacy): `...dropbox.com/s/...?dl=1`

Both formats work as long as you include the `dl=1` parameter.

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
# Generate binary waveform data (Updated 2026-02-21: correct output path)
mkdir -p assets/djmixes/2025-06-15-summer-vibes
audiowaveform -i summer-vibes-2025.mp3 \
              -o assets/djmixes/2025-06-15-summer-vibes/waveform.dat \
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
- **Cover**: 400x400px (for mix page display, grid/list views, and social sharing)

```bash
# Using ImageMagick
convert original-cover.jpg -resize 400x400^ -gravity center \
  -extent 400x400 assets/images/mixes/covers/summer-vibes-2025.jpg
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
audio_url: "https://www.dropbox.com/scl/fi/abc123xyz/summer-vibes-2025.mp3?rlkey=xyz&dl=1"
duration_seconds: 5025
excerpt: "A 90-minute journey through deep house and melodic techno, perfect for summer evenings"
waveform_file: "2025-06-15-summer-vibes/waveform.dat"
duration_display: "1:23:45"
genre: "Deep House"
# cover: /assets/djmixes/2025-06-15-summer-vibes/cover.png
# og_image: /assets/djmixes/2025-06-15-summer-vibes/cover.png
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
- `header.cover` (cover art for mix page, grid views, and social sharing)

**Optional**:
- `header.og_image` (if different from cover for social sharing)
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
- [ ] Audio streams from Dropbox (verify dl=1 parameter is present)
- [ ] Tracklist displays (if provided)
- [ ] Cover art shows on mix page and in grid view
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

## Dev-Only Mixes (Local Testing Only)

If you want a mix to appear locally for development but **never be pushed to the repo**, prefix both the mix file and its asset folder with `dev-`:

```
_djmixes/dev-my-test-mix.md
assets/djmixes/dev-my-test-mix/waveform.dat
```

Both patterns are in `.gitignore` (`_djmixes/dev-*` and `assets/djmixes/dev-*/`), so git will never track them. The mix still renders in Jekyll locally as normal.

> Use this for test fixtures, placeholder mixes, or anything you want to experiment with without it ever going to production.

---

## Step 6: Commit and Deploy

### 6.1 Add Files to Git

```bash
git add _djmixes/2025-06-15-summer-vibes.md
git add assets/waveforms/summer-vibes-2025.dat
git add assets/images/mixes/covers/summer-vibes-2025.jpg
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
- Invalid audio URL or missing dl=1 parameter
- Unsupported audio format
- CORS issue with audio host

**Solutions**:
1. Check browser console for errors
2. Verify audio URL works in new tab (should download, not show preview)
3. **Dropbox users**: Ensure URL has `dl=1` parameter (not `dl=0`)
4. **Dropbox users**: If using old share link format, regenerate a new share link
5. Test with different audio format (MP3 vs AAC)
6. For advanced needs, consider S3/CloudFront (see Appendix A)

### Waveform Doesn't Display or Loads Slowly

**Symptom**: Waveform takes time to appear or shows generic waveform
**Causes**:
- Waveform file not generated (falling back to client-side generation)
- Wrong filename in front matter
- File not committed to git
- Large audio file causing slow client-side generation

**Solutions**:
1. Check `assets/waveforms/[filename].dat` exists
2. Verify `waveform_file` matches actual filename
3. Re-run `audiowaveform` command if needed
4. For long mixes, pre-generated waveform is strongly recommended for performance
5. Client-side generation is intentional fallback (per FR-013) - audio still works

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
audio_url: "https://www.dropbox.com/scl/fi/abc123xyz/mix.mp3?rlkey=xyz&dl=1"
duration_seconds: 5025
excerpt: "Complete example with all features"
waveform_file: "example.dat"
duration: "1:23:45"
genre: "House"
header:
  cover: /assets/images/mixes/covers/example.jpg
  og_image: /assets/images/mixes/covers/example.jpg
mixcloud_url: "https://mixcloud.com/..."
tags: [house, 2025]
---

Full description with tracklist.

## Tracklist
[00:00] Artist - Track
...
```

---

## Automation Scripts

The manual steps above can be automated using the provided scripts in the `scripts/` directory.

### Quick Mix Creation

Use `add-mix.sh` to automate waveform generation and file creation:

```bash
# Basic usage (local file)
./scripts/add-mix.sh summer-vibes-2025.mp3 "Summer Vibes 2025"

# With a Dropbox URL (dl=1 normalised automatically)
./scripts/add-mix.sh --audio-url "https://www.dropbox.com/.../mix.mp3?rlkey=...&dl=1" summer-vibes-2025.mp3 "Summer Vibes 2025"

# Print-only mode (outputs to stdout, no files created)
./scripts/add-mix.sh --print-only summer-vibes-2025.mp3 "Summer Vibes 2025"
```

This automatically:
- ✅ Generates waveform data
- ✅ Extracts audio duration
- ✅ Creates mix file with front matter
- ✅ Provides next steps

### Batch Waveform Generation

Use `generate-waveforms.sh` to scan for missing waveforms:

```bash
./scripts/generate-waveforms.sh audio_files/
```

This automatically:
- 🔍 Scans all mix files
- ✅ Generates missing waveforms
- 📊 Shows summary report

### Full Documentation

See `scripts/README.md` for:
- Complete usage instructions
- Prerequisites and installation
- Workflow examples
- Troubleshooting

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

---

## Appendix A: Alternative Hosting - S3/CloudFront

For users who need professional CDN performance, unlimited bandwidth, or are experiencing Dropbox limitations, you can migrate to Amazon S3 + CloudFront.

### When to Use S3/CloudFront Instead of Dropbox

Consider migration if you experience:
- Traffic exceeding 20GB/day (Dropbox bandwidth limit)
- Slow loading times or unreliable streaming
- Need for guaranteed CORS support
- Commercial/viral content requiring CDN
- Advanced analytics requirements

### S3/CloudFront Setup

**Prerequisites:**
- AWS account (free tier available)
- AWS CLI installed (optional, can use web console)

**Step 1: Create S3 Bucket**

```bash
# Using AWS CLI
aws s3 mb s3://your-mixes-bucket
aws s3 cp summer-vibes-2025.mp3 s3://your-mixes-bucket/mixes/

# Or use AWS Console:
# 1. Go to S3 console
# 2. Create bucket (name must be globally unique)
# 3. Upload audio files to /mixes/ folder
```

**Step 2: Create CloudFront Distribution**

```bash
# Using AWS Console:
# 1. Go to CloudFront console
# 2. Create distribution
# 3. Origin domain: your-mixes-bucket.s3.amazonaws.com
# 4. Origin path: /mixes
# 5. Viewer protocol policy: Redirect HTTP to HTTPS
# 6. Wait 10-15 minutes for deployment
```

**Step 3: Configure CORS (Optional)**

```bash
# Add CORS configuration to S3 bucket
# (Usually not needed for audio streaming, but helpful for troubleshooting)

cat > cors-config.json <<EOF
{
  "CORSRules": [
    {
      "AllowedOrigins": ["https://www.andymadge.com"],
      "AllowedMethods": ["GET", "HEAD"],
      "AllowedHeaders": ["*"],
      "MaxAgeSeconds": 3600
    }
  ]
}
EOF

aws s3api put-bucket-cors --bucket your-mixes-bucket --cors-configuration file://cors-config.json
```

**Step 4: Update Mix Files**

```bash
# Get CloudFront distribution URL (e.g., d1a2b3c4d5e6.cloudfront.net)
# Update audio_url in your mix files:

# Before (Dropbox):
audio_url: "https://www.dropbox.com/scl/fi/abc/mix.mp3?dl=1"

# After (CloudFront):
audio_url: "https://d1a2b3c4d5e6.cloudfront.net/summer-vibes-2025.mp3"
```

**Step 5: Test and Deploy**

```bash
# Test locally
bundle exec jekyll serve

# Verify CloudFront URL works:
curl -I https://d1a2b3c4d5e6.cloudfront.net/summer-vibes-2025.mp3

# Commit changes
git add _djmixes/*.md
git commit -m "Migrate audio hosting from Dropbox to CloudFront"
git push
```

### Cost Estimate

**AWS Free Tier (first 12 months):**
- S3: 5GB storage, 20,000 GET requests
- CloudFront: 50GB data transfer out

**After free tier (typical personal blog):**
- S3 storage: $0.023/GB/month (~$0.50 for 20 mixes)
- CloudFront transfer: $0.085/GB (~$1-3/month for typical traffic)
- **Total**: $1-5/month depending on traffic

**Dropbox comparison:**
- Free: 2GB storage limit, 20GB/day bandwidth
- Paid: $11.99/month for 2TB (overkill for mixes)

### Migration Checklist

- [ ] Create AWS account
- [ ] Set up S3 bucket and upload files
- [ ] Create CloudFront distribution
- [ ] Test CloudFront URLs in browser
- [ ] Update audio_url in all mix files
- [ ] Test locally with Jekyll
- [ ] Deploy to GitHub Pages
- [ ] Verify all mixes play correctly
- [ ] (Optional) Delete files from Dropbox

---

Happy mixing! 🎵
