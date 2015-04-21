#ifdef __cplusplus
extern "C" {
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
}
#endif

#include "Agent.h"

MODULE = NewRelic::Agent        PACKAGE = NewRelic::Agent
INCLUDE_COMMAND: $^X -MExtUtils::XSpp::Cmd -e xspp -- NewRelic-Agent.xsp
