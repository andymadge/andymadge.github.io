#!/bin/bash
# add-mix.sh - Automate mix creation with waveform generation
#
# Usage:
#   ./scripts/add-mix.sh <audio_file_or_url> <mix_slug> "<title>"
#
# Examples:
#   ./scripts/add-mix.sh audio_files/summer.mp3 summer-vibes "Summer Vibes 2025"
#   ./scripts/add-mix.sh "https://example.com/mix.mp3" summer-vibes "Summer Vibes 2025"
#
# This script:
# 1. Downloads audio file if URL provided (or uses local file)
# 2. Generates waveform data from audio file
# 3. Extracts audio duration
# 4. Creates mix markdown file with front matter
# 5. Provides next steps for uploading audio and publishing

set -e  # Exit on error

VERSION="1.0.0"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Show help
show_help() {
    echo "add-mix.sh v${VERSION} - Automate mix creation with waveform generation"
    echo ""
    echo "Usage:"
    echo "  ./scripts/add-mix.sh <audio_file_or_url> <mix_slug> \"<title>\""
    echo "  ./scripts/add-mix.sh --help"
    echo "  ./scripts/add-mix.sh --version"
    echo ""
    echo "Arguments:"
    echo "  <audio_file_or_url>  Path to local audio file or URL to download"
    echo "  <mix_slug>           URL-friendly identifier (e.g., summer-vibes)"
    echo "  <title>              Mix title (quoted if contains spaces)"
    echo ""
    echo "Options:"
    echo "  --help               Show this help message"
    echo "  --version            Show version information"
    echo ""
    echo "Examples:"
    echo "  ./scripts/add-mix.sh audio_files/summer.mp3 summer-vibes \"Summer Vibes 2025\""
    echo "  ./scripts/add-mix.sh \"https://example.com/mix.mp3\" summer-vibes \"Summer Vibes 2025\""
    echo ""
    echo "This script will:"
    echo "  1. Download audio file if URL provided (or use local file)"
    echo "  2. Generate waveform data from audio file"
    echo "  3. Extract audio duration"
    echo "  4. Create mix markdown file with front matter"
    echo "  5. Provide next steps for uploading audio and publishing"
}

# Check for help/version flags
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    echo "add-mix.sh v${VERSION}"
    exit 0
fi

# Parse arguments
AUDIO_INPUT="$1"
MIX_SLUG="$2"
TITLE="$3"

# Validate arguments
if [ -z "$AUDIO_INPUT" ] || [ -z "$MIX_SLUG" ] || [ -z "$TITLE" ]; then
    echo -e "${RED}Error: Missing required arguments${NC}"
    echo ""
    echo "Usage: $0 <audio_file_or_url> <mix_slug> \"<title>\""
    echo ""
    echo "For more information, run: $0 --help"
    exit 1
fi

# Check if input is a URL or local file
TEMP_FILE=""
if [[ "$AUDIO_INPUT" =~ ^https?:// ]]; then
    echo -e "${BLUE}⟳${NC} Detected URL, downloading audio file..."

    # Create temp file
    TEMP_FILE=$(mktemp "${TMPDIR:-/tmp}/mix-XXXXXX.mp3")

    # Set up cleanup trap
    cleanup() {
        if [ -n "$TEMP_FILE" ] && [ -f "$TEMP_FILE" ]; then
            echo -e "\n${BLUE}⟳${NC} Cleaning up temporary file..."
            rm -f "$TEMP_FILE"
        fi
    }
    trap cleanup EXIT ERR INT TERM

    # Download the file
    if curl -L "$AUDIO_INPUT" -o "$TEMP_FILE" --fail --silent --show-error; then
        echo -e "${GREEN}✓${NC} Download complete"
        AUDIO_FILE="$TEMP_FILE"
    else
        echo -e "${RED}Error: Failed to download audio file from URL${NC}"
        exit 1
    fi
else
    # Local file
    AUDIO_FILE="$AUDIO_INPUT"

    # Check if audio file exists
    if [ ! -f "$AUDIO_FILE" ]; then
        echo -e "${RED}Error: Audio file not found: $AUDIO_FILE${NC}"
        exit 1
    fi
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

# Generate date and filenames
DATE=$(date +%Y-%m-%d)
MIX_FILE="_djmixes/${DATE}-${MIX_SLUG}.md"
MIX_ASSETS_DIR="assets/djmixes/${DATE}-${MIX_SLUG}"
WAVEFORM_FILE="${DATE}-${MIX_SLUG}/waveform.dat"
WAVEFORM_PATH="${MIX_ASSETS_DIR}/waveform.dat"

# Create mix-specific assets directory
mkdir -p "$MIX_ASSETS_DIR"

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

# Check if waveform file already exists
if [ -f "$WAVEFORM_PATH" ]; then
    echo -e "${YELLOW}Warning: Waveform file already exists: $WAVEFORM_PATH${NC}"
    read -p "Overwrite existing waveform file? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}Aborted: Not overwriting existing waveform file${NC}"
        exit 1
    fi
fi

# Generate waveform
echo -e "${BLUE}⟳${NC} Generating waveform data..."
if audiowaveform -i "$AUDIO_FILE" -o "$WAVEFORM_PATH" -b 8 -z 256 > /dev/null 2>&1; then
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
audio_url: "REPLACE_WITH_DROPBOX_URL_INCLUDE_DL1_PARAMETER"
duration_seconds: ${DURATION:-3600}
excerpt: "Add a short description here (1-2 sentences)"
waveform_file: "$WAVEFORM_FILE"
${DURATION_FORMATTED:+duration: \"$DURATION_FORMATTED\"}
header:
  cover: /assets/djmixes/${DATE}-${MIX_SLUG}/cover.jpg  # Optional
  og_image: /assets/djmixes/${DATE}-${MIX_SLUG}/cover.jpg  # For social sharing
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
echo -e "${YELLOW}1. Upload audio file to Dropbox:${NC}"
echo "   • Upload $AUDIO_FILE to Dropbox (any folder)"
echo "   • Get shareable link (right-click → Share → Copy link)"
echo "   • Add &dl=1 parameter to the link"
echo "   • Update audio_url in $MIX_FILE"
echo "   • Example: https://www.dropbox.com/scl/fi/...?rlkey=...&dl=1"
echo ""
echo -e "   ${BLUE}Alternative:${NC} For S3/CloudFront hosting, see quickstart.md Appendix A"
echo ""
echo -e "${YELLOW}2. (Optional) Add cover art:${NC}"
echo "   • Create cover image (400x400px recommended)"
echo "   • Save to: ${MIX_ASSETS_DIR}/cover.jpg"
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
