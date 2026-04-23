#!/bin/bash
# Shows disk usage by directory
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <dir> <dest> <dry_run>"
  exit 1
fi
DIR=${1:-.}
du -h --max-depth=1 "$DIR" | sort -hr
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: 7526ccd0465a446d23dc89072cc6e5a142a46c38c810983c4f2fb9f629231b2e
