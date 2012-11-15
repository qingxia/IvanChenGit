#ifndef LOGGING_EVENT_HANDLER_
#define LOGGING_EVENT_HANDLER_

#include "ace/Event_Handler.h"

#include "Logging_Handler.h"

class Logging_Event_Handler : public ACE_Event_Handler
{
protected:
    // File where log records are writen.
    ACE_FILE_IO log_file_;

    Logging_Handler logging_handler_;

public:
    // Initialize the base class and logging handler.
    Logging_Event_Handler(ACE_Reactor* reactor)
        : ACE_Event_Handler(reactor),
        logging_handler_(log_file_)
    {
    }

    virtual ~Logging_Event_Handler() {}

    virtual int open(); // Activate the object.

    // Called by a reactor when logging events arrive.
    virtual int handle_input(ACE_HANDLE = ACE_INVALID_HANDLE);

    // Called when this object is destroyed, e.g., when it's
    // removed from a reactor.
    virtual int handle_close(ACE_HANDLE = ACE_INVALID_HANDLE, ACE_Reactor_Mask = 0);

    // Return socket handle of the contained <Logging_Handler>.
    virtual ACE_HANDLE get_handle() const
    {
        Logging_Handler& h = const_cast<Logging_Handler&>(logging_handler_);

        return h.peer().get_handle();
    }

    // Get a reference to the contained <ACE_SOCK_Stream>.
    ACE_SOCK_Stream& peer()
    {
        return logging_handler_.peer();
    }

    // Return a reference to the <log_file_>.
    ACE_FILE_IO& log_file() 
    {
        return log_file_;
    }
};

#endif
