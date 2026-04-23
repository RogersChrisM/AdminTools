#!/bin/bash
# Archives and compresses a file
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <file> <target> <dry_run>"
  exit 1
fi
FILE=$1
DIR=$(dirname "$FILE")
BASENAME=$(basename "$FILE")
tar -czf "$DIR/$BASENAME.tar.gz" -C "$DIR" "$BASENAME" && rm "$FILE"
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: bb52bb95f2143cc965e9a797740d034c5e4af732ee7e491ab2e8fed89c73e79e
