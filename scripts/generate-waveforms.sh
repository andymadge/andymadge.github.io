#!/bin/bash
# generate-waveforms.sh - Scan for missing waveforms and generate them
#
# Usage:
#   ./scripts/generate-waveforms.sh [audio_directory]
#   ./scripts/generate-waveforms.sh --remote
#
# This script:
# 1. Scans _djmixes/ for mix files with waveform_file field
# 2. Checks if corresponding .dat file exists in assets/waveforms/
# 3. If missing, either:
#    a) Looks for local audio file in specified directory
#    b) Downloads from audio_url in mix front matter (--remote mode)
# 4. Generates waveform data using audiowaveform

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
REMOTE_MODE=false
AUDIO_DIR="audio_files"

if [ "$1" = "--remote" ] || [ "$1" = "-r" ]; then
    REMOTE_MODE=true
    AUDIO_DIR="(download from audio_url)"
elif [ -n "$1" ]; then
    AUDIO_DIR="$1"
fi

# Check if audiowaveform is installed
if ! command -v audiowaveform &> /dev/null; then
    echo -e "${RED}Error: audiowaveform is not installed${NC}"
    echo "Install with:"
    echo "  macOS:   brew install audiowaveform"
    echo "  Ubuntu:  sudo apt-get install audiowaveform"
    echo "  Windows: Download from https://github.com/bbc/audiowaveform/releases"
    exit 1
fi

# Check if curl is installed (needed for remote mode)
if [ "$REMOTE_MODE" = true ] && ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: curl is not installed (required for --remote mode)${NC}"
    exit 1
fi

# Create directories
mkdir -p assets/waveforms
mkdir -p .tmp/audio 2>/dev/null || true

echo -e "${BLUE}=== Waveform Generation Script ===${NC}\n"
echo "Mode: $([ "$REMOTE_MODE" = true ] && echo "Remote (download from audio_url)" || echo "Local audio files")"
echo "Scanning _djmixes/ for missing waveforms..."
if [ "$REMOTE_MODE" = false ]; then
    echo "Audio directory: $AUDIO_DIR"
fi
echo ""

GENERATED=0
SKIPPED=0
MISSING_AUDIO=0

# Find all mix files
for mix_file in _djmixes/*.md; do
    [ -e "$mix_file" ] || continue

    # Extract waveform_file field from front matter
    waveform_file=$(grep "^waveform_file:" "$mix_file" | sed 's/^waveform_file: *"\?\([^"]*\)"\?/\1/' | tr -d '\r')

    # Skip if no waveform_file specified
    if [ -z "$waveform_file" ]; then
        continue
    fi

    waveform_path="assets/waveforms/$waveform_file"

    # Check if waveform already exists
    if [ -f "$waveform_path" ]; then
        echo -e "${GREEN}✓${NC} $(basename "$mix_file"): waveform exists ($waveform_file)"
        ((SKIPPED++))
        continue
    fi

    # Waveform is missing, get audio file (local or remote)
    mix_basename=$(basename "$mix_file" .md)
    audio_file=""
    cleanup_audio=false

    if [ "$REMOTE_MODE" = true ]; then
        # Extract audio_url from front matter
        audio_url=$(grep "^audio_url:" "$mix_file" | sed 's/^audio_url: *"\?\([^"]*\)"\?/\1/' | tr -d '\r')

        if [ -z "$audio_url" ] || [ "$audio_url" = "REPLACE_WITH_DROPBOX_URL_INCLUDE_DL1_PARAMETER" ] || [ "$audio_url" = "REPLACE_WITH_S3_OR_CDN_URL" ] || [ "$audio_url" = "REPLACE_WITH_S3_URL" ]; then
            echo -e "${YELLOW}⚠${NC} $(basename "$mix_file"): no valid audio_url specified"
            ((MISSING_AUDIO++))
            continue
        fi

        # Determine file extension from URL
        audio_ext="${audio_url##*.}"
        [ -z "$audio_ext" ] && audio_ext="mp3"

        # Download to temp directory
        audio_file=".tmp/audio/${mix_basename}.${audio_ext}"
        echo -e "${BLUE}⬇${NC} $(basename "$mix_file"): downloading from URL..."
        echo "   URL: $audio_url"

        if curl -L -f -s -o "$audio_file" "$audio_url"; then
            cleanup_audio=true
        else
            echo -e "${RED}✗${NC} Failed to download audio file"
            ((MISSING_AUDIO++))
            continue
        fi
    else
        # Try to find matching local audio file (try common extensions)
        for ext in mp3 m4a aac flac wav; do
            if [ -f "$AUDIO_DIR/${mix_basename}.$ext" ]; then
                audio_file="$AUDIO_DIR/${mix_basename}.$ext"
                break
            fi
            # Also try without date prefix
            mix_slug=$(echo "$mix_basename" | sed 's/^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-//')
            if [ -f "$AUDIO_DIR/${mix_slug}.$ext" ]; then
                audio_file="$AUDIO_DIR/${mix_slug}.$ext"
                break
            fi
        done

        if [ -z "$audio_file" ]; then
            echo -e "${YELLOW}⚠${NC} $(basename "$mix_file"): audio file not found in $AUDIO_DIR"
            echo "   Expected: ${mix_basename}.{mp3,m4a,aac,flac,wav}"
            echo "   Tip: Use --remote to download from audio_url instead"
            ((MISSING_AUDIO++))
            continue
        fi
    fi

    # Generate waveform
    echo -e "${BLUE}⟳${NC} $(basename "$mix_file"): generating waveform..."
    echo "   Audio: $audio_file"
    echo "   Output: $waveform_path"

    if audiowaveform -i "$audio_file" -o "$waveform_path" -b 8 -z 256 2>&1 | grep -v "^$"; then
        echo -e "${GREEN}✓${NC} Waveform generated successfully"
        ((GENERATED++))
    else
        echo -e "${RED}✗${NC} Failed to generate waveform"
    fi

    # Cleanup downloaded file if needed
    if [ "$cleanup_audio" = true ]; then
        rm -f "$audio_file"
    fi

    echo ""
done

# Cleanup temp directory
if [ "$REMOTE_MODE" = true ]; then
    rm -rf .tmp/audio 2>/dev/null || true
fi

# Summary
echo -e "${BLUE}=== Summary ===${NC}"
echo -e "${GREEN}Generated:${NC} $GENERATED waveforms"
echo -e "${GREEN}Skipped:${NC} $SKIPPED (already exist)"
if [ $MISSING_AUDIO -gt 0 ]; then
    echo -e "${YELLOW}Missing audio:${NC} $MISSING_AUDIO files"
    echo ""
    if [ "$REMOTE_MODE" = true ]; then
        echo "To generate waveforms for missing files:"
        echo "1. Ensure audio_url is set correctly in mix files"
        echo "2. Run this script again"
    else
        echo "To generate waveforms for missing files:"
        echo "Option 1 (Local files):"
        echo "  1. Place audio files in $AUDIO_DIR/"
        echo "  2. Run: ./scripts/generate-waveforms.sh $AUDIO_DIR"
        echo ""
        echo "Option 2 (Download from audio_url):"
        echo "  1. Ensure audio_url is set in mix files"
        echo "  2. Run: ./scripts/generate-waveforms.sh --remote"
    fi
fi

echo ""
if [ $GENERATED -gt 0 ]; then
    echo -e "${GREEN}Done! Don't forget to:${NC}"
    echo "1. git add assets/waveforms/*.dat"
    echo "2. git commit -m 'Generate waveform data for mixes'"
fi
