#include <iostream>

void swap(int &, int &);

int & swapWithReturn(int &, int &);

int main() {
  std::string name1 = "test";
  std::string &ref1 = name1;

  std::cout << name1 << " " << &name1 << std::endl;
  std::cout << ref1 << " " << &ref1 << std::endl;

  name1 = "test 123";

  std::cout << name1 << " " << &name1 << std::endl;
  std::cout << ref1 << " " << &ref1 << std::endl;

  ref1 = "test 345";

  std::cout << name1 << " " << &name1 << std::endl;
  std::cout << ref1 << " " << &ref1 << std::endl;

  int x, y;
  x = 10;
  y = 20;
  swap(x, y);
  std::cout << x << " " << y << std::endl;

  x = 10;
  y = 20;
  int& ret = swapWithReturn(x, y);
  ret = 100;
  
  std::cout << x << " " << y << " " << ret << std::endl;
  
  return 0;
}

void swap(int &x, int &y) {
  int t;
  t = x;
  x = y;
  y = t;
}

int & swapWithReturn(int &x, int &y) {
  int t;
  t = x;
  x = y;
  y = t;

  // cannot return t because it's a local variable that
  // will disappear as soon as this method is done
  return x;
}
