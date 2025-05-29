#!/bin/bash

# Safe cron wrapper

# Usage: wrap_cron.sh <script>

SCRIPT=$1
STAMP=$(date +%Y%m%d_%H%M%S)
bash "$SCRIPT" > "logs/${SCRIPT##*/}_$STAMP.log" 2>&1

