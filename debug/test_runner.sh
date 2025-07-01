#!/bin/bash
# test_runner.sh - Run all test scripts (*.test.sh) in a directory and summarize results
#
# Usage:
#   test_runner.sh [test_directory]
#
# Defaults to current directory if no argument given.

TEST_DIR=${1:-.}
TOTAL=0
PASSED=0
FAILED=0

echo "Running tests in directory: $TEST_DIR"

for test_script in "$TEST_DIR"/*.test.sh; do
  [[ -e "$test_script" ]] || { echo "No test scripts found in $TEST_DIR"; break; }
  ((TOTAL++))
  echo -n "Running $test_script ... "
  bash "$test_script"
  EXIT_CODE=$?
  if [[ $EXIT_CODE -eq 0 ]]; then
    echo "PASS"
    ((PASSED++))
  else
    echo "FAIL (exit code $EXIT_CODE)"
    ((FAILED++))
  fi
done

echo "-----"
echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"

if (( FAILED > 0 )); then
  exit 1
else
  exit 0
fi

