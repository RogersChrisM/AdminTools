#utils.utils
import numpy as np
import os
import shutil
import logging
import subprocess
import sys
from datetime import datetime

def needs_log_transform(value):
    """
    Detect if value should be transformed with -log10. Works with strings and numeric types.

    Returns True if:
    - String contains scientific notation with negative exponent (e.g., 'e-26')
    - Numeric and positive but very small (<1e-3)
    Otherwise returns False.
    """
    try:
        fval = float(value)
    except (ValueError, TypeError):
        s = str(value).lower()
        return 'e-' in s

    if 0 < fval < 1e-3:
        return True
    return False

def transform_value(val):
    val_str = str(val).lower()
    try:
        val_float = float(val)
    except ValueError:
        raise ValueError("Input is not a valid number or numeric string")
    if 'e-' in val_str and val_float > 0:
        return -np.log10(val_float)
    else:
        return val_float

def reset_directory(paths):
    if isinstance(paths, str):
        paths = [paths]
    elif not isinstance(paths, (list, tuple)):
        raise TypeError("Input must be a string or a list/tuple of strings")

    for path in paths:
        expanded_path = os.path.expanduser(path)
        if os.path.exists(expanded_path):
            shutil.rmtree(expanded_path)
        os.makedirs(expanded_path)
        
def get_loggers(debug,logger):
    if logger and not debug:
        log=logger.info
        error=logger.error
    else:
        log=print
        error=print
    return log, error

def setup_logging(debug=False, log_dir='~/logs/', logfile=None):
    log_dir=os.path.expanduser(log_dir)
    os.makedirs(log_dir, exist_ok=True)
    if logfile is None:
        calling_scriptName=os.path.basename(sys.argv[0])
        base, _=os.path.splitext(script_name)
        logfile=f'{base}.log'
    if not debug:
        timestamp=datetime.now().strftime('%Y%m%d_%H%M%S')
        base, ext = os.path.splitext(logfile)
        if not ext:
            ext='.log'
        log_filename = f'{base}_{timestamp}{ext}'
        log_path = os.path.join(log_dir, log_filename)
        logging.basicConfig(filename=log_path, level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')
        logger = logging.getLogger(__name__)
        return logger, logger.info, logger.error
    else:
        return None, print, print
        
def verify_signature(script_path='/Users/crogers/Desktop/python_scripts/admin_tools/verify_signature.sh', targetFile=None, logger=None, debug=None):
    """
    Calls verify_signature.sh on the current script or a specified target file.

    Params:
        script_path (str): Path to the signature verification shell script.
        target_file (str): File to verify. Defaults to the calling script.
    """
    log,error=get_loggers(logger, debug)
    script_path = os.path.abspath(script_path)
    if not os.path.exists(script_path):
        error(f"[ERROR] Signature verification script not found: {script_path}")
        sys.exit(1)

    if target_file is None:
        # Get the absolute path of the currently running script
        target_file = os.path.abspath(sys.argv[0])

    log(f"[INFO] Running signature verification on: {target_file}")
    result = subprocess.run([script_path, target_file], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    if result.returncode != 0:
        error(f"[ERROR] Signature verification failed:\n{result.stderr.strip()}")
        sys.exit(1)

    log("[INFO] Signature verification passed.")

if __name__=='__main__':
    print("Not for standalone use.")
    exit(1)
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-07-01
# SHA256: 6f384e04d736e84288d7f7ad830044cb03271f6c0c0e2971e350796c27b09a61
