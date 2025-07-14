#!/bin/bash

#FileName: save_disk.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#
#
#Params:
#   directory
#   numDays
#
#Script Requirements:
#    admin_tools (CM Rogers)
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#Creation Date: Mon Jul 14 16:18:35 CDT 2025
#    Host: L241568
#    OS: Darwin 24.5.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#    save_disk.sh <input> [day_thresh]

usage() {
    echo "Usage: $0 <directory> [num_days]"
    echo "Recursively gzip files not accessed in the last [num_days] days (default 10)."
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

TARGET_DIR="$1"
NUM_DAYS="${2:-10}"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: '$TARGET_DIR' is not a valid directory."
    exit 1
fi

if ! [[ "$NUM_DAYS" =~ ^[0-9]+$ ]] ; then
    echo "Error: num_days must be a positive integer."
    exit 1
fi

echo "Compressing files in '$TARGET_DIR' not accessed in the last $NUM_DAYS days..."

find "$TARGET_DIR" -type f -atime +$NUM_DAYS ! -name "*.gz" -print -exec gzip {} \;

echo "Done."


# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-07-14
# SHA256: f62a730a1c61505329246822eef0cdb985722796125bf0930ed0562cf893417a
