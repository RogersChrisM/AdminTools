#!/bin/bash
# spinner.sh
# Usage: source spinner.sh
# Use spinner_start and spinner_stop

_spinner_pid=0
_spinner_chars='|/-\'

spinner_start() {
  local delay=0.1
  local i=0
  (
    while :; do
      printf "\r${_spinner_chars:i++%${#_spinner_chars}:1} "
      sleep $delay
    done
  ) &
  _spinner_pid=$!
  disown
}

spinner_stop() {
  if [[ $_spinner_pid -ne 0 ]]; then
    kill $_spinner_pid 2>/dev/null
    wait $_spinner_pid 2>/dev/null
    _spinner_pid=0
    printf "\r   \r"
  fi
}
