#include "ace/INET_Addr.h"
#include "ace/Reactor.h"

#include "Logging_Acceptor.h"
#include "Logging_Event_Handler_Ex.h"

class Logging_Acceptor_Ex : public Logging_Acceptor
{
public:
    typedef ACE_INET_Addr PEER_ADDR;

    // Simple constructor to pass <ACE_Reactor> to base class.
    Logging_Acceptor_Ex(ACE_Reactor* r = ACE_Reactor::instance())
        : Logging_Acceptor(r)
    {
    }

    virtual int handle_input(ACE_HANDLE);
};
