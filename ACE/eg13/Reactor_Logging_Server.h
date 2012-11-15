#include "ace/ACE.h"
#include "ace/Reactor.h"

template <class ACCEPTOR>
class Reactor_Logging_Server : public ACCEPTOR
{
public:
    Reactor_Logging_Server(int argc, char** argv, ACE_Reactor* reactor)
        : ACCEPTOR(reactor)
    {
        u_short logger_port = argc > 1 ? atoi(argv[1]) : 0;
        typename ACCEPTOR::PEER_ADDR server_addr;
        int result;

        if (logger_port != 0)
        {
            result = server_addr.set(logger_port, INADDR_ANY);
        }
        else
        {
            result = server_addr.set("ace_logger", INADDR_ANY);
        }

        if (-1 != result)
        {
            result = ACCEPTOR::open(server_addr);
        }

        if (-1 == result)
        {
            reactor->end_reactor_event_loop();
        }
    }
};

