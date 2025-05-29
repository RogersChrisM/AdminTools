#!/bin/bash
# plot_launcher.sh - Launch an R or Python plotting script with error checking
#
# Usage:
#   plot_launcher.sh <script.R|script.py> [args...]
#
# Checks for Rscript or python availability, then runs the script with passed args.

SCRIPT=$1
shift

if [[ -z "$SCRIPT" || ! -f "$SCRIPT" ]]; then
  echo "Usage: $0 <script.R|script.py> [args...]"
  exit 1
fi

EXT="${SCRIPT##*.}"

case "$EXT" in
  R)
    if ! command -v Rscript &>/dev/null; then
      echo "Rscript not found. Please install R."
      exit 1
    fi
    echo "Running R script: $SCRIPT $*"
    Rscript "$SCRIPT" "$@"
    ;;
  py)
    if ! command -v python3 &>/dev/null; then
      echo "python3 not found. Please install Python 3."
      exit 1
    fi
    echo "Running Python script: $SCRIPT $*"
    python3 "$SCRIPT" "$@"
    ;;
  *)
    echo "Unsupported script type: $EXT"
    echo "Supported: .R (R scripts), .py (Python scripts)"
    exit 1
    ;;
esac

