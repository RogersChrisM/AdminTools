#!/bin/bash
# Archives and compresses a file
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <file> <target> <dry_run>"
  exit 1
fi
FILE=$1
DIR=$(dirname "$FILE")
BASENAME=$(basename "$FILE")
tar -czf "$DIR/$BASENAME.tar.gz" -C "$DIR" "$BASENAME" && rm "$FILE"
