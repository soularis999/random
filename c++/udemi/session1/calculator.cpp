#include <iostream>

int main()
{
    while (true)
    {
        double v1, v2;
        char expr;

        std::cout << "Number 1" << std::endl;
        std::cin >> v1;

        std::cout << "Number 2" << std::endl;
        std::cin >> v2;

        std::cout << "Symbol" << std::endl;
        std::cout << "+" << std::endl;
        std::cout << "-" << std::endl;
        std::cout << "*" << std::endl;
        std::cout << "/" << std::endl;

        std::cin >> expr;

        std::system("clear");

        bool isSuccess = true;
        switch (expr)
        {
        case '+':
            std::cout << (v1 + v2) << std::endl;
            break;
        case '-':
            std::cout << (v1 - v2) << std::endl;
            break;
        case '*':
            std::cout << (v1 * v2) << std::endl;
            break;
        case '/':
            std::cout << (v1 / v2) << std::endl;
            break;
        default:
            std::cout << "Wrong symbol " << expr << std::endl;
            isSuccess = false;
        }

        if(isSuccess) {
            std::cout << "Continue (y/n)?" << expr << std::endl;
            std::cin >> expr;

            if('y' != expr) {
                break;
            }
        }
    }
    return 0;
}