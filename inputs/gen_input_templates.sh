#!/bin/bash
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <out>"
  exit 1
fi

#Creates input templates

#Usage: gen_input_template.sh <output_file>

OUT=$1

cat <<EOF > "$OUT"
# Input Template
param1=
param2=
input_file=
output_dir=
EOF

echo "Template created: $OUT"
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-06-26
# SHA256: f2583cd46c3f9f06906a37f30cc16bef6556c14bc515df7e264d8aa06ba9dfa3
