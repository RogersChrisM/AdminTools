#!/bin/bash
# remote_exec.sh - Execute remote commands via SSH with retries and timeout
#
# Usage:
#   remote_exec.sh <user@host> "<command>" [max_retries] [timeout_sec]

REMOTE_HOST=$1
REMOTE_CMD=$2
MAX_RETRIES=${3:-3}
TIMEOUT=${4:-10}

if [[ -z "$REMOTE_HOST" || -z "$REMOTE_CMD" ]]; then
  echo "Usage: $0 <user@host> \"<command>\" [max_retries] [timeout_sec]"
  exit 1
fi

attempt=1
while (( attempt <= MAX_RETRIES )); do
  echo "Attempt $attempt: Running on $REMOTE_HOST"
  timeout "$TIMEOUT" ssh -o ConnectTimeout=5 "$REMOTE_HOST" "$REMOTE_CMD" && break
  echo "Attempt $attempt failed, retrying..."
  ((attempt++))
done

if (( attempt > MAX_RETRIES )); then
  echo "Failed to run command on $REMOTE_HOST after $MAX_RETRIES attempts."
  exit 1
fi

