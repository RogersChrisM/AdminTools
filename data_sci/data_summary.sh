#!/bin/bash
# data_summary.sh - Generate a summary report for a CSV/TSV data file
#
# Usage:
#   data_summary.sh <data_file> [delimiter]
#
# delimiter defaults to comma (,), set tab as delimiter with $'\t'

DATA_FILE=$1
DELIM=${2-","}

if [[ -z "$DATA_FILE" || ! -f "$DATA_FILE" ]]; then
  echo "Usage: $0 <data_file> [delimiter]"
  echo "Example: $0 data.csv ,"
  echo "         $0 data.tsv \$'\t'"
  exit 1
fi

echo "Data summary for $DATA_FILE (delimiter: '$DELIM')"

# Count rows (excluding header)
ROWS=$(tail -n +2 "$DATA_FILE" | wc -l)
# Count columns (from header)
COLS=$(head -n1 "$DATA_FILE" | awk -F"$DELIM" '{print NF}')

echo "Rows (excluding header): $ROWS"
echo "Columns: $COLS"

echo "Missing values per column:"

awk -F"$DELIM" -v header=1 '
  NR==1 {
    for (i=1; i<=NF; i++) {
      missing[i]=0
      colname[i]=$i
    }
    next
  }
  {
    for (i=1; i<=NF; i++) {
      if ($i == "" || $i == "NA") missing[i]++
      # Collect values for numeric columns
      if ($i ~ /^[0-9.]+$/) {
        sum[i] += $i
        count[i]++
        vals[i][count[i]] = $i
      }
    }
  }
  END {
    for (i=1; i<=length(missing); i++) {
      printf "%s: %d missing\n", colname[i], missing[i]
    }
    print ""
    # Basic stats for numeric columns
    print "Basic stats for numeric columns (mean, min, max):"
    for (i=1; i<=length(missing); i++) {
      if (count[i] > 0) {
        mean = sum[i]/count[i]
        min = vals[i][1]
        max = vals[i][1]
        for (j=1; j<=count[i]; j++) {
          if (vals[i][j] < min) min=vals[i][j]
          if (vals[i][j] > max) max=vals[i][j]
        }
        printf "%s: mean=%.3f min=%.3f max=%.3f\n", colname[i], mean, min, max
      }
    }
  }
' "$DATA_FILE"

