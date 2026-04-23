#!/bin/bash
# ssh_key_manager.sh - Simple SSH key management utility
#
# Usage:
#   ssh_key_manager.sh list
#   ssh_key_manager.sh add <key_path>
#   ssh_key_manager.sh remove <key_path>
#   ssh_key_manager.sh backup <backup_dir>

COMMAND=$1
ARG=$2

backup_ssh_keys() {
  local backup_dir=$1
  mkdir -p "$backup_dir"
  cp ~/.ssh/id_* "$backup_dir" 2>/dev/null
  echo "Backed up SSH keys to $backup_dir"
}

list_keys() {
  ssh-add -l 2>/dev/null || echo "No keys loaded in ssh-agent."
}

add_key() {
  local key=$1
  if [[ ! -f "$key" ]]; then
    echo "Key file not found: $key"
    exit 1
  fi
  ssh-add "$key" && echo "Added $key to ssh-agent."
}

remove_key() {
  local key=$1
  ssh-add -d "$key" && echo "Removed $key from ssh-agent."
}

case "$COMMAND" in
  list) list_keys ;;
  add) add_key "$ARG" ;;
  remove) remove_key "$ARG" ;;
  backup) backup_ssh_keys "$ARG" ;;
  *)
    echo "Usage:"
    echo "  $0 list"
    echo "  $0 add <key_path>"
    echo "  $0 remove <key_path>"
    echo "  $0 backup <backup_dir>"
    exit 1
    ;;
esac

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: b56ed8a615f850de5b8107dccb6f0d8b15c94d3db8eef9f9b4e899263ab6d08e
