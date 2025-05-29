#!/bin/bash

# Wait for jobs to finish

# Usage: wait_jobs.sh <pattern>

PATTERN=$1

while pgrep -f "$PATTERN" > /dev/null; do
    echo "Waiting for jobs matching '$PATTERN'..."
    sleep 5
done

echo "All jobs finished."

