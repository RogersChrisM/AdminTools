#!/bin/bash
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <env_name>"
  exit 1
fi

# Activate conda or venv

# Usage: setup_env.sh <env_name>

ENV_NAME=$1

if command -v conda &> /dev/null; then
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate "$ENV_NAME"
elif [ -d "$ENV_NAME/bin" ]; then
    source "$ENV_NAME/bin/activate"
else
    echo "No conda or venv found."
    exit 1
fi

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: 04aef15725048698f6d63bc80221b2c42f9deec07567bc6e10935ed93caf94da
