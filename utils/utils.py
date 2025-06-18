import numpy as np

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

if __name__=='__main__':
    print("Not for standalone use.")
    exit(1)
