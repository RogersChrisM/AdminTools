#!/usr/bin/env python3
import sys
for file in sys.argv[1:]:
    with open(file) as f:
        for i, line in enumerate(f, 1):
            if not line.strip():
                print(f"[WARN] Empty line at {i} in {file}")
            if "\t" in line and "," in line:
                print(f"[WARN] Mixed delimiters at {i} in {file}")
