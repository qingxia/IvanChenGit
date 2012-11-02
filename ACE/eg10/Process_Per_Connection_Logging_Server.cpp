#include "Process_Per_Connection_Logging_Server.h"

static void sigterm_handler(int /* signum */ ) { /* No-op. */ }

int main(int argc, char** argv)
{
    // Register to receive the <SIGTERM> signal.
    ACE_Sig_Action sa(sigterm_handler, SIGTERM);

    Process_Per_Connection_Logging_Server server;

    if (-1 == server.run(argc, argv) && errno != EINTR)
    {
        ACE_ERROR_RETURN((LM_ERROR, "%p\n", "server.run()"), -1);
    }

    // Barrier synchronization.
    return ACE_Process_Manager::instance()->wait();
}
