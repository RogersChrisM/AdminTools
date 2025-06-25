#!/bin/bash
"""
FileName:  sign.sh

Author: Christopher M. Rogers (https://github.com/RogersChrisM/)

Description:
    Signs file for general verification use.

Params:
    script (str): Name of script being created.
    
Associated Package:
    admin_tools (CM Rogers)
 
Usage: 
    sign_script.sh <script>
"""

SCRIPT="$1"
HASH=$(shasum -a 256 "$SCRIPT" | awk '{print $1}')

{
    echo
    echo
    echo
    echo "# --- Signature ---"
    echo "# Author: CM Rogers (https://github.com/RogersChrisM/)"
    echo "# Date: $(date +%Y-%m-%d)"
    echo "# SHA256: $HASH"
} >> "$SCRIPT"
