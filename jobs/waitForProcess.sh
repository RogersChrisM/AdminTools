#!/bin/bash

#FileName: waitForProcess.sh
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
#Creation Date: Tue Jul  1 14:18:42 CDT 2025
#    Host: L241568
#    OS: Darwin 24.5.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#    waitForProcess.sh <PID>

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
  echo "Usage: waitForProcess.sh <required_arg> [optional_arg]"
  echo "  <PID>   Process ID for job(s) to wait for"
  echo "  [optional_arg]   Description of optional_arg"
  exit 1
}

if [[ $# -lt 1 ]]; then
    echo "Error: Missing required arguments."
    usage
fi

set -e

# Usage check
if [ -z "$1" ]; then
    echo "Usage: $0 <PID>"
    exit 1
fi

PID=$1

# Check if PID is numeric
if ! [[ "$PID" =~ ^[0-9]+$ ]]; then
    echo "Error: PID must be a number."
    exit 1
fi

# Wait for the process to finish
echo "Waiting for process $PID to finish..."

# Check if process exists every 1 second
while kill -0 "$PID" 2>/dev/null; do
    sleep 1
done

echo "Process $PID has completed."

# Do something here if desired
# For example: echo "Running post-process task"

#Validate specific argument (example: must be a number)
#if ! [[ "$1" =~ ^[0-9]+$ ]]; then
#    echo "Error: First argument must be a positive integer."
#    usage
#fi

#Optional argument check (example)
#if [[ -n "$2" ]] && [[ "$2" =~ ^(start|stop|restart)$ ]]; then
#    echo "Error: Second argument must be one of: start, stop, restart"
#    usage
#fi

#Case statement (example)
#for arg in "$@"; do
#    case "$arg" in
#        --no-exec)
#            EXECUTABLE=false
#            ;;
#        -*)
#            echo "Unknown option: $arg"
#            ;;
#        *)
#            SCRIPT_NAME="$arg"
#            ;;
#    esac
#done



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-07-01
# SHA256: eb4ab58fbba414e081e6ec7bcbab45183cfcde12a44289edf6a161eb9c6d1060
