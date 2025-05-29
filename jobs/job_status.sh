#!/bin/bash

# Check running jobs by pattern

# Usage: job_status.sh <pattern>

PATTERN=$1
ps aux | grep "$PATTERN" | grep -v grep
