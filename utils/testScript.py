#!/usr/bin/env python3

"""
FileName: testScript.py

Author: Christopher M. Rogers (https://github.com/RogersChrisM/)

Description:


Params:


Script Requirements:
    admin_tools (CM Rogers)

Associated Package:

Creation Date: Thu Jun 26 17:31:55 CDT 2025
    Host: L241568
    OS: Darwin 24.5.0
    Bash: 3.2.57(1)-release
    User: crogers

Usage:
    ./testScript.py -i <inputFile> [--debug]
"""

import argparse
from utils.utils import reset_directory, setup_logging, get_loggers
from inputs.utils import check_input_file


#def <function>( ,logger=None, debug=False):
#    """
#
#
#    Params:
#
#    [Result(s)/Returns]:
#
#    """
#    log, error=get_loggers(debug,logger)


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('-i', '--inputFile', required=True, help='Input file')
    #parser.add_argument()
    parser.add_argument('--debug', action='store_true', help='Not for end user.')
    args=parser.parse_args()

debug=args.debug

success, error=check_input_file(args.inputFile, delimiter='\t')
if not success:
    print(f"InputFile Validation Failure", error)
    exit(1)

 logger, log, error=setup_logging(debug=args.debug, logfile='testScript.py')
#out_struct=['./output',
#            './output/temp']

#reset_directory(out_struct)


if __name__ == '__main__':
    main()



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: acd4e01a17129717a15eec422539c701cb7d7614a8d2445c05345f0241309995
