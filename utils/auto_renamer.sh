#!/bin/bash
# Standardizes filenames: lowercase, snake_case (underscores), remove special chars
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <dir> <dest> <dry_run>"
  exit 1
fi

for file in "$@"; do
  if [ -f "$file" ]; then
    dir=$(dirname "$file")
    base=$(basename "$file")
    # convert to lowercase
    newbase=$(echo "$base" | tr '[:upper:]' '[:lower:]')
    # replace spaces and special chars with underscore
    newbase=$(echo "$newbase" | sed 's/[^a-z0-9]/_/g')
    # collapse multiple underscores
    newbase=$(echo "$newbase" | sed 's/_\+/_/g')
    # trim leading/trailing underscores
    newbase=$(echo "$newbase" | sed 's/^_//; s/_$//')

    # rename only if different
    if [[ "$base" != "$newbase" ]]; then
      mv -v "$file" "$dir/$newbase"
    fi
  fi
done

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: af0290fe45a6451bfc9126309e6af59f238c085d3355c5a0db62a34bbc603ad0
