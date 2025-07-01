#!/usr/bin/env python3
import sys
for file in sys.argv[1:]:
    with open(file) as f:
        for i, line in enumerate(f, 1):
            if not line.strip():
                print(f"[WARN] Empty line at {i} in {file}")
            if "\t" in line and "," in line:
                print(f"[WARN] Mixed delimiters at {i} in {file}")
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-06-26
# SHA256: 4f49a939b3e4d168a386225f447b0300932c5faabb35e791c6b16fcf88ad6a91
