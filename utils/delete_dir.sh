#!/bin/bash

#FileName: delete_dir.sh
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
#Creation Date: Tue Oct 14 16:00:19 CDT 2025
#    Host: L241568
#    OS: Darwin 24.6.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#    delete_dir.sh <input>

usage() {
  echo "Usage: delete_dir.sh <directory>"
  echo "  <directory>   Directory to delete"
  exit 1
}

if [[ $# -lt 1 ]]; then
    echo "Error: Missing required arguments."
    usage
fi

#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-}"

echo "[INFO] Deleting directory: $DIR"
rm -rf "$DIR"
echo "[INFO] Deleted: $DIR"


# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: 1a4716031b4e96d86f6959cfd4b2bd21304ef2141503fecf2ade14d945922dd8
