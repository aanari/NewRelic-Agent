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

Agent::~Agent() {
  newrelic_request_shutdown("Destructor called");
}

void Agent::initialize() {
  newrelic_register_message_handler(newrelic_message_handler);
  newrelic_init(
    license_key.c_str(),
    app_name.c_str(),
    app_language.c_str(),
    app_language_version.c_str()
  );
}

long Agent::begin_transaction(
  const char* name = NULL,
  bool is_web      = true
) {
  long transaction_id = newrelic_transaction_begin();
  if (name)
    newrelic_transaction_set_name(transaction_id, name);
  if (!is_web)
    newrelic_transaction_set_type_other(transaction_id);
  return transaction_id;
}

int Agent::end_transaction(long transaction_id) {
    return newrelic_transaction_end(transaction_id);
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
