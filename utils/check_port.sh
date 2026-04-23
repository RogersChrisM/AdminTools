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
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: de402568d001efcc62427e7a5b3acf1d1673bc119f5200b678403021a4e837c7
