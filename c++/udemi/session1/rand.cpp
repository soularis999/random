#include <iostream>

void lottery(int, int);

int main() {

  std::cout << "Time: " << std::time(NULL) << std::endl;
  lottery(49,6);
}

void lottery(int total_balls, int balls_to_draw) {
  if(total_balls < balls_to_draw) {
    return;
  }

  srand(time(NULL)); //seeds

  int *balls = new int[balls_to_draw];
  for(int i = 0; i < balls_to_draw; i++) {
    balls[i] = rand() % total_balls + 1;
    std::cout << balls[i] << std::endl;

    for(int j = 0; j < i; j++) {
      if(balls[j] == balls[i]) {
        i--;
        break;
      }
    }
  }
}
