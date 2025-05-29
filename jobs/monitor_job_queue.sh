#!/bin/bash
# Monitors SLURM queue by user
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <user> <days> <dry_run>"
  exit 1
fi
USER=${1:-$USER}
squeue -u "$USER"
