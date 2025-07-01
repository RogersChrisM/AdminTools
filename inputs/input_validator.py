#!/usr/bin/env python3
import sys, os, csv

for filepath in sys.argv[1:]:
    if not os.path.isfile(filepath):
        print(f"[ERROR] File not found: {filepath}")
        continue
    with open(filepath) as f:
        try:
            sniffer = csv.Sniffer()
            dialect = sniffer.sniff(f.read(1024))
            f.seek(0)
            reader = csv.reader(f, dialect)
            rows = list(reader)
            print(f"[OK] {filepath}: {len(rows)} rows")
        except Exception as e:
            print(f"[ERROR] {filepath}: {e}")
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-06-26
# SHA256: bf0eae08d4a935b272cc169533c72dc57898a8e4d80e334a762f65c2da77b6bc
