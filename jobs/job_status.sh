#!/bin/bash
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <pattern>"
  exit 1
fi

# Check running jobs by pattern

# Usage: job_status.sh <pattern>

PATTERN=$1
ps aux | grep "$PATTERN" | grep -v grep
