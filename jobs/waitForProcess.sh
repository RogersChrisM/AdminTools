#!/bin/bash

#FileName: waitForProcess.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#   Waits for process to complete.
#
#Params:
#   <PID>: Process ID for job to wait for
#
#Script Requirements:
#    admin_tools (CM Rogers)
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#Creation Date: Tue Jul  1 14:18:42 CDT 2025
#    Host: L241568
#    OS: Darwin 24.5.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#    waitForProcess.sh <PID>

usage() {
  echo "Usage: waitForProcess.sh <PID>"
  echo "  <PID>   Process ID for job to wait for"
  exit 1
}

set -e

if [ -z "$1" ]; then
    echo "Input error" >&2
    usage
fi

PID=$1

if ! [[ "$PID" =~ ^[0-9]+$ ]]; then
    echo "Error: PID must be a number."
    exit 1
fi

if ! kill -0 "$PID" 2>/dev/null; then
    echo "Error: Process $PID does not exist or is not running." >&2

echo "Waiting for process $PID to finish..."

while kill -0 "$PID" 2>/dev/null; do
    sleep 1
done

echo "Process $PID has completed."



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-07-01
# SHA256: 7fb991264b6f740ff88ead06c670c35a7f6649be6ab99e732095eb732219724c
