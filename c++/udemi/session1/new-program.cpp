#include <iostream>

int main()
{
    std::cout << "Hello test23423423" << std::endl;

    int a;
    a = 10;

    std::cout << "A = " << a << std::endl;
    std::cout << "addr A = " << &a << std::endl;

    a = 20;

    std::cout << "A = " << a << std::endl;
    std::cout << "addr A = " << &a << std::endl;

    int b, c = 20;
    std::cout << "b = " << b << " " << &b << std::endl;
    std::cout << "c = " << c << " " << &c << std::endl;

    short t1 = 5;
    std::cout << "t1 = " << t1 << " " << &t1 << std::endl;

    float t2 = 5.555;
    std::cout << "t2 = " << t2 << " " << &t2 << std::endl;

    double t3 = 5.555555555556;
    std::cout << "t3 = " << t3 << " " << &t3 << std::endl;

    char t4 = 'c';
    std::cout << "t4 = " << t4 << " " << &t4 << std::endl;

    std::string t5 = "test me";
    std::cout << "t5 = " << t5 << " " << &t5 << std::endl;

    std::string t5b = " again ";
    std::string comb = t5 + t5b;
    std::cout << "comb = " << comb << " " << &comb << std::endl;

    bool t6 = true;
    std::cout << "t6 = " << t6 << " " << &t6 << std::endl;

    unsigned short t7 = 65535; // 0 to 65535
    std::cout << "t7 = " << t7 << " " << &t7 << std::endl;

    const std::string T8 = "Constants!";
    std::cout << "T8 = " << T8 << " " << &T8 << std::endl;

    int input;
    std::cin >> input;
    std::cout << "input = " << input << " " << &input << std::endl;

    // operators
    a = 10, b = 5;
    std::cout << a + b << std::endl;
    std::cout << a - b << std::endl;
    std::cout << a * b << std::endl;
    std::cout << a / b << std::endl;

    return 0;
}
