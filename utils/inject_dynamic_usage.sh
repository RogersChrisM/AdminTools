#!/bin/bash

TARGET_DIR=${1:-.}
SCRIPT_NAME=$(basename "$0")

# Find all .sh files recursively
find "$TARGET_DIR" -type f -name "*.sh" | while read -r FILE; do
  [[ "$(basename "$FILE")" == "$SCRIPT_NAME" ]] && continue

  # Skip if file already contains a real usage echo (not just "# Usage:")
  if grep -q '^[[:space:]]*echo[[:space:]]\+"Usage:' "$FILE"; then
    echo "[SKIP] $FILE already has a usage block"
    continue
  fi

  # Reset associative array for each file
  declare -A arg_map=()

  # Extract positional arguments
  while IFS= read -r line; do
    # Skip comments
    [[ "$line" =~ ^[[:space:]]*# ]] && continue

    # Match VAR=$1 or VAR=${1}
    if [[ "$line" =~ ^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=[\$]\{?([1-9][0-9]*)\}? ]]; then
      var="${BASH_REMATCH[1]}"
      pos="${BASH_REMATCH[2]}"
      arg_map["$pos"]="$var"
    fi
  done < "$FILE"

  # Build ordered usage string
  usage_args=()
  max_pos=0
  for pos in "${!arg_map[@]}"; do
    [[ $pos -gt $max_pos ]] && max_pos=$pos
  done
  for (( i=1; i<=max_pos; i++ )); do
    var="${arg_map[$i]}"
    [[ -n "$var" ]] && usage_args+=("<$(echo "$var" | tr '[:upper:]' '[:lower:]')>")
  done

  # If no arguments found, skip
  if (( ${#usage_args[@]} == 0 )); then
    echo "[SKIP] $FILE (no positional arguments found)"
    continue
  fi

  # Prepare usage block
  read -r -d '' USAGE_BLOCK << EOF
if [[ \$# -lt $max_pos ]]; then
  echo "Usage: \$0 ${usage_args[*]}"
  exit 1
fi

EOF

  # Insert after last initial comment line
  INSERT_LINE=$(awk '
    BEGIN { last_comment = 0 }
    /^[[:space:]]*#/ { last_comment = NR }
    !/^[[:space:]]*#/ { exit }
    END { print last_comment + 1 }
  ' "$FILE")

  tmp=$(mktemp)
  head -n $((INSERT_LINE - 1)) "$FILE" > "$tmp"
  echo "$USAGE_BLOCK" >> "$tmp"
  tail -n +"$INSERT_LINE" "$FILE" >> "$tmp"
  mv "$tmp" "$FILE"
  echo "[OK] Injected usage block into $FILE"
done
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: bd6454170d3c7fe8c7534c101356729284918fa59d2ff44da77d2162b2ae9178
