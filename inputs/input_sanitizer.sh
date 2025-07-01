#!/bin/bash
# input_sanitizer.sh
# Usage: input_sanitizer.sh "<string>"
# Cleans the input string by:
# - Removing non-alphanumeric characters except underscores, hyphens, dots, and spaces
# - Replacing multiple spaces with single space
# - Trimming leading/trailing whitespace

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 \"<string>\""
  exit 1
fi

input="$1"

# Remove unwanted chars except: alphanumerics, _ - . space
cleaned=$(echo "$input" | sed 's/[^a-zA-Z0-9_. -]//g')

# Normalize spaces
cleaned=$(echo "$cleaned" | sed 's/[[:space:]]\+/ /g')

# Trim leading/trailing spaces
cleaned=$(echo "$cleaned" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

echo "$cleaned"

