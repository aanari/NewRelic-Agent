#ifndef _Agent_h_
#define _Agent_h_

#include <string>

class Agent {
public:
  Agent();
  ~Agent() {}

  int GetInt() { return fInt; }
  const char* GetString();

  void SetValue(int arg);
  void SetValue(const char* arg);

private:
  std::string fString;
  int fInt;
};

#endif

