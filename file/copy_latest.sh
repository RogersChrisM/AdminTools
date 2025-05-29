#!/bin/bash
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <source> <target>"
  exit 1
fi

# Copy most recently modified file

#Usage: copy_latest.sh <source_dir> <target_dir>

SOURCE=$1
TARGET=$2
LATEST=$(ls -t "$SOURCE" | head -n 1)
cp "$SOURCE/$LATEST" "$TARGET"
echo "Copied: $LATEST"
