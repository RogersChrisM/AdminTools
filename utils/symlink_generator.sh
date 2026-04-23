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
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: f9640c86272bdd6769836bde0f73f2267047cdd6b1520f1eade1f7756d4e9368
