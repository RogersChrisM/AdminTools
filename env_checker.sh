#!/bin/bash
# env_checker.sh - Check if required environment variables and commands are set/available
#
# Usage:
#   env_checker.sh --vars VAR1 VAR2 ... --cmds cmd1 cmd2 ...
#
# Example:
#   env_checker.sh --vars HOME PATH --cmds curl git

print_usage() {
  echo "Usage: $0 --vars VAR1 VAR2 ... --cmds cmd1 cmd2 ..."
  exit 1
}

if [[ $# -eq 0 ]]; then
  print_usage
fi

REQUIRED_VARS=()
REQUIRED_CMDS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --vars)
      shift
      while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
        REQUIRED_VARS+=("$1")
        shift
      done
      ;;
    --cmds)
      shift
      while [[ $# -gt 0 && ! "$1" =~ ^-- ]]; do
        REQUIRED_CMDS+=("$1")
        shift
      done
      ;;
    *)
      echo "Unknown option: $1"
      print_usage
      ;;
  esac
done

# Check environment variables
echo "Checking environment variables..."
missing_vars=()
for var in "${REQUIRED_VARS[@]}"; do
  if [[ -z "${!var}" ]]; then
    missing_vars+=("$var")
  else
    echo "  $var = ${!var}"
  fi
done

if (( ${#missing_vars[@]} > 0 )); then
  echo "Missing environment variables: ${missing_vars[*]}"
else
  echo "All required environment variables are set."
fi

# Check commands availability
echo "Checking required commands..."
missing_cmds=()
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    missing_cmds+=("$cmd")
  else
    echo "  Command '$cmd' is available."
  fi
done

if (( ${#missing_cmds[@]} > 0 )); then
  echo "Missing commands: ${missing_cmds[*]}"
else
  echo "All required commands are available."
fi

# Return nonzero if any missing
if (( ${#missing_vars[@]} > 0 || ${#missing_cmds[@]} > 0 )); then
  exit 1
else
  exit 0
fi
