#!/bin/bash
# Usage: parallel_runner.sh job_list.txt 4
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <jobs> <nproc>"
  exit 1
fi
JOBS=$1
NPROC=$2
cat $JOBS | xargs -P $NPROC -I {} bash -c "{}"
