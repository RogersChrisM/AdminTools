#!/bin/bash
# timestamp.sh - Generate timestamps in various formats
#
# Usage:
#   timestamp.sh [format]
#
# Formats supported (case-insensitive):
#   iso        - ISO 8601 format (default): 2025-05-29T14:32:01Z
#   human      - Human-readable: May 29 2025 14:32:01
#   file       - Filename-friendly: 20250529_143201
#   epoch      - Unix epoch seconds: 1621561923
#
# If no format is provided, defaults to ISO 8601.

FORMAT=${1,,}  # lowercase

case "$FORMAT" in
  iso|"")
    date -u +"%Y-%m-%dT%H:%M:%SZ"
    ;;
  human)
    date +"%b %d %Y %H:%M:%S"
    ;;
  file)
    date +"%Y%m%d_%H%M%S"
    ;;
  epoch)
    date +%s
    ;;
  *)
    echo "Unsupported format '$1'. Supported formats: iso, human, file, epoch"
    exit 1
    ;;
esac


### Usage Demo ###
#timestamp.sh          # Outputs ISO 8601 timestamp by default
#timestamp.sh human    # Outputs something like "May 29 2025 14:32:01"
#timestamp.sh file     # Outputs "20250529_143201" suitable for filenames
#timestamp.sh epoch    # Outputs Unix epoch time in seconds
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: 0b533a0ecb0dac2d78f06e94a4462f4a830ab950ff45d0583ea44c5609fc78c1
