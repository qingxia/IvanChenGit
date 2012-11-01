#include "ace/Log_Msg.h"

#include "Reactive_Logging_Server_Ex.h"

int main(int argc, char** argv)
{
    Reactive_Logging_Server_Ex server;

    if (-1 == server.run(argc, argv))
    {
        ACE_ERROR_RETURN((LM_ERROR, "%p\n", "server.run()"), 1);
    }

    return 0;
}
