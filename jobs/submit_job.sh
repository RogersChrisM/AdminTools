#!/bin/bash
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <script> <logfile>"
  exit 1
fi

# Submits job to background

# Usage: submit_job.sh <script> <logfile>

SCRIPT=$1
LOGFILE=$2

nohup bash "$SCRIPT" > "$LOGFILE" 2>&1 &
echo "Job submitted: $SCRIPT (log: $LOGFILE)"
