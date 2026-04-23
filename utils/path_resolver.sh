#!/bin/bash
# path_resolver.sh
# Usage: path_resolver.sh <path>
# Outputs the absolute canonical path of the input

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <file_or_dir_path>"
  exit 1
fi

input_path="$1"

# Try readlink -f (Linux)
if command -v readlink >/dev/null 2>&1; then
  abs_path=$(readlink -f "$input_path" 2>/dev/null)
fi

# If readlink -f not available or failed, try realpath (macOS)
if [[ -z "$abs_path" ]] && command -v realpath >/dev/null 2>&1; then
  abs_path=$(realpath "$input_path" 2>/dev/null)
fi

# If still empty, try manual method
if [[ -z "$abs_path" ]]; then
  # Manual resolution
  if [[ -d "$input_path" ]]; then
    abs_path=$(cd "$input_path" 2>/dev/null && pwd)
  else
    dir=$(dirname "$input_path")
    file=$(basename "$input_path")
    abs_dir=$(cd "$dir" 2>/dev/null && pwd)
    abs_path="$abs_dir/$file"
  fi
fi

if [[ -z "$abs_path" ]]; then
  echo "[ERROR] Could not resolve path: $input_path"
  exit 1
fi

echo "$abs_path"

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: 9e398d60f812fcf3bbc13c831ce8c0393a0a98f53d6668561531382107736a16
