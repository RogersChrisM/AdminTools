#!/bin/bash

#FileName: archive_single.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#
#
#Params:
#
#
#Script Requirements:
#    admin_tools (CM Rogers)
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#Creation Date: Tue Oct 14 16:04:14 CDT 2025
#    Host: L241568
#    OS: Darwin 24.6.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#    archive_single.sh <input>

#function() {
#    : '
#    function(): <description>
#
#    arguments:
#
#    [Result(s)/Returns]:
#
#   '

usage() {
  echo "Usage: archive_single.sh <directory> [optional_arg]"
  echo "  <directory>   Directory to Archive"
  exit 1
}

if [[ $# -lt 1 ]]; then
    echo "Error: Missing required arguments."
    usage
fi

#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-}"

PARENT_DIR="$(dirname "$DIR")"
BASE="$(basename "$DIR")"
ARCHIVE="${PARENT_DIR}/${BASE}_$(date +%Y%m%d).tar.gz"

echo "[INFO] Archiving '$DIR' -> '$ARCHIVE'"
tar -czf "$ARCHIVE" -C "$PARENT_DIR" "$BASE"

if tar -tzf "$ARCHIVE" > /dev/null 2>&1; then
    echo "[INFO] Archive validated. Deleting '$DIR'"
    rm -rf "$DIR"
else
    echo "[ERROR] Archive validation failed. '$DIR' not deleted."
    exit 2
fi



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: 45f231d847db4a167c002ed78a6c239a4e4ad94e17e7966e9725722d365041fb
