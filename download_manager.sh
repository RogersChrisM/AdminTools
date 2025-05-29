#!/bin/bash
# download_manager.sh - Download files with retries and optional checksum verification
#
# Usage:
#   download_manager.sh <url> [dest_path] [max_retries] [checksum] [checksum_type]
#
# checksum_type: sha256 (default), md5

URL=$1
DEST=${2:-$(basename "$URL")}
MAX_RETRIES=${3:-3}
CHECKSUM=$4
CHECKSUM_TYPE=${5:-sha256}

if [[ -z "$URL" ]]; then
  echo "Usage: $0 <url> [dest_path] [max_retries] [checksum] [checksum_type]"
  exit 1
fi

attempt=1
while (( attempt <= MAX_RETRIES )); do
  echo "Attempt $attempt: Downloading $URL"
  if command -v curl &>/dev/null; then
    curl -L --progress-bar -o "$DEST" "$URL" && break
  elif command -v wget &>/dev/null; then
    wget -q --show-progress -O "$DEST" "$URL" && break
  else
    echo "Error: curl or wget required"
    exit 1
  fi
  echo "Download attempt $attempt failed, retrying..."
  ((attempt++))
done

if (( attempt > MAX_RETRIES )); then
  echo "Failed to download $URL after $MAX_RETRIES attempts."
  exit 1
fi

if [[ -n "$CHECKSUM" ]]; then
  echo "Verifying $CHECKSUM_TYPE checksum..."
  case "$CHECKSUM_TYPE" in
    sha256)
      echo "$CHECKSUM  $DEST" | sha256sum -c --status || { echo "Checksum verification failed"; exit 1; }
      ;;
    md5)
      echo "$CHECKSUM  $DEST" | md5sum -c --status || { echo "Checksum verification failed"; exit 1; }
      ;;
    *)
      echo "Unsupported checksum type: $CHECKSUM_TYPE"
      exit 1
      ;;
  esac
  echo "Checksum OK."
fi

