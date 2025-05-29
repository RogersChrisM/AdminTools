#!/bin/bash

# syncs files across data directories. Designed for manual sync where you want to preview changes or quickly replicate a directory elsewhere (i.e. USB backup). Will not remove stale files from target.

#usage: dsync.sh <source_dir> <target_dir> [--dry-run]

SOURCE=$1
TARGET=$2
DRY_RUN=$3

if [[ "$DRY_RUN" == "--dry-run" ]]; then
    rsync -avhn --progress "$SOURCE/" "$TARGET/"
else
    rsync -avh --progress "$SOURCE/" "$TARGET/"
fi
