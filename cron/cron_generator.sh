#!/bin/bash
# cron_generator.sh - Generate cron schedule strings from simple intervals.
#
# Usage:
#   cron_generator.sh <interval> <time_unit>
# Example:
#   cron_generator.sh 15 minutes
#   cron_generator.sh 3 hours
#
# Output is a cron time specification suitable for crontab.

INTERVAL="$1"
UNIT="$2"

if [[ -z "$INTERVAL" || -z "$UNIT" ]]; then
  echo "Usage: $0 <interval> <time_unit>"
  echo "Units: minutes, hours, days"
  exit 1
fi

case "$UNIT" in
  minutes)
    if (( INTERVAL < 1 || INTERVAL > 59 )); then
      echo "Error: Minutes interval must be between 1 and 59."
      exit 2
    fi
    echo "*/$INTERVAL * * * *"
    ;;
  hours)
    if (( INTERVAL < 1 || INTERVAL > 23 )); then
      echo "Error: Hours interval must be between 1 and 23."
      exit 2
    fi
    echo "0 */$INTERVAL * * *"
    ;;
  days)
    if (( INTERVAL < 1 || INTERVAL > 31 )); then
      echo "Error: Days interval must be between 1 and 31."
      exit 2
    fi
    echo "0 0 */$INTERVAL * *"
    ;;
  *)
    echo "Unsupported time unit. Use minutes, hours, or days."
    exit 3
    ;;
esac

