###### Demo of scripts included via source commands ########
#!/bin/bash

# Source helper scripts (adjust paths as needed)
source ./log_helper.sh
source ./colorize_output.sh
source ./progress_bar.sh
source ./spinner.sh

LOG_FILE="./demo.log"
log_info "Script started"

echo_green "Starting a long task with progress bar..."

for i in {0..100..10}; do
  progress_bar $i
  sleep 0.3
done

echo_green "Progress bar completed!"

echo_yellow "Starting a spinner task..."

spinner_start
# Simulate a task taking 5 seconds
sleep 5
spinner_stop

echo_green "Spinner task completed!"

log_info "Script finished"
echo_blue "Check the log file ($LOG_FILE) for details."
