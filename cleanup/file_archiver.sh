#!/bin/bash
# Find files not accessed in 30+ days and not used by a running job, then compress
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <dir> <dest> <dry_run>"
  exit 1
fi
DIR=$1
find "$DIR" -type f -atime +30 | while read file; do
    if ! lsof "$file" >/dev/null 2>&1; then
        echo "Archiving orphaned file: $file"
        bash utils/archive_file.sh "$file"
    fi
done
