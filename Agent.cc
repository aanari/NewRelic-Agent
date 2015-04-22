#include "Agent.h"

#include "newrelic_common.h"
#include "newrelic_collector_client.h"
#include "newrelic_transaction.h"

#include <string>

using namespace std;

Agent::Agent(
  const char* license_key_,
  const char* app_name_,
  const char* app_language_,
  const char* app_language_version_
)
: license_key(string(license_key_)),
  app_name(string(app_name_)),
  app_language(string(app_language_)),
  app_language_version(string(app_language_version_))
{
  if (!license_key.empty() &&
      !app_name.empty() &&
      !app_language.empty() &&
      !app_language_version.empty())
    config_loaded = true;
}

const char* Agent::get_license_key() {
  return license_key.c_str();
}

const char* Agent::get_app_name() {
  return app_name.c_str();
}

const char* Agent::get_app_language() {
  return app_language.c_str();
}

const char* Agent::get_app_language_version() {
  return app_language_version.c_str();
}
