#!/bin/bash
# Usage: standardize_filenames.sh [-r] <directory>
# -r : recursive (default is non-recursive)
# Calls auto_renamer.sh on files in the given directory

RECURSIVE=0

while getopts "r" opt; do
  case $opt in
    r) RECURSIVE=1 ;;
    *) echo "Usage: $0 [-r] <directory>"
       exit 1 ;;
  esac
done
shift $((OPTIND -1))

DIR=$1

if [[ -z "$DIR" || ! -d "$DIR" ]]; then
  echo "Error: Valid directory must be provided"
  echo "Usage: $0 [-r] <directory>"
  exit 1
fi

if [[ $RECURSIVE -eq 1 ]]; then
  find "$DIR" -type f | while read -r file; do
    bash utils/auto_renamer.sh "$file"
  done
else
  find "$DIR" -maxdepth 1 -type f | while read -r file; do
    bash utils/auto_renamer.sh "$file"
  done
fi
