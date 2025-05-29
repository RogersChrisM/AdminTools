#!/bin/bash
# Generates symlinks from <src> to <dest> directory
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <src> <dest> <dry_run>"
  exit 1
fi
SRC=$1
DEST=$2
mkdir -p "$DEST"
for file in "$SRC"/*; do
  ln -sf "$file" "$DEST/"
done
