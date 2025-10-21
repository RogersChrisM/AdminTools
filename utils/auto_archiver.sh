#!/bin/bash

#FileName: auto_archiver.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#    Tar subdirectories not accessed in the last [num_days] days (default 10)
#
#Params:
#
#
#Script Requirements:
#    admin_tools (CM Rogers)
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#Creation Date: Tue Sep  2 16:16:52 CDT 2025
#    Host: L241568
#    OS: Darwin 24.6.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#    archive_old_dirs.sh <directory> [num_days]

usage() {
    	echo "Usage: $0 <directory> [num_days]"
    	echo "  <directory>        Root folder to check for old subdirectories"
    	echo "  [num_days]         Subdirectories not accessed in the last num_days will be archived (default 10)"
    	echo "  -r, --recursive    Archive subdirectories recursively"
    	exit 1
}

ROOT_DIR=""
NUM_DAYS=10
RECURSIVE=false

while [[ $# -gt 0 ]]; do
       	case "$1" in
		-r|--recursive)
            		RECURSIVE=true
            		shift
            		;;
        	-*)
            		echo "Unknown option: $1"
            		usage
            		;;
        	*)
            		if [ -z "$ROOT_DIR" ]; then
                		ROOT_DIR="$1"
            		elif [[ "$1" =~ ^[0-9]+$ ]]; then
                		NUM_DAYS="$1"
            		else
                		usage
            		fi
            		shift
            		;;
    	esac
done

# input checks
if [ ! -d "$ROOT_DIR" ]; then
    	echo "Error: '$ROOT_DIR' is not a valid directory."
    	exit 1
fi

if ! [[ "$NUM_DAYS" =~ ^[0-9]+$ ]] ; then
    	echo "Error: num_days must be a positive integer."
    	exit 1
fi

echo "Archiving subdirectories in '$ROOT_DIR' not accessed in the last $NUM_DAYS days..."
if [ "$RECURSIVE" = true ]; then
	FIND_ARGS=(-mindepth 1 -type d)
else
	FIND_ARGS=(-mindepth 1 -maxdepth 1 -type d)
fi

# Recursively (or top-level) archive subdirs
find "$ROOT_DIR" "${FIND_ARGS[@]}" | sort -r | while read -r SUBDIR; do
	if [[ "$(basename "$SUBDIR")" == .* ]]; then
		continue
	fi
    	
	# Skip the root itself
    	if [ "$SUBDIR" = "$ROOT_DIR" ]; then
		continue
    	fi

    	# Skip if any file in the non-hidden folder has been modified in last NUM_DAYS
    	if find "$SUBDIR" -type f ! -path "*/.*" -mtime -"$NUM_DAYS" | grep -q .; then
        	echo "Skipping '$SUBDIR': contains recently modified files."
        	continue
    	fi

	# Skip if subdir has no non-hidden content
	if ! find "$SUBDIR" -mindepth 1 ! -path "*/.*" | grep -q .; then
		echo "Skipping '$SUBDIR': no content to archive."
		continue
	fi

    	PARENT_DIR="$(dirname "$SUBDIR")"
	
	# Skip if parent directory is hidden
	if [[ "$(basename "$PARENT_DIR")" == .* ]]; then
    		echo "Skipping archive for directory under hidden parent: $SUBDIR"
    		continue
	fi

    	ARCHIVE_NAME="${PARENT_DIR}/$(basename "$SUBDIR")_$(date +%Y%m%d).tar.gz"
    	echo "Archiving '$SUBDIR' -> '$ARCHIVE_NAME'..."
    	tar -czf "$ARCHIVE_NAME" -C "$PARENT_DIR" "$(basename "$SUBDIR")"
    
    	# Verify archive
    	if tar -tzf "$ARCHIVE_NAME" > /dev/null; then
        	echo "[INFO] Archive successful: $ARCHIVE_NAME"
        	rm -rf "$SUBDIR"
        	echo "[INFO] Original folder deleted: $SUBDIR"
    	else
        	echo "[ERROR] Archive verification failed for $SUBDIR. Folder not deleted."
    	fi
done

echo "Done."



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-09-03
# SHA256: a4383e6e889b7ed87622aa4ec36b51d29d64c200bcbdd81735dc346df32c1490
