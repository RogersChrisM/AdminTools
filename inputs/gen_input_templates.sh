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
