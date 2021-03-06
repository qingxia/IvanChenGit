#include "ace/FILE_IO.h"
#include "ace/INET_Addr.h"
#include "ace/Log_Msg.h"

#include "Logging_Server.h"
#include "Logging_Handler.h"

class Iterative_Logging_Server: public Logging_Server
{
protected:
    ACE_FILE_IO log_file_;
    Logging_Handler logging_handler_;

public:
    Iterative_Logging_Server(): logging_handler_(log_file_)
    {
    }

    Logging_Handler& logging_handler()
    {
        return logging_handler_;
    }

    virtual ~Iterative_Logging_Server()
    {
        log_file_.close();
    }

protected:
    virtual int open(u_short port)
    {
        if (-1 == make_log_file(log_file_))
        {
            ACE_ERROR_RETURN((LM_ERROR, "%p\n", "make_log_file()"), -1);
        }

        return Logging_Server::open(port);
    }

    virtual int handle_connections()
    {
        ACE_INET_Addr logging_peer_addr;

        if (-1 == acceptor().accept(logging_handler_.peer(), &logging_peer_addr))
        {
            ACE_ERROR_RETURN((LM_ERROR, "%p\n", "accept ()"), -1);
        }

        ACE_DEBUG((LM_DEBUG, "Accepted connection from %s\n", logging_peer_addr.get_host_name()));

        return 0;
    }

    virtual int handle_data(ACE_SOCK_Stream*)
    {
        while(-1 != logging_handler_.log_record())
            continue;

        logging_handler_.close(); // Close the socket handle.

        return 0;
    }
};
