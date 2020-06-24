#ifndef PEOPLE_H_INCLUDED
#define PEOPLE_H_INCLUDED

#include <string>

using namespace std;

class Data {
private:
  string name;
  
public:
  void setName(const string);
  string getName() { return name; }
};

#endif
