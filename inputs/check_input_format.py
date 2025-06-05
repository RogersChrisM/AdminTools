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

if __name__=='__main__':
    print("Not for standalone use.")
    exit(1)
