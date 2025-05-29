#!/bin/bash
# Usage: retry.sh "command" --max-attempts 3 --sleep 10
if [[ $# -lt 5 ]]; then
  echo "Usage: $0 <cmd> <max> <sleep>"
  exit 1
fi
CMD=$1
MAX=${3:-3}
SLEEP=${5:-10}

attempt=1
until eval "$CMD"
do
  echo "Attempt $attempt failed. Retrying in $SLEEP sec..."
  ((attempt++))
  if [ $attempt -gt $MAX ]; then
    echo "Exceeded max attempts. Exiting."
    exit 1
  fi
  sleep $SLEEP
done
