#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

MODULE = NewRelic::Agent PACKAGE = NewRelic::Agent
PROTOTYPES: ENABLE

void
hello()
    CODE:
        printf("Hello, world!\n");
