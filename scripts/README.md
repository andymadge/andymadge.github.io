# Mix Management Scripts

Automation scripts for managing DJ mixes on the website.

## Prerequisites

- **audiowaveform** - For generating waveform data
  - macOS: `brew install audiowaveform`
  - Ubuntu/Debian: `sudo apt-get install audiowaveform`
  - Windows: Download from [GitHub releases](https://github.com/bbc/audiowaveform/releases)

- **ffmpeg/ffprobe** (optional) - For auto-detecting audio duration
  - macOS: `brew install ffmpeg`
  - Ubuntu/Debian: `sudo apt-get install ffmpeg`

## Scripts

### `add-mix.sh` - Create New Mix

Creates a complete mix entry with waveform generation.

**Usage:**
```bash
./scripts/add-mix.sh [options] <audio_file> <mix_slug> "<title>"
```

**Examples:**
```bash
# Create mix file and waveform from local file
./scripts/add-mix.sh audio_files/summer.mp3 summer-vibes "Summer Vibes 2025"

# Use URL as input - automatically sets audio_url field
./scripts/add-mix.sh "https://dropbox.com/.../mix.mp3?dl=1" my-mix "My Mix"

# Override auto-detected URL with custom one
./scripts/add-mix.sh --audio-url "https://cdn.example.com/mix.mp3" audio_files/mix.mp3 my-mix "My Mix"

# Print content only (useful for manual file creation)
./scripts/add-mix.sh --print-only audio_files/summer.mp3 summer-vibes "Summer Vibes 2025"

# Print with URL input (skips download in print-only mode)
./scripts/add-mix.sh --print-only "https://dropbox.com/.../mix.mp3?dl=1" my-mix "My Mix"
```

**What it does:**
1. ✅ Generates waveform data (.dat file) - skipped in `--print-only` mode
2. ✅ Extracts audio duration automatically
3. ✅ Creates mix markdown file with front matter (or prints to stdout)
4. ✅ Provides clear next steps for completion

**Options:**
- `--print-only`: Output mix file content to stdout without creating files or waveform. Useful when you want to manually create the mix file first with custom metadata fields, then copy-paste the generated content. When used with a URL input, skips downloading the audio file.
- `--audio-url <url>`: Override the `audio_url` field with a custom URL. By default, if the audio input is a URL, it's automatically used for `audio_url`. Use this option to specify a different URL (e.g., CDN URL while using local file for waveform generation).

**After running:**
- Upload audio to Dropbox, get shareable link with &dl=1 parameter
- Update `audio_url` in the generated mix file
- Add description and tracklist
- Test locally with `bundle exec jekyll serve`
- Commit and push

---

### `generate-waveforms.sh` - Batch Generate Waveforms

Scans all mix files and generates missing waveforms.

**Usage:**
```bash
# Local mode: use audio files from a directory
./scripts/generate-waveforms.sh [audio_directory]

# Remote mode: download from audio_url in mix files
./scripts/generate-waveforms.sh --remote
```

**Examples:**
```bash
# Default: looks for audio files in audio_files/
./scripts/generate-waveforms.sh

# Custom directory:
./scripts/generate-waveforms.sh ~/Music/DJ_Mixes

# Download from S3/CDN (uses audio_url from each mix file):
./scripts/generate-waveforms.sh --remote
```

**What it does:**
1. 🔍 Scans `_djmixes/` for mix files with `waveform_file` field
2. ✅ Checks if waveform `.dat` file already exists
3. 🎵 Gets audio file:
   - **Local mode**: Searches for matching file in specified directory
   - **Remote mode**: Downloads from `audio_url` in mix front matter
4. ⚙️ Generates missing waveforms using audiowaveform
5. 🧹 Cleans up downloaded files (remote mode only)
6. 📊 Provides summary of generated/skipped/missing

**Use cases:**
- **Local mode**: Before uploading audio to S3 (process local files)
- **Remote mode**: After uploading to S3 (download and process)
- Regenerate all waveforms after changing settings
- Generate waveforms for mixes added manually
- Check which mixes are missing waveform data

---

## Workflow

### Adding a Single Mix

```bash
# 1. Run add-mix script
./scripts/add-mix.sh audio_files/my-mix.mp3 my-mix "My Amazing Mix"

# 2. Upload audio to Dropbox
# - Use Dropbox app or web interface
# - Upload audio_files/my-mix.mp3 to any Dropbox folder
# - Get shareable link: right-click → Share → Copy link
# - Add &dl=1 parameter to the link

# 3. Edit the generated mix file
vim _djmixes/2025-11-26-my-mix.md
# Update audio_url with Dropbox link (include &dl=1), add description, tracklist

# 4. Test locally
bundle exec jekyll serve

# 5. Commit and deploy
git add _djmixes/2025-11-26-my-mix.md assets/waveforms/my-mix.dat
git commit -m "Add new mix: My Amazing Mix"
git push
```

### Batch Generating Waveforms

**Option 1: From local audio files (before S3 upload)**
```bash
# Place audio files in audio_files/ directory
cp ~/Downloads/*.mp3 audio_files/

# Generate all missing waveforms
./scripts/generate-waveforms.sh audio_files

# Review and commit
git status
git add assets/waveforms/*.dat
git commit -m "Generate waveforms for recent mixes"
```

**Option 2: Download from S3/CDN (after upload)**
```bash
# Ensure audio_url is set in all mix files
# Then download and generate waveforms
./scripts/generate-waveforms.sh --remote

# Review and commit
git status
git add assets/waveforms/*.dat
git commit -m "Generate waveforms from hosted audio files"
```

---

## Directory Structure

```
scripts/
├── README.md                # This file
├── add-mix.sh              # Create new mix with waveform
└── generate-waveforms.sh   # Batch generate missing waveforms

audio_files/                # Local audio storage (gitignored, not committed)
├── summer-vibes.mp3        # Audio files hosted on Dropbox, kept locally
└── winter-chill.m4a        # for waveform generation only

.tmp/                       # Temporary downloads (gitignored, auto-created)
└── audio/                  # Downloaded files (--remote mode)

_djmixes/                   # Mix content files (committed)
└── 2025-11-26-summer-vibes.md

assets/waveforms/           # Generated waveform data (committed)
└── summer-vibes.dat
```

---

## Audio Hosting Options

### Primary: Dropbox (Recommended for Most Users)

**Pros:**
- Free (2GB storage limit)
- Simple file management
- No AWS account needed
- Sufficient for personal blogs (20GB/day bandwidth)

**Setup:**
1. Upload audio files to Dropbox
2. Get shareable link (right-click → Share)
3. Add `&dl=1` parameter for direct download
4. Use link in mix front matter

**Example link:**
```
https://www.dropbox.com/scl/fi/abc123xyz/mix.mp3?rlkey=xyz&dl=1
```

### Alternative: S3/CloudFront (For Scaling)

**When to migrate:**
- Traffic exceeds 20GB/day
- Need CDN performance
- Commercial use
- Advanced analytics needed

**See**: `quickstart.md` Appendix A for full S3/CloudFront setup instructions

**Cost:** $1-5/month after AWS free tier (vs $0 for Dropbox)

---

## Tips

- **Audio files**: Keep local copies in `audio_files/` for waveform generation, but don't commit them (large files)
- **Waveform data**: Commit `.dat` files to the repo (typically < 1MB each)
- **Naming convention**: Use same slug for audio file, waveform file, and mix file
- **Automation**: Run `generate-waveforms.sh` as part of your pre-commit workflow

---

## Troubleshooting

### audiowaveform command not found

Install audiowaveform:
```bash
# macOS
brew install audiowaveform

# Ubuntu/Debian
sudo apt-get install audiowaveform
```

### No audio files found

The script looks for audio files matching the mix slug:
- `2025-11-26-summer-vibes.md` → looks for `summer-vibes.{mp3,m4a,aac,flac,wav}`
- Place audio files in the directory specified when running the script
- Use the full filename including date prefix if needed

### Duration shows UNKNOWN

Install ffmpeg for automatic duration detection:
```bash
# macOS
brew install ffmpeg

# Ubuntu/Debian
sudo apt-get install ffmpeg
```

Or manually add `duration_seconds` to the mix front matter.
