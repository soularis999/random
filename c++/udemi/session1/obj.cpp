#include <iostream>

int main() {

  int topLevel = 100;

  {
    int * val = new int;
    *val = 10;

    std::cout << val << " " << *val << std::endl;

    delete val;
    /*
      set val to null so that we would not use it after delete
    */
    val = NULL;

    /*
      this assignment is static - no need to delete it
    */
    val = &topLevel;

    std::cout << val << " " << *val << std::endl;
  }

  int amount;
  std::cout << "How much: " << std::endl;
  std::cin >> amount;

  int *p = new int[amount];
  for(int i = 0; i < amount; i++) {
    std::cout << "Enter the val " << (i+1) << " number " << std::endl;
    std::cin >> p[i];
  }

  for(int i = 0; i < amount; i++) {
    std::cout << "Val " << (i+1) << " number " << p[i] << std::endl;
  }

  delete []p;
  
  return 0;
}
