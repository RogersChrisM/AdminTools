#!/bin/bash
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <prefix> <count>"
  exit 1
fi

# Generate multiple inputs

# Usage: batch_gen_inputs.sh <prefix> <count>

PREFIX=$1
COUNT=$2

for i in $(seq 1 $COUNT); do
    ./gen_input_template.sh "${PREFIX}_$i.conf"
done

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-06-26
# SHA256: 9deaed53b321265b8e4b909d6dc5bd9fc6b847f725b33c23ba76d77e3c5fb7f6
