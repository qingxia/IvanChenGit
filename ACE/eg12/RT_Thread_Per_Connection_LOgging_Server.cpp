#include "ace/Signal.h"

#include "RT_Thread_Per_Connection_Logging_Server.h"

int clean_up();

static void sigterm_handler(int /* signum */)
{
    ACE_DEBUG((LM_INFO, "%s\n", "Receive SIGTERM, going to cancel all the threads..."));

    clean_up();
}

int clean_up()
{
    // Cooperative thread cancelation.
    ACE_Thread_Manager::instance()->cancel_all();

    // Barrier synchronization, wait no more than a minute.
    ACE_Time_Value timeout(60);

    return ACE_Thread_Manager::instance()->wait(&timeout);
}

int main(int argc, char** argv)
{
    // Register to receive the <SIGTERM> signal.
    ACE_Sig_Action sa(sigterm_handler, SIGTERM);

    RT_Thread_Per_Connection_Logging_Server server;

    if (-1 == server.run(argc, argv))
    {
        ACE_ERROR_RETURN((LM_ERROR, "%p\n", "server.run()"), -1);
    }

    return clean_up();
}
