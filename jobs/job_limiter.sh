#!/bin/bash

# job_limiter.sh - Run commands limiting concurrent jobs with job IDs, timeout, and status reporting.
#
# Usage:
#   job_limiter.sh [-t timeout_secs] <max_jobs> <command> [args...]
#
# Options:
#   -t timeout_secs   Timeout in seconds to wait for free slot (default: wait indefinitely)
#
# Example:
#   job_limiter.sh -t 30 4 ./your_script.sh arg1 arg2

set -euo pipefail

TIMEOUT=0
MAX_JOBS=""
CMD=()

usage() {
  echo "Usage: $0 [-t timeout_secs] <max_jobs> <command> [args...]"
  exit 1
}

# Parse options
while getopts ":t:" opt; do
  case $opt in
    t)
      TIMEOUT=$OPTARG
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND -1))

if [[ $# -lt 2 ]]; then
  usage
fi

MAX_JOBS=$1
shift
CMD=("$@")

start_time=$(date +%s)

running_jobs() {
  jobs -rp | wc -l
}

wait_for_slot() {
  while (( $(running_jobs) >= MAX_JOBS )); do
    if (( TIMEOUT > 0 )); then
      current_time=$(date +%s)
      elapsed=$(( current_time - start_time ))
      if (( elapsed >= TIMEOUT )); then
        echo "[ERROR] Timeout reached waiting for free job slot."
        exit 2
      fi
    fi
    sleep 0.5
  done
}

# Wait for available slot
wait_for_slot

# Launch job
"${CMD[@]}" &
job_pid=$!

echo "$job_pid" >> "$PID_FILE"

echo "[INFO] Started job PID $job_pid: ${CMD[*]}"


#######################
# Usage Demo:
#
#!/bin/bash

#MAX_CONCURRENT=3
#TIMEOUT=20  # seconds to wait for a free job slot

# Run 10 jobs limiting concurrency, then wait for all to finish

#for i in {1..10}; do
#  ./job_limiter.sh -t $TIMEOUT $MAX_CONCURRENT ./your_script.sh "$i"
#done

# Collect all PIDs from temp file for monitoring
#PID_FILE="/tmp/job_limiter_pids.XXXXXX"  # Replace with actual file if exposing it

# Wait on jobs from PID_FILE
#while IFS= read -r pid; do
#  if wait "$pid"; then
#    echo "[INFO] Job PID $pid completed successfully."
#  else
#    echo "[WARN] Job PID $pid failed or was terminated."
#  fi
#done < "$PID_FILE"
