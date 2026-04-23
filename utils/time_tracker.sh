#!/bin/bash
# time_tracker.sh - Simple task time tracker (start/stop/status)
#
# Usage:
#   time_tracker.sh start <task_name>
#   time_tracker.sh stop <task_name>
#   time_tracker.sh status [task_name]
#
# Stores timestamps in ~/.time_tracker/tasks.txt

DATA_FILE="$HOME/.time_tracker/tasks.txt"
mkdir -p "$(dirname "$DATA_FILE")"
touch "$DATA_FILE"

command=$1
task=$2

if [[ -z "$command" ]]; then
  echo "Usage: $0 {start|stop|status} [task_name]"
  exit 1
fi

start_time() {
  local t=$1
  # Append start time line: task_name,start,timestamp
  echo "$t,start,$(date +%s)" >> "$DATA_FILE"
  echo "Started task '$t' at $(date)"
}

stop_time() {
  local t=$1
  echo "$t,stop,$(date +%s)" >> "$DATA_FILE"
  echo "Stopped task '$t' at $(date)"
}

status_time() {
  local t=$1
  if [[ -n "$t" ]]; then
    # Show elapsed time for this task
    awk -F, -v task="$t" '
    $1==task {
      if ($2=="start") {start=$3}
      else if ($2=="stop" && start) {
        duration += ($3 - start)
        start=""
      }
    }
    END {
      if (duration > 0)
        printf "Elapsed time for task \"%s\": %d seconds (%.2f minutes)\n", task, duration, duration/60
      else
        print "No completed runs found for task: " task
    }' "$DATA_FILE"
  else
    # Show all tasks with elapsed times
    awk -F, '
    {
      task=$1
      if ($2=="start") {start[task]=$3}
      else if ($2=="stop" && start[task]) {
        duration[task]+=($3 - start[task])
        start[task]=""
      }
    }
    END {
      print "Elapsed times for all tasks:"
      for (t in duration) {
        printf "  %s: %d seconds (%.2f minutes)\n", t, duration[t], duration[t]/60
      }
    }' "$DATA_FILE"
  fi
}

case "$command" in
  start)
    [[ -z "$task" ]] && { echo "Please provide a task name."; exit 1; }
    start_time "$task"
    ;;
  stop)
    [[ -z "$task" ]] && { echo "Please provide a task name."; exit 1; }
    stop_time "$task"
    ;;
  status)
    status_time "$task"
    ;;
  *)
    echo "Unknown command: $command"
    echo "Usage: $0 {start|stop|status} [task_name]"
    exit 1
    ;;
esac

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: 2a4a09549f7c8795aaf56d09a30de9f172508eeec693411e9c124cd0d8eed6d6
