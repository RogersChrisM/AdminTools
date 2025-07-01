#!/bin/bash

# Usage:
# ./remote_exec.sh user@host "command to run" [-k /path/to/key]

# Extract positional arguments
REMOTE_HOST="$1"
COMMAND="$2"
shift 2  # Shift the first two arguments off

# Default for SSH_KEY
SSH_KEY=""

# Parse optional flags (e.g., -k)
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -k|--key) SSH_KEY="$2"; shift 2;;
        --) shift; break ;; #end of options
        -*) echo "Unknown option: $1"; exit 1 ;;
        *) break ;; #first non-option arg
    esac
done

# Check required inputs
REMOTE_HOST="$1"
COMMAND="$2"

if [[ -z "$REMOTE_HOST" || -z "$COMMAND" ]]; then
    echo "Usage: $0 user@host \"command\" [-k /path/to/private_key]"
    exit 1
fi

# Run command with optional key
if [[ -n "$SSH_KEY" ]]; then
    ssh -i "$SSH_KEY" "$REMOTE_HOST" "$COMMAND"
else
    ssh "$REMOTE_HOST" "$COMMAND"
fi

