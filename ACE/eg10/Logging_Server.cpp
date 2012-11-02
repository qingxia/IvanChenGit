#include "ace/FILE_Addr.h"
#include "ace/FILE_Connector.h"
#include "ace/FILE_IO.h"
#include "ace/INET_Addr.h"
#include "ace/SOCK_Stream.h"

#include "Logging_Server.h"

int Logging_Server::run(int argc, char** argv)
{
    if (-1 == open(argc > 1 ? atoi(argv[1]) : 0))
    {
        return -1;
    }

    while(1)
    {
        if (-1 == wait_for_multiple_events())
            return -1;

        if (-1 == handle_connections())
            return -1;

        if (-1 == handle_data())
            return -1;
    }

    return 0;
}

int Logging_Server::open(u_short logger_port)
{
    // Raises the number of available socket handles to the maximum supported by the OS platform.
    ACE::set_handle_limit();

    ACE_INET_Addr server_addr;
    int result = 0;

    if (0 != logger_port)
    {
        result = server_addr.set(logger_port, INADDR_ANY);
    }
    else
    {
        result = server_addr.set("ace_logger", INADDR_ANY);
    }

    if (-1 == result)
    {
        return -1;
    }

    // Start listening and the second parmeter enable reuse of listen address for quick restarts.
    return acceptor_.open(server_addr, 1);
}

int Logging_Server::make_log_file(ACE_FILE_IO& logging_file, ACE_SOCK_Stream* logging_peer)
{
    // sizeof operator could be used on string literal 
    // which will return the size including the NULL terminator 
    char filename[MAXHOSTNAMELEN + sizeof(".log")];

    if (0 != logging_peer)
    {
        // Use client host name as file name.
        ACE_INET_Addr logging_peer_addr;
        logging_peer->get_remote_addr(logging_peer_addr);
        logging_peer_addr.get_host_name(filename, MAXHOSTNAMELEN);
        strcat(filename, ".log");
    }
    else
    {
        strcpy(filename, "logging_server.log");
    }

    ACE_FILE_Connector connector;
    return connector.connect(logging_file,
            ACE_FILE_Addr(filename),
            0, // No time-out.
            ACE_Addr::sap_any, // Ignored.
            0, // Don't try to reuse the addr.
            O_RDWR | O_CREAT | O_APPEND,
            ACE_DEFAULT_FILE_PERMS);
}
