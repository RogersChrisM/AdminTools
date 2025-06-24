#utils.utils
import numpy as np
import os
import shutil
import logging
from datetime import datetime

def needs_log_transform(value):
    """
    Detect if value should be transformed with -log10.
    Works with strings and numeric types.

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

def setup_logging(debug=False, log_dir='~/logs/', logfile='script.log'):
    log_dir=os.expanduser(log_dir)
    os.makedirs(log_dir, exist_ok=True)
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

if __name__=='__main__':
    print("Not for standalone use.")
    exit(1)
