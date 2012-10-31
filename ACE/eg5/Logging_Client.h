#include "ace/SOCK_Stream.h"

class Logging_Client
{
public:
    // Send <log_record> to the server.
    int send(const ACE_Log_Record& log_record);

    ACE_SOCK_Stream& peer() { return logging_peer_; }

    // Close the connection to the server.
    ~Logging_Client() { logging_peer_.close(); }

private:
    ACE_SOCK_Stream logging_peer_; // Connected to server.
};
