#include <iostream>

using namespace std;

struct Data {
  string name;
  short age;
} d1, d2;

void test(Data*);
void test(Data&);

int main() {

  d1.name = "d1";
  d2.name = "d2";
  
  Data data;

  data.name = "test name";
  data.age = 12;

  std::cout << data.name << std::endl;

  Data dataArr[5];
  dataArr[0].name = "name 1";
  dataArr[0].age = 77;
  dataArr[1].name = "name 2";
  dataArr[1].age = 33;
  
  std::cout << "With pointer " << (*(dataArr)).name << std::endl;
  std::cout << "With pointer to next " << (*(dataArr + 1)).name << std::endl;
  std::cout << "With pointer to next next " << (*(dataArr + 2)).name << std::endl;
  std::cout << "With reference " << (*&dataArr[0]).name << std::endl;
  std::cout << "With arrow notation " << (dataArr)->name << std::endl;
  std::cout << "With arrouw notation " << (dataArr+1)->name << std::endl;

  // create pointer
  Data * dataPtr = &data;
  test(dataPtr);
  std::cout << "Pointer to data " << dataPtr->name << std::endl;

  test(data);
  std::cout << "Ref to data " << dataPtr->name << std::endl;

  // pass by ref vs pointer
  return 0;
}

void test(Data * data) {
  data->name = "pointer";
}

void test(Data & data) {
  data.name = "ref";
}
