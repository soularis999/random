#include <iostream>

int main()
{
    int a, b;
    std::cout << "Enter a:" << std::endl;
    std::cin >> a;

    std::cout << "Enter b:" << std::endl;
    std::cin >> b;

    std::cout << (a > b ? "a greater than b" : "a less than b") << std::endl;

    switch (a)
    {
    case 10:
        std::cout << "a is 10" << std::endl;
        break;
    case 25:
    case 50:
        std::cout << "a is 25 or 50" << std::endl;
        break;
    default:
        std::cout << "a is not in range" << std::endl;
    }

    return 0;
}