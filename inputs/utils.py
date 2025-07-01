import os
import csv

def check_input_file(inputFile, delimiter='\t', num_cols=None, num_rows=None):
    """
    Validates an input file for:
    - existence
    - correct delimiter usage
    - expected number of columns per row
    - expected number of rows

    Args:
        inputFile (str): Path to the input file.
        delimiter (str): Delimiter used in the file (default is tab).
        num_cols (int or None): Expected number of columns.
        num_rows (int or None): Expected number of rows.

    Returns:
        tuple: (success: bool, error_message: str or None)
    """

    if not os.path.isfile(inputFile):
        return False, f"File not found: {inputFile}"

    try:
        with open(inputFile, 'r', newline='') as f:
            reader = csv.reader(f, delimiter=delimiter)
            rows = list(reader)
    except Exception as e:
        return False, f"Error reading file with delimiter '{repr(delimiter)}': {e}"

    if num_rows is not None and len(rows) != num_rows:
        return False, f"Expected {num_rows} rows but found {len(rows)}."

    if num_cols is not None:
        for i, row in enumerate(rows):
            if len(row) != num_cols:
                return False, f"Row {i+1} has {len(row)} columns; expected {num_cols}."

    return True, None

# Example usage
# success, error = check_input_file("data.tsv", delimiter="\t", num_cols=5, num_rows=100)
# if not success:
#     print("Validation failed:", error)
# else:
#     print("Validation passed.")


def parse_as_matrix(filepath):
    with open(filepath,'r') as f:
        matrix=[line.strip().split('\t') for line in f if line.strip()]
        return matrix
        
def check_matrix(matrix):
    num_rows = len(matrix)
    num_cols=max(len(row) for row in matrix) if matrix else 0
    
    row_lengths = [len(row) for row in matrix]
    missing_vals = not all(length == num_cols for length in row_lengths)
    
    return num_rows, num_cols, missing_vals



if __name__=='__main__':
    print("Not for standalone use.")
    exit(1)
