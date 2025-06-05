#!/bin/bash

# Usage: ./check_file_format.sh <format> <filename>

format=$1
file=$2

if [ ! -f "$file" ]; then
  echo "false"
  exit 1
fi

case "$format" in
  bed)
    # Check first 10 lines have >=3 tab-separated columns, start < end numeric
    head -n 10 "$file" | grep -vE '^(track|browser)' | awk '
      NF < 3 {exit 1}
      $2 !~ /^[0-9]+$/ {exit 1}
      $3 !~ /^[0-9]+$/ {exit 1}
      $2 >= $3 {exit 1}
    '
    if [ $? -eq 0 ]; then echo "true"; else echo "false"; fi
    ;;

  bedgraph)
    # Like bed, but >=4 columns, 4th is float
    head -n 10 "$file" | grep -vE '^(track|browser)' | awk '
      NF < 4 {exit 1}
      $2 !~ /^[0-9]+$/ {exit 1}
      $3 !~ /^[0-9]+$/ {exit 1}
      $2 >= $3 {exit 1}
      $4 !~ /^-?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$/ {exit 1}
    '
    if [ $? -eq 0 ]; then echo "true"; else echo "false"; fi
    ;;

  tsv)
    # Check if file contains tabs
    head -n 10 "$file" | grep -q $'\t' && echo "true" || echo "false"
    ;;

  csv)
    # Check if file contains commas but not tabs
    head -n 10 "$file" | grep -q ',' && ! head -n 10 "$file" | grep -q $'\t' && echo "true" || echo "false"
    ;;

  bigwig)
    # Use bigWigInfo tool from UCSC (must be installed and in PATH)
    if command -v bigWigInfo &> /dev/null; then
      bigWigInfo "$file" &> /dev/null && echo "true" || echo "false"
    else
      echo "false"
    fi
    ;;

  bam)
    if command -v samtools &> /dev/null; then
      samtools quickcheck "$file" && echo "true" || echo "false"
    else
      echo "false"
    fi
    ;;

  *)
    echo "false"
    ;;
esac

