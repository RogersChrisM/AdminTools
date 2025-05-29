#!/bin/bash
# Validates checksums against a file by auto-detecting type

CHECKSUM_FILE=$1

if [[ -z "$CHECKSUM_FILE" || ! -f "$CHECKSUM_FILE" ]]; then
  echo "Usage: $0 <checksum_file>"
  exit 1
fi

# Detect checksum type from extension or content
if [[ "$CHECKSUM_FILE" == *.md5 ]]; then
  echo "Detected MD5 checksum file"
  md5sum -c "$CHECKSUM_FILE"
elif [[ "$CHECKSUM_FILE" == *.sha256 ]]; then
  echo "Detected SHA256 checksum file"
  sha256sum -c "$CHECKSUM_FILE"
else
  # Try detecting based on hash length in file
  HASH_LINE=$(head -n 1 "$CHECKSUM_FILE")
  HASH_VALUE=$(echo "$HASH_LINE" | awk '{print $1}')
  HASH_LENGTH=${#HASH_VALUE}

  if [[ $HASH_LENGTH -eq 32 ]]; then
    echo "Detected MD5 checksum by content"
    md5sum -c "$CHECKSUM_FILE"
  elif [[ $HASH_LENGTH -eq 64 ]]; then
    echo "Detected SHA256 checksum by content"
    sha256sum -c "$CHECKSUM_FILE"
  else
    echo "Could not detect checksum type: unsupported format or corrupt file"
    exit 2
  fi
fi

