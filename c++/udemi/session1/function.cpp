#include <iostream>

int power(int val1, int val2);
double power(double, double);

int main() {
  std::cout << "result: " << power(2, 5) << std::endl;
  std::cout << "result2: " << power(2.2, 5.5) << std::endl;
  return 0;
}

int power(int val1, int val2) {
  return val1 * val2;
}

double power(double val1, double val2) {
  return val1 * val2;
}

