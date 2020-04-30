#include <iostream>

void mult(int &, int);
void mult2(int *, int);
int * mult3(int *, int);

void multArr(int (&)[10], int);
void multArr2(int *, double, int);

int main() {
  int a = 10;
  mult(a, 20);

  std::cout << a << std::endl;

  mult2(&a, 10);
  std::cout << a << std::endl;

  int *b = mult3(&a, 10);
  std::cout << a << " " << *b << std::endl;

  *b = 10;
  std::cout << a << " " << *b << std::endl;

  int arr[10];
  for(int i = 0; i < sizeof(arr) / sizeof(arr[0]); i++) {
    arr[i] = i;
    std::cout << arr[i] << " ";
  }
  std::cout << std::endl;
  
  multArr(arr, 10);
  /*
We can pass arr itself because arr points to address of first element
of the array
   */
  multArr2(arr, 0.1, sizeof(arr) / sizeof(arr[0]));
  /*
Now we are sending address of first element in array
  */
  multArr2(&arr[0], 10.5, sizeof(arr) / sizeof(arr[0]));

  
  for(int i = 0; i < sizeof(arr) / sizeof(arr[0]); i++) {
    std::cout << arr[i] << " ";
  }
  std::cout << std::endl;
}

void mult(int & val, int amount) {
  val *= amount;
}

void mult2(int * val, int amount) {
  *val = *val * amount;
}

int * mult3(int * val, int amount) {
  *val = *val * amount;
  return val;
}

void multArr(int (&arr)[10], int amount) {
  for(int i = 0; i < sizeof(arr) / sizeof(int); i++) {
    arr[i] = arr[i] * amount;
    std::cout << arr[i] << " ";
  }
  std::cout << std::endl;
}

void multArr2(int * arr, double amount, int size) {
  while(size--) {
    arr[size] = arr[size] * amount;
    std::cout << arr[size] << " ";
  }
  std::cout << std::endl;
}
