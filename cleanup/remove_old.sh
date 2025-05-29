#!/bin/bash
# Removes files not modified in X days
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <dir> <days> <dry_run>"
  exit 1
fi
DIR=$1
DAYS=$2
find "$DIR" -type f -mtime +$DAYS -exec rm -v {} \;
