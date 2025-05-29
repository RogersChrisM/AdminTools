#!/bin/bash
# Usage: sync_remote.sh <local_dir> <user@host:remote_dir> [--dry-run]
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <source> <remote> <option>"
  exit 1
fi
SOURCE=$1
REMOTE=$2
OPTION=$3

if [[ "$OPTION" == "--dry-run" ]]; then
  rsync -avhzn --progress "$SOURCE/" "$REMOTE"
else
  rsync -avhz --progress "$SOURCE/" "$REMOTE"
fi
