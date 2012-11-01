#include "ace/Handle_Set.h"

#include "../eg4/Iterative_Logging_Server.h"

class Reactive_Logging_Server : public Iterative_Logging_Server
{
protected:
    // Keeps track of the acceptor socket handle and all the
    // conntcted stream socket handles.
    ACE_Handle_Set master_handle_set_;

    // Keep track of handles marked as active by <select>
    ACE_Handle_Set active_handles_;

    virtual int open(u_short logger_port)
    {
        Iterative_Logging_Server::open(logger_port);
        master_handle_set_.set_bit(acceptor().get_handle());
        acceptor().enable(ACE_NONBLOCK); // Socket with select should always be set as non-block.

        return 0;
    }

    virtual int wait_for_multiple_events()
    {
        active_handles_ = master_handle_set_;
        int width = (int) active_handles_.max_set() + 1;

        if (-1 == select(width, active_handles_.fdset(), 0, 0, 0))
            return -1;

        active_handles_.sync((ACE_HANDLE)active_handles_.max_set() + 1);

        return 0;
    }

    virtual int handle_connections()
    {
        if (active_handles_.is_set(acceptor().get_handle()))
        {
            while (0 == (acceptor().accept(logging_handler().peer())))
            {
                master_handle_set_.set_bit(logging_handler().peer().get_handle());
            }

            // Remove acceptor handle from further consideration.
            active_handles_.clr_bit(acceptor().get_handle());
        }

        return 0;
    }

    virtual int handle_data(ACE_SOCK_Stream*)
    {
        ACE_Handle_Set_Iterator peer_iterator(active_handles_);

        for (ACE_HANDLE handle = 0; (handle = peer_iterator()) != ACE_INVALID_HANDLE;)
        {
            logging_handler().peer().set_handle(handle);

            if ( -1 == logging_handler().log_record())
            {
                // Handle connection shutdown or comm failure.
                master_handle_set_.clr_bit(handle);
                logging_handler().close();
            }
        }
    }
};
