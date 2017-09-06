def matrix_shift(matrix):
    """
    Given NxN matrix shift it to appropriate side. The assumption is N=M
    matrix: given NxN matrix = shift to one side
    :return:
    """
    n = len(matrix)
    upper = n / 2
    for row in range(0, upper):
        max = n - row - 1
        for col in range(row, max):
            data = matrix[row][col]
            matrix[row][col] = matrix[max - col + row][row]
            matrix[max - col + row][row] = matrix[max][max - col + row]
            matrix[max][max - col + row] = matrix[col][max]
            matrix[col][max] = data
    return matrix


if __name__ == "__main__":
    # assert matrix_shift([[1, 2], [3, 4]]) == [[3, 1], [4, 2]]
    # assert matrix_shift([[1, 2, 3], [4, 5, 6], [7, 8, 9]]) == [[7, 4, 1], [8, 5, 2], [9, 6, 3]]
    assert matrix_shift([[1, 2, 3, 4], [5, 6, 7, 8], [9, 'A', 'B', 'C'], ['D', 'E', 'F', 'G']]) == [['D', 9, 5, 1],
                                                                                                    ['E', 'A', 6, 2],
                                                                                                    ['F', 'B', 7, 3],
                                                                                                    ['G', 'C', 8, 4]]
