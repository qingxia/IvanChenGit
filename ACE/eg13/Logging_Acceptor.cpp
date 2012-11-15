#include "ace/Log_Msg.h"

#include "Logging_Acceptor.h"
#include "Logging_Event_Handler.h"

int Logging_Acceptor::open(const ACE_INET_Addr& local_addr)
{
    if (-1 == acceptor_.open(local_addr))
    {
        ACE_ERROR_RETURN((LM_ERROR, "%p\n", "acceptor_.open()"), -1);
    }

    return reactor()->register_handler(this, ACE_Event_Handler::ACCEPT_MASK);
}

int Logging_Acceptor::handle_input(ACE_HANDLE)
{
    Logging_Event_Handler* peer_handler = 0;
    ACE_NEW_RETURN(peer_handler, Logging_Event_Handler(reactor()), -1);

    if (-1 == acceptor_.accept(peer_handler->peer()))
    {
        delete peer_handler;

        ACE_ERROR_RETURN((LM_ERROR, "%p\n", "acceptor_.accept()"), -1);
    }
    else if (-1 == peer_handler->open())
    {
        peer_handler->handle_close();

        ACE_ERROR_RETURN((LM_ERROR, "%p\n", "peer_handler->open()"), -1);
    }

    return 0;
}

int Logging_Acceptor::handle_close(ACE_HANDLE, ACE_Reactor_Mask)
{
    acceptor_.close();
    delete this;

    return 0;
}
