#!/bin/bash

#FileName:  sign_script.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#    Signs file for general verification use by adding or replacing a trailing SHA256 signature block.
#
#Params:
#    script (str): Name of script to be signed.
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#Usage:
#    sign_script.sh <script>

usage() {
    echo "Usage: $0 <script>"
    echo "<script>    Script to sign"
    exit 1
}

if [[ $# -lt 1 ]]; then
    echo "Error: Missing required arguments."
    usage
fi

SCRIPT="$1"

if [[ ! -f "$SCRIPT" ]]; then
    echo "Error: '$SCRIPT' does not exist."
    exit 1
fi

TMP_FILE=$(mktemp)

awk '
    BEGIN { skip=0 }
    /^# --- Signature ---/ { exit }  # Stop at the signature block
    { print }
' "$SCRIPT" > "$TMP_FILE"

HASH=$(shasum -a 256 "$TMP_FILE" | awk '{print $1}')

mv "$TMP_FILE" "$SCRIPT"

{
    echo "# --- Signature ---"
    echo "# Author: CM Rogers (https://github.com/RogersChrisM/)"
    echo "# Date: $(date +%Y-%m-%d)"
    echo "# SHA256: $HASH"
} >> "$SCRIPT"

chmod +x "$SCRIPT"



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-06-26
# SHA256: 44fd4f569a7c200f3a14babc61ec68c6d658a42a03944555d5b4dbb65fafef0e
