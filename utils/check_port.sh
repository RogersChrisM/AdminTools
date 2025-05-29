#!/bin/bash
# Usage: check_port.sh <host> <port>
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <host> <port>"
  exit 1
fi
HOST=$1
PORT=$2
if nc -z $HOST $PORT; then
  echo "[OK] Port $PORT on $HOST is open."
else
  echo "[FAIL] Port $PORT on $HOST is closed or unreachable."
fi
