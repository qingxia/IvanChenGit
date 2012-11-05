#include "Thread_Per_Connection_Logging_Server.h"
#include "ace/Sched_Params.h"

class RT_Thread_Per_Connection_Logging_Server : public Thread_Per_Connection_Logging_Server
{
public:
    virtual int open(u_short port)
    {
        ACE_Sched_Params fifo_sched_params(ACE_SCHED_FIFO,
                ACE_Sched_Params::priority_min(ACE_SCHED_FIFO),
                ACE_SCOPE_PROCESS);

        if (-1 == ACE_OS::sched_params(fifo_sched_params))
        {
            if (EPERM == errno || ENOTSUP == errno)
            {
                ACE_DEBUG((LM_INFO, "Warning: user's not superuser, so we'll run in the time-shared scheduler\n"));
            }
            else
            {
                ACE_ERROR_RETURN((LM_ERROR, "%p\n", "ACE_OS::sched_params()"), -1);
            }
        }
        else
        {
            ACE_DEBUG((LM_INFO, "Great we'll handle connections in real time priority\n"));
        }

        return Thread_Per_Connection_Logging_Server::open(port);
    }

protected:
    virtual int handle_data(ACE_SOCK_Stream* logging_client)
    {
        int prio = ACE_Sched_Params::next_priority(ACE_SCHED_FIFO,
                ACE_Sched_Params::priority_min(ACE_SCHED_FIFO),
                ACE_SCOPE_THREAD);

        ACE_OS::thr_setprio(prio);

        return Thread_Per_Connection_Logging_Server::handle_data(logging_client);
    }
};
