#!/bin/bash

set -euo pipefail

usage() {
  echo "Usage: $0 <source_path> [backup_dir]"
  echo "Creates a versioned, compressed backup of <source_path>."
  echo "If [backup_dir] is omitted, backups are created next to source."
  exit 1
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
fi

SRC_PATH=$1
BACKUP_DIR=${2:-}

if [[ ! -e "$SRC_PATH" ]]; then
  echo "Error: Source path '$SRC_PATH' does not exist."
  exit 1
fi

# Determine backup directory and base name
if [[ -n "$BACKUP_DIR" ]]; then
  mkdir -p "$BACKUP_DIR"
  base_name=$(basename "$SRC_PATH")
  backup_prefix="$BACKUP_DIR/$base_name.bak"
else
  backup_prefix="$SRC_PATH.bak"
fi

# Find highest existing version number (look for .N.gz files)
max_version=0
shopt -s nullglob
for f in ${backup_prefix}.*.gz; do
  ver=${f##*.}        # extract version plus 'gz'
  ver=${ver%.gz}      # remove .gz extension
  if [[ $ver =~ ^[0-9]+$ ]] && (( ver > max_version )); then
    max_version=$ver
  fi
done
shopt -u nullglob

next_version=$((max_version + 1))
backup_name="${backup_prefix}.${next_version}.gz"

# Create a tarball and gzip it
if [[ -d "$SRC_PATH" ]]; then
  tar -czf "$backup_name" -C "$(dirname "$SRC_PATH")" "$(basename "$SRC_PATH")"
else
  gzip -c "$SRC_PATH" > "$backup_name"
fi

echo "Compressed backup created: $backup_name"
