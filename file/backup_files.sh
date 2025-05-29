#!/bin/bash

###          Directions to run          ###
#  1. Make backup_files.sh executable     #
#  2. Edit chrontab                       #
#  3. add line to run daily
###         Example Run Method          ###
#  1. chmod +x /path/to/backup_files.sh   #
#  2. crontab -e                          #
#  3. 0 2 * * * /path/to/backup_files.sh  # <- this line makes it run at 2AM.

# === Config ===
SRC_DIR="path/to/source" #change to source directory location
DEST_DIR="path/to/source" #change to target directory location (i.e. cloud backup)
LOG_FILE="/var/log/backup_files.log"

# === Timestamp ===
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# === Execute ===
mkdir -p "$DEST_DIR"

echo "[$TIMESTAMP]: Starting backup from $SRC_DIR to $DEST_DIR" >> "$LOG_FILE"

rsync -avh --delete "$SRC_DIR/" "$DEST_DIR/" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP]: Backup completed successfully." >> "$LOG_FILE"
else
    echo "[$TIMESTAMP]: Backup encountered errors!" >> "$LOG_FILE"
fi
