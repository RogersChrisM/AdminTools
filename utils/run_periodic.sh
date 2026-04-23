#!/bin/bash

#FileName: run_periodic.sh
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
#Creation Date: Tue Oct 14 16:08:21 CDT 2025
#    Host: L241568
#    OS: Darwin 24.6.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#    run_periodic.sh <input>

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
  echo "Usage: run_periodic.sh <interval_seconds> <command...>"
  echo "  <interval_seconds>   Interval of seconds (86400 = 1 day)"
  echo "  <command...>         Command to run periodically"
  exit 1
}

if [[ $# -lt 1 ]]; then
    echo "Error: Missing required arguments."
    usage
fi

#!/usr/bin/env bash
set -euo pipefail

INTERVAL="$1"
shift
COMMAND=("$@")

while true; do
    echo "[INFO] Running: ${COMMAND[*]}"
    "${COMMAND[@]}"
    echo "[INFO] Sleeping ${INTERVAL}s..."
    sleep "$INTERVAL"
done




# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: 19acc81b92320babb3e8dc12707182652d6d7dfc2ea554f4c3ee2904b8bec197
