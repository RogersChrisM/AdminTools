#!/bin/bash
# log_helper.sh
# Usage: source log_helper.sh
# Provides log_info, log_warn, log_error functions

LOG_FILE=""

log_timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

log_info() {
  local msg="$1"
  local line="[$(log_timestamp)] [INFO] $msg"
  echo "$line"
  [[ -n "$LOG_FILE" ]] && echo "$line" >> "$LOG_FILE"
}

log_warn() {
  local msg="$1"
  local line="[$(log_timestamp)] [WARN] $msg"
  echo "$line" >&2
  [[ -n "$LOG_FILE" ]] && echo "$line" >> "$LOG_FILE"
}

log_error() {
  local msg="$1"
  local line="[$(log_timestamp)] [ERROR] $msg"
  echo "$line" >&2
  [[ -n "$LOG_FILE" ]] && echo "$line" >> "$LOG_FILE"
}

