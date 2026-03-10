#!/bin/bash
# generate-waveforms.sh - Scan for missing waveforms and generate them
#
# Usage:
#   ./scripts/generate-waveforms.sh [audio_directory]
#
# This script:
# 1. Scans _djmixes/ for mix files with waveform_file field
# 2. Checks if corresponding .dat file exists in assets/waveforms/
# 3. If missing, looks for matching audio file in specified directory
# 4. Generates waveform data using audiowaveform

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default audio directory (where local audio files are stored)
AUDIO_DIR="${1:-audio_files}"

# Check if audiowaveform is installed
if ! command -v audiowaveform &> /dev/null; then
    echo -e "${RED}Error: audiowaveform is not installed${NC}"
    echo "Install with:"
    echo "  macOS:   brew install audiowaveform"
    echo "  Ubuntu:  sudo apt-get install audiowaveform"
    echo "  Windows: Download from https://github.com/bbc/audiowaveform/releases"
    exit 1
fi

# Create assets/waveforms directory if it doesn't exist
mkdir -p assets/waveforms

echo -e "${BLUE}=== Waveform Generation Script ===${NC}\n"
echo "Scanning _djmixes/ for missing waveforms..."
echo "Audio directory: $AUDIO_DIR"
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

    # Waveform is missing, try to find audio file
    mix_basename=$(basename "$mix_file" .md)

    # Try to find matching audio file (try common extensions)
    audio_file=""
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
        ((MISSING_AUDIO++))
        continue
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
    echo ""
done

# Summary
echo -e "${BLUE}=== Summary ===${NC}"
echo -e "${GREEN}Generated:${NC} $GENERATED waveforms"
echo -e "${GREEN}Skipped:${NC} $SKIPPED (already exist)"
if [ $MISSING_AUDIO -gt 0 ]; then
    echo -e "${YELLOW}Missing audio:${NC} $MISSING_AUDIO files"
    echo ""
    echo "To generate waveforms for missing files:"
    echo "1. Place audio files in $AUDIO_DIR/"
    echo "2. Run this script again"
fi

echo ""
if [ $GENERATED -gt 0 ]; then
    echo -e "${GREEN}Done! Don't forget to:${NC}"
    echo "1. git add assets/waveforms/*.dat"
    echo "2. git commit -m 'Add generated waveform data'"
fi
