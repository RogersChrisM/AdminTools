#!/bin/bash
# Shows disk usage by directory
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <dir> <dest> <dry_run>"
  exit 1
fi
DIR=${1:-.}
du -h --max-depth=1 "$DIR" | sort -hr
