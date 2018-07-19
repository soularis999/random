#define _GNU_SOURCE

#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>


void get(int argc, char *argv[]) {
  cpu_set_t result;
  CPU_ZERO(&result);

  int data;
  data = sched_getaffinity(0, sizeof(result), &result);
  printf("data %d\n", data);
  if(data == -1) {
    perror("test\n");
  }

  int count = CPU_COUNT(&result);
  for(int i = 0; i <count; i++) {
    printf("result %d\n", CPU_ISSET(i, &result));
  }
}


void get2(int argc, char *argv[]) {
  char result[128];
  memset(&result[0], 0, sizeof(result));

  int data;
  data = sched_getaffinity(0, sizeof(result), &result);
  printf("data %d\n", data);
  if(data == -1) {
    perror("test\n");
  }

  for(int i = 0; i < 32; i++) {
    printf("result %d\n", result[i]);
  }
}

void main(int argc, char *argv[]) {
  get(argc, argv);
  get2(argc, argv);

  usleep(10 * 1000 * 1000);
}
