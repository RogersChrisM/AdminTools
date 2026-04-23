#!/bin/bash
# debug_tracer.sh - Add or remove debug tracing (set -x) to a bash script
#
# Usage:
#   debug_tracer.sh add <script.sh>
#   debug_tracer.sh remove <script.sh>

ACTION=$1
SCRIPT=$2

if [[ -z "$ACTION" || -z "$SCRIPT" ]]; then
  echo "Usage: $0 {add|remove} <script.sh>"
  exit 1
fi

if [[ ! -f "$SCRIPT" ]]; then
  echo "File $SCRIPT not found."
  exit 1
fi

case "$ACTION" in
  add)
    if grep -q "set -x" "$SCRIPT"; then
      echo "Debug tracing already enabled in $SCRIPT"
      exit 0
    fi
    # Insert set -x after shebang line
    tmp=$(mktemp)
    awk 'NR==1 && /^#!.*bash/ { print; print "set -x"; next } { print }' "$SCRIPT" > "$tmp"
    mv "$tmp" "$SCRIPT"
    echo "Debug tracing added to $SCRIPT"
    ;;
  remove)
    tmp=$(mktemp)
    grep -v "^set -x$" "$SCRIPT" > "$tmp"
    mv "$tmp" "$SCRIPT"
    echo "Debug tracing removed from $SCRIPT"
    ;;
  *)
    echo "Invalid action: $ACTION"
    echo "Usage: $0 {add|remove} <script.sh>"
    exit 1
    ;;
esac

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: af3b2eb5bb60f0f462011797d836a3a372dbd1f5624d8315945c2b4bf7755214
