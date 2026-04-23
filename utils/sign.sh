#!/bin/bash

#FileName:  sign.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#    Signs one or all scripts by adding or replacing a trailing SHA256 signature block.
#    Use --all to bulk-sign every .sh and .py file in the repo (e.g. after a fork/clone).
#    Individual file signing is used internally by the pre-commit hook.
#
#Params:
#    script (str): Path to the script to sign.
#      --all   : Sign all .sh and .py files found under ADMIN_TOOLS_DIR.
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#Usage:
#    sign.sh <script>
#    sign.sh --all

usage() {
    echo "Usage:"
    echo "  $0 <script>    Sign a single script"
    echo "  $0 --all       Sign all .sh and .py files in the repo"
    exit 1
}

# ── Resolve repo root ────────────────────────────────────────────────────────
ADMIN_TOOLS_DIR="${ADMIN_TOOLS_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

# ── Core signing function ────────────────────────────────────────────────────
sign_file() {
    local SCRIPT="$1"

    if [[ ! -f "$SCRIPT" ]]; then
        echo "Error: '$SCRIPT' does not exist."
        return 1
    fi

    local TMP_FILE
    TMP_FILE=$(mktemp)

    # Strip existing signature block (if any)
    awk '
        /^# --- Signature ---/ { exit }
        { print }
    ' "$SCRIPT" > "$TMP_FILE"

    local HASH
    HASH=$(shasum -a 256 "$TMP_FILE" | awk '{print $1}')

    mv "$TMP_FILE" "$SCRIPT"

    {
        echo "# --- Signature ---"
        echo "# Author: CM Rogers (https://github.com/RogersChrisM/)"
        echo "# Date: $(date +%Y-%m-%d)"
        echo "# SHA256: $HASH"
    } >> "$SCRIPT"

    chmod +x "$SCRIPT"
    echo "Signed: $SCRIPT"
}

# ── Dispatch ─────────────────────────────────────────────────────────────────
if [[ $# -lt 1 ]]; then
    echo "Error: Missing required arguments."
    usage
fi

if [[ "$1" == "--all" ]]; then
    echo "Bulk-signing all .sh and .py files under: $ADMIN_TOOLS_DIR"
    echo ""
    SIGNED=0
    FAILED=0

    while IFS= read -r -d '' file; do
        if sign_file "$file"; then
            (( SIGNED++ ))
        else
            (( FAILED++ ))
        fi
    done < <(find "$ADMIN_TOOLS_DIR" \
                  -not -path '*/__pycache__/*' \
                  -not -path '*/.git/*' \
                  \( -name "*.sh" -o -name "*.py" \) \
                  -print0)

    echo ""
    echo "Done. Signed: $SIGNED  Failed: $FAILED"
else
    sign_file "$1"
fi
