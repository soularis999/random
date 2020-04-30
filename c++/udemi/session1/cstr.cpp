#include <iostream>

int main() {
  std::string text = "Text";
  std::cout << text.length() << std::endl;
  
  char ch = text[0];
  
  std::cout << "First char: " << ch << std::endl;

  const char str[] = "test 123";
 
  std::cout << "Pointer to char array " << *(str) << std::endl;
  std::cout << "Pointer to char array incremented " <<*(str+1) << std::endl;

  const char * a = "this is a test";
  std::cout << "Pointer to string: first one " << *a << " - " << a << " - " << &a << std::endl;
  std::cout << "Pointer to string: getting pointer without increment " << a[1]
            << " - " << a << " - " << &a << std::endl;
  std::cout << "Pointer to string: getting pointer with increment " << *(++a)
            << " - " << a << " - " << &a << std::endl;
  
  const char * out = text.c_str();
  
  std::cout << "Pointer to c string " << *out << " - " << out << std::endl;
  std::cout << "String " << text << std::endl;

  // array to string
  const char data[] = "this is a test";
  const char* dataPtr = "this is also a tesT";

  std::cout << "Array string: " << data << ". and ptr:" << dataPtr << std::endl;

  const std::string dataStr = data;
  const std::string dataStr2 = dataPtr;

  std::cout << "String from array string: " << dataStr << std::endl;
  std::cout << "String from pointer: " << dataStr2 << std::endl;

  std::string newDataStr[5];
  newDataStr[0] = "hohohoh";
  std::cout << "String from string array[0]: " << newDataStr[0] << std::endl;
  std::cout << "String from string array[1]: " << newDataStr[1] << std::endl;
  std::cout << "String from string array[2]: " << newDataStr[2] << std::endl;
  return 0;
}
