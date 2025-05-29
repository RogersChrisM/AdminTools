#!/bin/bash
# Deletes .tmp, .log, .bak older than 7 days in given directory
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <dir> <days> <dry_run>"
  exit 1
fi
DIR=${1:-/tmp}
find "$DIR" -type f \( -name "*.tmp" -o -name "*.log" -o -name "*.bak" \) -mtime +7 -exec rm -v {} \;
