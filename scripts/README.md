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
./scripts/add-mix.sh <audio_file> <mix_slug> "<title>"
```

**Example:**
```bash
./scripts/add-mix.sh audio_files/summer.mp3 summer-vibes "Summer Vibes 2025"
```

**What it does:**
1. ✅ Generates waveform data (.dat file)
2. ✅ Extracts audio duration automatically
3. ✅ Creates mix markdown file with front matter
4. ✅ Provides clear next steps for completion

**After running:**
- Upload audio to S3/CloudFront
- Update `audio_url` in the generated mix file
- Add description and tracklist
- Test locally with `bundle exec jekyll serve`
- Commit and push

---

### `generate-waveforms.sh` - Batch Generate Waveforms

Scans all mix files and generates missing waveforms.

**Usage:**
```bash
./scripts/generate-waveforms.sh [audio_directory]
```

**Example:**
```bash
# Default: looks for audio files in audio_files/
./scripts/generate-waveforms.sh

# Custom directory:
./scripts/generate-waveforms.sh ~/Music/DJ_Mixes
```

**What it does:**
1. 🔍 Scans `_djmixes/` for mix files with `waveform_file` field
2. ✅ Checks if waveform `.dat` file already exists
3. 🔍 Searches for matching audio file in specified directory
4. ⚙️ Generates missing waveforms using audiowaveform
5. 📊 Provides summary of generated/skipped/missing

**Use cases:**
- Regenerate all waveforms after changing settings
- Generate waveforms for mixes added manually
- Check which mixes are missing waveform data

---

## Workflow

### Adding a Single Mix

```bash
# 1. Run add-mix script
./scripts/add-mix.sh audio_files/my-mix.mp3 my-mix "My Amazing Mix"

# 2. Upload audio to S3/CloudFront
aws s3 cp audio_files/my-mix.mp3 s3://your-bucket/mixes/

# 3. Edit the generated mix file
vim _djmixes/2025-11-26-my-mix.md
# Update audio_url, add description, tracklist

# 4. Test locally
bundle exec jekyll serve

# 5. Commit and deploy
git add _djmixes/2025-11-26-my-mix.md assets/waveforms/my-mix.dat
git commit -m "Add new mix: My Amazing Mix"
git push
```

### Batch Generating Waveforms

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

---

## Directory Structure

```
scripts/
├── README.md                # This file
├── add-mix.sh              # Create new mix with waveform
└── generate-waveforms.sh   # Batch generate missing waveforms

audio_files/                # Local audio storage (not committed)
├── summer-vibes.mp3
└── winter-chill.m4a

_djmixes/                   # Mix content files (committed)
└── 2025-11-26-summer-vibes.md

assets/waveforms/           # Generated waveform data (committed)
└── summer-vibes.dat
```

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
