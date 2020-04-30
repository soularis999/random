#ifndef PEOPLE_H_INCLUDED
#define PEOPLE_H_INCLUDED

using namespace std;

class Data {
private:
  std::string name;
  
public:
  void setName(const std::string);
  std::string getName() { return name; }
};

#endif
