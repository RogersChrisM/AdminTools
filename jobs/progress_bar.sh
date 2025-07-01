#!/bin/bash
# progress_bar.sh
# Usage: source progress_bar.sh
# Call progress_bar <percent>

progress_bar() {
  local progress=$1
  local width=50
  local filled=$(( progress * width / 100 ))
  local empty=$(( width - filled ))

  # Build bar string
  local bar="$(printf '%0.s#' $(seq 1 $filled))$(printf '%0.s-' $(seq 1 $empty))"

  # Print in-place
  printf "\r[%s] %d%%" "$bar" "$progress"

  if [[ $progress -ge 100 ]]; then
    echo ""
  fi
}

