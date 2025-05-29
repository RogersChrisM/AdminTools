#!/bin/bash
# arg_parser.sh
# Usage: arg_parser.sh [-h] [-v] -f <file> [--mode <mode>]
# Example usage of a basic argument parser with flags and options

print_usage() {
  echo "Usage: $0 [-h] [-v] -f <file> [--mode <mode>]"
  echo "  -h           Show this help message"
  echo "  -v           Verbose mode"
  echo "  -f <file>    Input file (required)"
  echo "  --mode <m>   Operation mode (optional)"
}

VERBOSE=0
MODE="default"
FILE=""

if [[ $# -eq 0 ]]; then
  print_usage
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h)
      print_usage
      exit 0
      ;;
    -v)
      VERBOSE=1
      shift
      ;;
    -f)
      if [[ -n "$2" && "$2" != -* ]]; then
        FILE="$2"
        shift 2
      else
        echo "Error: -f requires a file argument."
        exit 1
      fi
      ;;
    --mode)
      if [[ -n "$2" && "$2" != -* ]]; then
        MODE="$2"
        shift 2
      else
        echo "Error: --mode requires a mode argument."
        exit 1
      fi
      ;;
    *)
      echo "Unknown option: $1"
      print_usage
      exit 1
      ;;
  esac
done

if [[ -z "$FILE" ]]; then
  echo "Error: -f <file> is required."
  print_usage
  exit 1
fi

echo "[INFO] Verbose mode: $VERBOSE"
echo "[INFO] File: $FILE"
echo "[INFO] Mode: $MODE"

