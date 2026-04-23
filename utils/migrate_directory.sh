#!/bin/bash

# Usage message
usage() {
    echo "Usage: $0 <source_folder> <destination_folder>"
    exit 1
}

# Require exactly two arguments
if [ $# -ne 2 ]; then
    usage
fi

SOURCE="$1"
DEST="$2"

# Check that source exists and is a directory
if [ ! -d "$SOURCE" ]; then
    echo "Error: Source is not a directory or does not exist: $SOURCE"
    exit 1
fi

# Ensure destination exists (or create it)
if [ ! -d "$DEST" ]; then
    echo "Destination does not exist. Creating: $DEST"
    mkdir -p "$DEST" || { echo "Failed to create destination: $DEST"; exit 1; }
fi

# Perform rsync with progress and remove source if successful
echo "Moving directory: $SOURCE → $DEST"
rsync -ah --info=progress2 "$SOURCE" "$DEST/" && rm -rf "$SOURCE"

if [ $? -eq 0 ]; then
    echo "✅ Successfully moved: $SOURCE → $DEST"
else
    echo "❌ Failed to move: $SOURCE"
    exit 1
fi

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: 225f67c0a9bd653d5a3f8cc9d5747832a13c46d205a4cee26563c335c42f7c2d
