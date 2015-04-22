#include "Agent.h"

#include "newrelic_common.h"
#include "newrelic_collector_client.h"
#include "newrelic_transaction.h"

#include <string>

using namespace std;

Agent::Agent() :
  fString(string("")),
  fInt(0)
{
}

const char* Agent::GetString() {
  return fString.c_str();
}

void Agent::SetValue(int arg) {
  fInt = arg;
}

void Agent::SetValue(const char* arg) {
  fString = string(arg);
}

