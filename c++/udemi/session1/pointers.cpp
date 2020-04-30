#include <iostream>

int main() {

  int var = -5;
  std::cout << &var << " " << *&var << std::endl;

  // the asterisc indicates that this int will be storing the address
  // of the variable - it can only be initialized with address to existing
  // value - not to value itself
  int *p;
  // to assign address of value to pointer - do not use start
  p = &var;
  // to assign the value to the address pointer points to - use star
  *p = 10;

  std::cout << &var << " " << *&var << std::endl;
  std::cout << p << " " << *p << std::endl;

  var = 111;

  std::cout << &var << " " << *&var << std::endl;
  std::cout << p << " " << *p << std::endl;

  int * const p_const = &var; // this pointer needs to be initialized
  *p_const = 10;
  std::cout << p_const << " " << *p_const << std::endl;

  const int * p_const2 = &var; // this pointer needs to be initialized
                                //*p_const2 = 10; cannot do that cause it's const
  std::cout << p_const2 << " " << *p_const2 << std::endl;

  const int * const p_const3 = &var; // this pointer needs to be initialized and is cost
                                //*p_const2 = 10; cannot do that cause it's const
  std::cout << p_const3 << " " << *p_const3 << std::endl;

  // address of pointer itself
  int ** pointer_to_pointer_address = &p;

  std::cout << "p 2 p " << pointer_to_pointer_address
            << " " << *pointer_to_pointer_address
            << " " << **pointer_to_pointer_address << std::endl;

  // array
  int a[3] = {1,2,3};
  std::cout << a  << "\n"
            << " " << &a[0] << " " << &a[1] << " " << &a[2] << "\n"
            << " " << a << " " << a + 1 << " " << a + 2 << "\n"
            << " " << *a << " " << *(a + 1) << " " << *(a + 2) << "\n"
            << std::endl;

  int * p2 = &a[0];

  std::cout << p << "\n"
            << " " << *p2  << "\n"
            << " " << ++*p2  << "\n"
            << " " << *++p2  << "\n"
            << " " << *p2  << "\n"    
            << " " << *p2++  << "\n"
            << " " << *p2  << "\n"        
            << std::endl;
  
  return 0;
}
