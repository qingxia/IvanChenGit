#include "ace/Log_Msg.h"

#include "Reactor_Logging_Server.h"
#include "Logging_Acceptor_Ex.h"

typedef Reactor_Logging_Server<Logging_Acceptor_Ex> Server_Logging_Daemon;

int main(int argc, char** argv)
{
    ACE_Reactor reactor;
    Server_Logging_Daemon* server = 0;

    ACE_NEW_RETURN(server,
            Server_Logging_Daemon(argc, argv, &reactor),
            1);

    if (-1 == reactor.run_reactor_event_loop())
    {
        ACE_ERROR_RETURN((LM_ERROR, "%p\n", "run_reactor_event_loop()"), -1);
    }

    return 0;
}
