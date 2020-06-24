#include <iostream>

int main(int argc, char * argv[]) {
  
  char a[] = { 'a', 'b', 'c', '\0' };
  std::cout << a << std::endl;

  char *b = "this is test";

  std::cout << b << std::endl;

  char *c[] = {"lala","la2"};
  std::cout << *c << std::endl;

  for(int i = 0; i < argc; i++) {
    std::cout << argv[i] << " ";
  }
  std::cout << std::endl;

  char x[] = "a";
  char y[] = "a";

  std::cout << (x == y) << std::endl;
  std::cout << (*x == *y) << std::endl;
  std::cout << (0 == strcmp(x,y))  << std::endl; // return 0 for equals or -1 / 1 for not  
}
