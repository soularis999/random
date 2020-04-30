#include <iostream>

int main(){
  const double val = 4.6;
  const int a = 5;
  const int b = 7;

  std::cout << double(a) / b << std::endl;
  std::cout << (int) val << " actual " << val<< std::endl;

  /* c++ style of cast */
  std::cout << static_cast<int>(val) << " actual " << val << std::endl;
  return 0;
}
