#!/bin/bash
# add-mix.sh - Automate mix creation with waveform generation
#
# Usage:
#   ./scripts/add-mix.sh <audio_file> <mix_slug> "<title>"
#
# Example:
#   ./scripts/add-mix.sh audio_files/summer.mp3 summer-vibes "Summer Vibes 2025"
#
# This script:
# 1. Generates waveform data from audio file
# 2. Extracts audio duration
# 3. Creates mix markdown file with front matter
# 4. Provides next steps for uploading audio and publishing

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
AUDIO_FILE="$1"
MIX_SLUG="$2"
TITLE="$3"

# Validate arguments
if [ -z "$AUDIO_FILE" ] || [ -z "$MIX_SLUG" ] || [ -z "$TITLE" ]; then
    echo -e "${RED}Error: Missing required arguments${NC}"
    echo ""
    echo "Usage: $0 <audio_file> <mix_slug> \"<title>\""
    echo ""
    echo "Example:"
    echo "  $0 audio_files/summer.mp3 summer-vibes \"Summer Vibes 2025\""
    exit 1
fi

# Check if audio file exists
if [ ! -f "$AUDIO_FILE" ]; then
    echo -e "${RED}Error: Audio file not found: $AUDIO_FILE${NC}"
    exit 1
fi

# Check if audiowaveform is installed
if ! command -v audiowaveform &> /dev/null; then
    echo -e "${RED}Error: audiowaveform is not installed${NC}"
    echo "Install with:"
    echo "  macOS:   brew install audiowaveform"
    echo "  Ubuntu:  sudo apt-get install audiowaveform"
    exit 1
fi

# Check if ffprobe is installed (for duration)
if ! command -v ffprobe &> /dev/null; then
    echo -e "${YELLOW}Warning: ffprobe not found (install ffmpeg)${NC}"
    echo "Duration will need to be added manually"
    DURATION=""
else
    # Get audio duration in seconds
    DURATION=$(ffprobe -v error -show_entries format=duration \
      -of default=noprint_wrappers=1:nokey=1 "$AUDIO_FILE" 2>/dev/null | cut -d. -f1)

    if [ -z "$DURATION" ]; then
        echo -e "${YELLOW}Warning: Could not extract duration${NC}"
    fi
fi

# Create directories if needed
mkdir -p _djmixes
mkdir -p assets/waveforms

# Generate date and filenames
DATE=$(date +%Y-%m-%d)
MIX_FILE="_djmixes/${DATE}-${MIX_SLUG}.md"
WAVEFORM_FILE="${MIX_SLUG}.dat"
WAVEFORM_PATH="assets/waveforms/${WAVEFORM_FILE}"

echo -e "${BLUE}=== Adding New Mix ===${NC}\n"
echo "Title:     $TITLE"
echo "Slug:      $MIX_SLUG"
echo "Date:      $DATE"
echo "Audio:     $AUDIO_FILE"
echo "Duration:  ${DURATION:-UNKNOWN} seconds"
echo ""

# Check if mix file already exists
if [ -f "$MIX_FILE" ]; then
    echo -e "${RED}Error: Mix file already exists: $MIX_FILE${NC}"
    exit 1
fi

# Generate waveform
echo -e "${BLUE}⟳${NC} Generating waveform data..."
if audiowaveform -i "$AUDIO_FILE" -o "$WAVEFORM_PATH" -b 8 -z 256 2>&1 | grep -q .; then
    echo -e "${GREEN}✓${NC} Waveform generated: $WAVEFORM_PATH"
else
    echo -e "${RED}✗${NC} Failed to generate waveform"
    exit 1
fi

# Format duration as H:MM:SS or M:SS
format_duration() {
    local total_seconds=$1
    local hours=$((total_seconds / 3600))
    local minutes=$(((total_seconds % 3600) / 60))
    local seconds=$((total_seconds % 60))

    if [ $hours -gt 0 ]; then
        printf "%d:%02d:%02d" $hours $minutes $seconds
    else
        printf "%d:%02d" $minutes $seconds
    fi
}

DURATION_FORMATTED=""
if [ -n "$DURATION" ]; then
    DURATION_FORMATTED=$(format_duration "$DURATION")
fi

# Create mix file with front matter
cat > "$MIX_FILE" <<EOF
---
title: "$TITLE"
date: $DATE
audio_url: "REPLACE_WITH_S3_OR_CDN_URL"
duration_seconds: ${DURATION:-3600}
excerpt: "Add a short description here (1-2 sentences)"
waveform_file: "$WAVEFORM_FILE"
${DURATION_FORMATTED:+duration: \"$DURATION_FORMATTED\"}
header:
  teaser: /assets/images/mixes/teasers/${MIX_SLUG}.jpg  # Optional
classes: wide
share: true
---

Add your mix description here. You can use Markdown formatting.

## Tracklist

[00:00:00] Artist Name - Track Title
[00:05:30] Another Artist - Another Track
<!-- Add more tracks with timestamps -->
EOF

echo -e "${GREEN}✓${NC} Mix file created: $MIX_FILE"
echo ""

# Show next steps
echo -e "${BLUE}=== Next Steps ===${NC}"
echo ""
echo -e "${YELLOW}1. Upload audio file to hosting:${NC}"
echo "   • Upload $AUDIO_FILE to S3/CloudFront"
echo "   • Update audio_url in $MIX_FILE"
echo ""
echo -e "${YELLOW}2. (Optional) Add cover art:${NC}"
echo "   • Create teaser image (400x400px)"
echo "   • Save to: assets/images/mixes/teasers/${MIX_SLUG}.jpg"
echo ""
echo -e "${YELLOW}3. Edit mix file:${NC}"
echo "   • Add description and tracklist"
echo "   • Update excerpt field"
echo "   • Edit: $MIX_FILE"
echo ""
echo -e "${YELLOW}4. Test locally:${NC}"
echo "   bundle exec jekyll serve"
echo "   Visit: http://localhost:4000/music/${MIX_SLUG}/"
echo ""
echo -e "${YELLOW}5. Commit and push:${NC}"
echo "   git add $MIX_FILE"
echo "   git add $WAVEFORM_PATH"
echo "   git commit -m \"Add new mix: $TITLE\""
echo "   git push"
echo ""
echo -e "${GREEN}Done!${NC} Mix scaffolding created successfully."
