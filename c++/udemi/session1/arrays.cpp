#include <iostream>

int main()
{
    int size = 3;
    int a[size];
    a[0] = 1;
    a[1] = 22;
    a[2] = -33;

    for (int i = 0; i < size; i++)
    {
        std::cout << a[i] << std::endl;
    }

    int col = 3, row = 5;
    int biArray[col][row];
    memset(biArray, 0, sizeof(int) * col * row);

    std::cout << &biArray << std::endl;
    for (int colPos = 0; colPos < col; colPos++)
    {
        std::cout.width(20);
        std::cout << &biArray[colPos] << std::endl;
        for (int rowPos = 0; rowPos < row; rowPos++)
        {
            std::cout << biArray[colPos][rowPos] << " " << &biArray[colPos][rowPos] << std::endl;
        }
    }
}