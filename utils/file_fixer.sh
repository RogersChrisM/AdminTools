#!/bin/bash
# file_fixer.sh
# Usage: file_fixer.sh <file1> [file2 ...]
# Cleans input files:
# - Removes BOM
# - Converts CRLF to LF
# - Trims trailing whitespace
# - Converts to UTF-8 encoding (if iconv is installed)

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <file1> [file2 ...]"
  exit 1
fi

for file in "$@"; do
  if [[ ! -f "$file" ]]; then
    echo "[SKIP] $file is not a regular file."
    continue
  fi

  echo "[PROCESS] $file"

  # Create a temp file for processing
  tmpfile=$(mktemp)

  # Remove BOM (if present)
  sed '1s/^\xEF\xBB\xBF//' "$file" > "$tmpfile"

  # Normalize line endings: CRLF to LF
  sed -i 's/\r$//' "$tmpfile"

  # Trim trailing whitespace from each line
  sed -i 's/[[:space:]]\+$//' "$tmpfile"

  # Convert encoding to UTF-8 (skip if iconv missing)
  if command -v iconv >/dev/null 2>&1; then
    iconv -f UTF-8 -t UTF-8 "$tmpfile" -o "$tmpfile".utf8 2>/dev/null && mv "$tmpfile".utf8 "$tmpfile"
  fi

  # Overwrite original file with cleaned version
  mv "$tmpfile" "$file"
  echo "[DONE] Fixed $file"
done

