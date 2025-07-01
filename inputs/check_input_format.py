#!/usr/bin/env python3

import os
import subprocess

def check_input_file(format_name, filename, script_path='~/Desktop/python_scripts/admin_tools/inputs/check_file_format.sh'):
    # formats supported: 'bed', 'bedgraph', 'tsv', 'csv', 'bigwig', 'bam'
    script_path = os.path.expanduser(script_path)
    try:
        result = subprocess.run(
            [script_path, format_name, filename],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip().lower() == 'true'
    except subprocess.CalledProcessError:
        return False
        
def check_homer_annotation_input():
    pass

def check_narrowPeak():
    pass
    
def check_bed():
    pass
    
def check_deseq2_input():
    pass

if __name__=='__main__':
    print("Not for standalone use.")
    exit(1)
    
    
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-07-01
# SHA256: 5f4ed0d580594e0c4c8a88ce932744c0df2a8b9c24bd9efdd551b39a49c15a6f
