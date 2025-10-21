#!/bin/bash

#FileName: archive_subdirs.sh
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
#Creation Date: Tue Oct 14 16:05:13 CDT 2025
#    Host: L241568
#    OS: Darwin 24.6.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#    archive_subdirs.sh <input>

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
  echo "Usage: archive_subdirs.sh <parent_dir>"
  echo "  <parent_dir>   Parent Directory in which to archive subdirectories"
  exit 1
}

if [[ $# -lt 1 ]]; then
    echo "Error: Missing required arguments."
    usage
fi

#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-}"

for SUBDIR in "$ROOT"/*; do
    [[ -d "$SUBDIR" ]] || continue
    [[ "$(basename "$SUBDIR")" == .* ]] && continue
    "$(dirname "$0")/archive_single.sh" "$SUBDIR"
done



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-10-14
# SHA256: 592e4bcba866ad1197035c42c42b5ce582e03de973afdf6fc7b193ff0f549695
