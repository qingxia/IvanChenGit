#include "ace/SOCK_Stream.h"
#include "ace/Thread_Manager.h"

#include "Logging_Server.h"
#include "LOgging_Handler.h"

class Thread_Per_Connection_Logging_Server : public Logging_Server
{
private:
    class Thread_Args
    {
    public:
        Thread_Args(Thread_Per_Connection_Logging_Server* lsp) : this_(lsp)
        {
        }

        Thread_Per_Connection_Logging_Server* this_;
        ACE_SOCK_Stream logging_peer_;
    };

    // Passed as a parameter to <ACE_Thread_Manager::spawn>.
    static void* run_svc(void* arg)
    {
        Thread_Args* thread_args = static_cast<Thread_Args*>(arg);

        thread_args->this_->handle_data(&(thread_args->logging_peer_));
        thread_args->logging_peer_.close();

        delete thread_args;
    }

public:
    virtual int run(int argc, char** argv)
    {
        if (-1 == open(argc > 1 ? atoi(argv[1]) : 0))
            return -1;

        for(;;)
        {
            if (-1 == wait_for_multiple_events())
                return -1;

            if (-1 == handle_connections())
                return -1;
        }

        return 0;
    }

protected:
    virtual int handle_connections()
    {
        Thread_Args* thread_args = new Thread_Args(this);
        
        if (-1 == acceptor().accept(thread_args->logging_peer_))
        {
            ACE_ERROR_RETURN((LM_ERROR, "%p\n", "acceptor()"), -1);
        }
        else if (-1 == ACE_Thread_Manager::instance()->spawn(Thread_Per_Connection_Logging_Server::run_svc, // Pointer to function entry point.
                    static_cast<void*>(thread_args), // <run_svc> parameter.
                    THR_DETACHED | THR_SCOPE_SYSTEM))
        {
            ACE_ERROR_RETURN((LM_ERROR, "%p\n", "spawn()"), -1);
        }
        else
        {
            ACE_DEBUG((LM_INFO, "%s\n", "handle_connections works fine."));
            return 0;
        }
    }

    virtual int handle_data(ACE_SOCK_Stream* logging_peer)
    {
        ACE_FILE_IO log_file;
        make_log_file(log_file, logging_peer);

        // Place the connection into blocking mode.
        // For the underlying handle_data use block socket operation
        logging_peer->disable(ACE_NONBLOCK);

        Logging_Handler logging_handler(log_file, *logging_peer);
        ACE_Thread_Manager* tm = ACE_Thread_Manager::instance();
        ACE_thread_t me = ACE_OS::thr_self();

        // Keep handling log records until client closes connection
        // or this thread is asked to cancel itself.
        while (!tm->testcancel(me) && logging_handler.log_record() != -1)
        {
            ACE_DEBUG((LM_INFO, "%s\n", "I am still alive, going to handle next record!"));

            continue;
        }

        ACE_DEBUG((LM_INFO, "%p\n", "See you ..."));

        log_file.close();

        return 0;
    }
};
