#!/bin/bash

# Generate multiple inputs

# Usage: batch_gen_inputs.sh <prefix> <count>

PREFIX=$1
COUNT=$2

for i in $(seq 1 $COUNT); do
    ./gen_input_template.sh "${PREFIX}_$i.conf"
done

