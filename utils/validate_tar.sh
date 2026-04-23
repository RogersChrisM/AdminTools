#!/bin/bash

#FileName: validate_tar.sh
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
#Creation Date: Tue Oct 14 16:01:55 CDT 2025
#    Host: L241568
#    OS: Darwin 24.6.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#    validate_tar.sh <input>

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
  echo "Usage: validate_tar.sh <required_arg> [optional_arg]"
  echo "  <archive.tar.gz>   archive file"
  exit 1
}

if [[ $# -lt 1 ]]; then
    echo "Error: Missing required arguments."
    usage
fi

#!/usr/bin/env bash
set -euo pipefail

ARCHIVE="${1:-}"

if [[ -z "$ARCHIVE" || ! -f "$ARCHIVE" ]]; then
    echo "[ERROR] Usage: $0 <archive.tar.gz>"
    exit 1
fi

if tar -tzf "$ARCHIVE" > /dev/null 2>&1; then
    echo "[OK]"
    exit 0
else
    echo "[FAIL]"
    exit 1
fi



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: 14d0c153d9c275adc188d9abc1581ec1b945e2bed414ba16f95787ad920c527d
