#ifndef _Agent_h_
#define _Agent_h_

#include <string>

using namespace std;

class Agent {
  public:
    Agent(
      const char* license_key          = NULL,
      const char* app_name             = NULL,
      const char* app_language         = NULL,
      const char* app_language_version = NULL
    );
    ~Agent();
    void initialize();
    long begin_transaction();
    int set_transaction_name(long transaction_id, const char* name);
    int add_transaction_attribute(long transaction_id, const char* key, const char* value);
    int set_transaction_type_other(long transaction_id);
    int end_transaction(long transaction_id);
    const char* get_license_key();
    const char* get_app_name();
    const char* get_app_language();
    const char* get_app_language_version();

  private:
    string license_key;
    string app_name;
    string app_language;
    string app_language_version;
    bool   config_loaded;
};

#endif

