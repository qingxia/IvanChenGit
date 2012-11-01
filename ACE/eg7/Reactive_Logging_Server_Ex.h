#include "ace/ACE.h"
#include "ace/Handle_Set.h"
#include "ace/Hash_Map_Manager.h"
#include "ace/Synch.h"
#include "ace/Log_Msg.h"

#include "Logging_Server.h"
#include "Logging_Handler.h"

typedef ACE_Hash_Map_Manager<ACE_HANDLE, ACE_FILE_IO*, ACE_Null_Mutex> LOG_MAP;

class Reactive_Logging_Server_Ex : public Logging_Server
{
protected:
    // Associate an active handle to an <ACE_FILE_IO> pointer.
    LOG_MAP log_map_;

    // Keep tracek of acceptor socket and all the connected
    // stream socket handles.
    ACE_Handle_Set master_handle_set_;

    // Keep track of read handles marked as active by <select>.
    ACE_Handle_Set active_read_handles_;

    virtual int open(u_short port)
    {
        Logging_Server::open(port);
        master_handle_set_.set_bit(acceptor().get_handle());
        acceptor().enable(ACE_NONBLOCK);

        return 0;
    }

    virtual int wait_for_multiple_events()
    {
        active_read_handles_ = master_handle_set_;
        int width = (int)active_read_handles_.max_set() + 1;

        return ACE::select(width, active_read_handles_);
    }

    virtual int handle_connections()
    {
        ACE_SOCK_Stream logging_peer;

        while(-1 != acceptor().accept(logging_peer))
        {
            master_handle_set_.set_bit(logging_peer.get_handle());

            ACE_FILE_IO* log_file = new ACE_FILE_IO;

            // Use the client's host name as the logfile name.
            make_log_file(*log_file, &logging_peer);

            // Add the new <logging_peer>'s handle to the map and
            // to the set of handles we <select> for input.
            if (-1 == log_map_.bind(logging_peer.get_handle(), log_file))
            {
                ACE_ERROR_RETURN((LM_ERROR, "%p\n", "log_map_.bind()"), 1);
            }
        }

        return 0;
    }

    virtual int handle_data(ACE_SOCK_Stream*)
    {
        ACE_Handle_Set_Iterator peer_iterator(active_read_handles_);

        for (ACE_HANDLE handle = 0; (handle = peer_iterator()) != ACE_INVALID_HANDLE;)
        {
            ACE_FILE_IO* log_file;

           if (-1 == log_map_.find(handle, log_file))
           {
                ACE_ERROR((LM_ERROR, "%p\n", "log_map_.find()") );
                continue;
           }
           else
           {
               ACE_TRACE((LM_NOTICE, "%p\n", "log_map_.find()") );
           }

            Logging_Handler logging_handler(*log_file, handle);

            if (-1 == logging_handler.log_record())
            {
                logging_handler.close();
                master_handle_set_.clr_bit(handle);
                log_map_.unbind(handle);
                log_file->close();

                delete log_file;
            }
        }

        return 0;
    }
};
