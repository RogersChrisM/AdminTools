#!/bin/bash
# colorize_output.sh
# Usage: source colorize_output.sh
# Provides color_echo function and color constants

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

color_echo() {
  local color="$1"
  shift
  echo -e "${color}$*${RESET}"
}

# Convenience wrappers
echo_red()    { color_echo "$RED" "$@"; }
echo_green()  { color_echo "$GREEN" "$@"; }
echo_yellow() { color_echo "$YELLOW" "$@"; }
echo_blue()   { color_echo "$BLUE" "$@"; }

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: ada2eaa905056b94a0e2edc97fe57f83cdf2c73f0999015aaa31593ca7ef361f
