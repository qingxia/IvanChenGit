#include "ace/Log_Record.h"
#include "ace/Process.h"
#include "ace/Process_Manager.h"
#include "ace/Signal.h"

#include "Logging_Server.h"
#include "Logging_Handler.h"

class Logging_Process : public ACE_Process
{
private:
    Logging_Process(); // Force desired constructor to be used.

    char prog_name_[MAXPATHLEN + 1];
    ACE_SOCK_Stream logging_peer_;

public:
    Logging_Process(const char* prog_name, const ACE_SOCK_Stream& logging_peer) : logging_peer_ (logging_peer.get_handle())
    {
        strncpy(prog_name_, prog_name, MAXPATHLEN);
    }

    virtual int prepare(ACE_Process_Options& options)
    {
        if (-1 == options.pass_handle(logging_peer_.get_handle()))
        {
            ACE_ERROR_RETURN((LM_ERROR, "%p\n", "pass_handle()"), -1);
        }

        options.command_line("%s", prog_name_);
        options.avoid_zombies(1);
        options.creation_flags(ACE_Process_Options::NO_EXEC);

        ACE_DEBUG((LM_INFO, "%s\n", "Logging_Prcess::prepare succeed." ));

        return 0;
    }

    virtual void unmanage()
    {
        delete this;
    }
};

class Process_Per_Connection_Logging_Server : public Logging_Server
{
protected:
    char prog_name_[MAXPATHLEN + 1];

public:
    virtual int run(int argc, char** argv)
    {
        strncpy(prog_name_, argv[0], MAXPATHLEN);
        prog_name_[MAXPATHLEN] = '\0'; // Ennsure NULL-termination.

        if (3 == argc)
            return run_worker(argc, argv); // Only on Win32.
        else
            return run_master(argc, argv);
    }

protected:
    int run_master(int argc, char** argv)
    {
        u_short logger_port = 0;

        if (2 == argc)
            logger_port = atoi(argv[1]);

        if (-1 == open(logger_port))
            return -1;

        for (;;)
        {
            if (-1 == handle_connections())
                return -1;
        }

        return 0;
    }

    int run_worker(int argc, char** argv)
    {
        ACE_HANDLE socket_handle = static_cast<ACE_HANDLE>( atoi(argv[2]));
        ACE_SOCK_Stream logging_peer(socket_handle);

        handle_data(&logging_peer);

        logging_peer.close();

        return 0;
    }

    virtual int handle_connections()
    {
        ACE_SOCK_Stream logging_peer;

        if (-1 == acceptor().accept(logging_peer))
        {
            ACE_ERROR_RETURN((LM_ERROR, "%p\n", "acceoptr().accept()"), -1);
        }

        Logging_Process* logger = new Logging_Process(prog_name_, logging_peer);
        ACE_Process_Options options;
        pid_t pid = ACE_Process_Manager::instance()->spawn(logger, options);

        // Why zero ?
        if (0 == pid)
        {
            ACE_DEBUG((LM_INFO, "%P : pid is zero %d, current process id is %d\n", pid, ACE_OS::getpid()));
            acceptor().close();
            handle_data(&logging_peer);
            delete logger;
            ACE_OS::exit(0);
        }

        ACE_DEBUG((LM_INFO, "%P : pid is %d, current process id is %d\n", pid, ACE_OS::getpid()));

        logging_peer.close();
        if (-1 == pid)
        {
            ACE_ERROR_RETURN((LM_ERROR, "%p\n", "spawn()"), -1);
        }

        int rc = ACE_Process_Manager::instance()->wait(0, ACE_Time_Value::zero);
        if (-1 == rc)
        {
            ACE_DEBUG((LM_INFO, "%P : %p\n", "ACE_Process_Manager::instance()->wait()"));
        }
    }

    virtual int handle_data(ACE_SOCK_Stream* logging_peer)
    {
        // Ensure blocking <recv>s.   for what ?!!
        logging_peer->disable(ACE_NONBLOCK);

        ACE_FILE_IO log_file;
        make_log_file(log_file, logging_peer);
        Logging_Handler logging_handler(log_file, *logging_peer);

        while(-1 != logging_handler.log_record())
            continue;

        log_file.close();
        return 0;
    }
};
