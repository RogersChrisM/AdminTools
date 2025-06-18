def parse_as_matrix(filepath):
    with open(filepath,'r') as f:
        matrix=[line.strip().split('\t') for line in f if line.strip()]
        return matrix
        
def check_matrix(matrix):
    num_rows = len(matrix)
    num_cols=max(len(row) for row in matrix) if matrix, else 0
    
    row_lengths = [len(row) for row in matrix]
    missing_vals = not all(length == num_cols for length in row_lengths)
    
    return num_rows, num_cols, has_missing

if __name__=='__main__':
    print("not for standalone use")
    exit(1)
