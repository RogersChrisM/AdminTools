#!/bin/bash

#FileName: check_signatures_recursive.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#   Recursively verify and (re)sign all executable scripts in a directory.
#
#Params:
#   directory (str): Directory to run script on
#
#Script Requirements:
#    admin_tools (CM Rogers)
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#Creation Date: Thu Jun 26 18:40:19 CDT 2025
#    Host: L241568
#    OS: Darwin 24.5.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#    check_signatures_recursive.sh <dir>

usage() {
  echo "Usage: $0 <directory>"
  echo "  <directory>    Directory containing scripts to verify and sign"
  exit 1
}

if [[ $# -lt 1 ]]; then
    echo "Error: Missing required arguments."
    usage
fi

TARGET_DIR="$1"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: '$TARGET_DIR' is not a directory."
  exit 1
fi

# Find all executable files, skip .git folders
find "$TARGET_DIR" -type d -name ".git" -prune -o -type f -perm +111 -print | while IFS= read -r file; do
  echo "Checking: $file"

  # Check if file has a signature block
  if tail -n 10 "$file" | grep -q "^# SHA256:"; then
    ./verify_signature.sh "$file" > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "Unverified signature: $file"
      ./sign.sh "$file"
      echo "Re-signed: $file"
    else
      echo "Verified: $file"
    fi
  else
    echo "No signature found: $file"
    ./sign.sh "$file"
    echo "Signed: $file"
  fi

done



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: f431623d1571310d8788a23a68e21e161975ca3a8f642c303e3214743fc9082d
