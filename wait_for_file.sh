#!/bin/bash
# wait_for_file.sh - Wait until a file exists or timeout occurs.
#
# Usage: wait_for_file.sh <filepath> [timeout_seconds]
# If timeout_seconds is omitted, waits indefinitely.

FILE="$1"
TIMEOUT="${2:-0}"

if [[ -z "$FILE" ]]; then
  echo "Usage: $0 <filepath> [timeout_seconds]"
  exit 1
fi

start_time=$(date +%s)
while [[ ! -e "$FILE" ]]; do
  sleep 1
  if (( TIMEOUT > 0 )); then
    now=$(date +%s)
    elapsed=$(( now - start_time ))
    if (( elapsed >= TIMEOUT )); then
      echo "[ERROR] Timeout reached waiting for file '$FILE'."
      exit 2
    fi
  fi
done

echo "[OK] File '$FILE' detected."

