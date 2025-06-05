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

