#!/bin/bash
# duplicate_finder.sh
# Usage: duplicate_finder.sh <directory>
# Finds duplicate files by SHA256 hash within the directory recursively.

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

TARGET_DIR="$1"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "[ERROR] $TARGET_DIR is not a directory."
  exit 1
fi

declare -A filehash_map

echo "[INFO] Scanning files in $TARGET_DIR ..."

# Find all files and compute SHA256 hashes
while IFS= read -r -d '' file; do
  hash=$(sha256sum "$file" 2>/dev/null | awk '{print $1}')
  if [[ -z "$hash" ]]; then
    echo "[WARN] Could not hash file: $file"
    continue
  fi
  filehash_map["$hash"]+="$file"$'\n'
done < <(find "$TARGET_DIR" -type f -print0)

# Output duplicates
echo "[RESULT] Duplicate files found:"

found=0
for hash in "${!filehash_map[@]}"; do
  files=(${filehash_map[$hash]})
  if (( ${#files[@]} > 1 )); then
    ((found++))
    echo "Hash: $hash"
    for f in "${files[@]}"; do
      echo "  $f"
    done
    echo
  fi
done

if (( found == 0 )); then
  echo "No duplicates found."
fi

