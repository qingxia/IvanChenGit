#include "ace/ACE.h"

void log(const char* msg)
{
    ACE::write_n(ACE_STDOUT, msg, strlen(msg));
}

