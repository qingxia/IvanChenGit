#include "ace/Log_Msg.h"

#include "Logging_Acceptor_Ex.h"

int Logging_Acceptor_Ex::handle_input(ACE_HANDLE)
{
	Logging_Event_Handler_Ex* peer_handler = 0;
	ACE_NEW_RETURN(peer_handler, Logging_Event_Handler_Ex(reactor()), -1);
	
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
