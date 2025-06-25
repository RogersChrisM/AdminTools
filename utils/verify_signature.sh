#!/bin/bash
: '
FileName:  verify_signature.sh

Author: Christopher M. Rogers (https://github.com/RogersChrisM/)

Description:
    Verifies the integrity of a script by comparing its actual SHA256 hash
    to the signature block embedded at the end (if present).

Params:
    script (str): Name of script to verify.

Associated Package:
    admin_tools (CM Rogers)

Usage:
    verify_signature.sh <script>
'

usage() {
    echo "Usage: $0 <script>"
    echo "<script>    Script file to verify"
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

# Extract embedded hash from the last few lines
EMBEDDED_HASH=$(tail -n 10 "$SCRIPT" | grep -E '^# SHA256:' | awk '{print $3}')

if [[ -z "$EMBEDDED_HASH" ]]; then
    echo "No signature block found in '$SCRIPT'"
    exit 1
fi

# Remove signature block for accurate hash calculation
TMP_FILE=$(mktemp)
awk '
    BEGIN { skip=0 }
    /^# --- Signature ---/ { skip=1 }
    skip == 0 { print }
' "$SCRIPT" > "$TMP_FILE"

ACTUAL_HASH=$(shasum -a 256 "$TMP_FILE" | awk '{print $1}')
rm "$TMP_FILE"

echo "Verifying '$SCRIPT'..."
echo "Embedded: $EMBEDDED_HASH"
echo "Actual:   $ACTUAL_HASH"

if [[ "$EMBEDDED_HASH" == "$ACTUAL_HASH" ]]; then
    echo "Signature verified. Script is unmodified."
    exit 0
else
    echo "Signature mismatch! Script may have been modified."
    exit 2
fi


# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-06-25
# SHA256: bd75f75fdd307f8c4b24d6aac94e6b8f6dff23e869d47e8c8d20133cdca997fa
