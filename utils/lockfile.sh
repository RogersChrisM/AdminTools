#!/bin/bash
# lockfile.sh - Create a lockfile to prevent concurrent script executions.
#
# Usage: lockfile.sh <lockfile_path>
#
# Exits with 1 if the lockfile exists (meaning another instance is running).
# Deletes lockfile on exit or interruption.

LOCKFILE="$1"

if [[ -z "$LOCKFILE" ]]; then
  echo "Usage: $0 <lockfile_path>"
  exit 1
fi

if [[ -e "$LOCKFILE" ]]; then
  echo "[ERROR] Lockfile '$LOCKFILE' exists. Another instance might be running."
  exit 1
fi

trap 'rm -f "$LOCKFILE"; exit' INT TERM EXIT

touch "$LOCKFILE"
echo "[INFO] Lockfile '$LOCKFILE' created."

# Your script logic here...

# Cleanup happens automatically on script exit (trap)

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: a1d393077ec71748963d73641ede59df0dd52aec454138f2fbfcdc4a6044e3db
