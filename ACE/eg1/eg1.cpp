#include "ace/INET_Addr.h"
#include "ace/SOCK_Connector.h"
#include "ace/SOCK_Stream.h"

void log(const char* msg)
{
    ACE::write_n(ACE_STDOUT, msg, strlen(msg));
}

void dummy()
{

}

int main(int argc, char** argv)
{
    const char* pathname = argc > 1 ? argv[1] : "/index.html";
    const char* server_hostname = argc > 2 ? argv[2] : "ace.ece.uci.edu";

    ACE_SOCK_Connector connector;
    ACE_SOCK_Stream peer;
    ACE_INET_Addr peer_addr;

    if (-1 ==  peer_addr.set(80, server_hostname))
    {
        log("peer_addr.set failed\n");
        return 1;
    }
    else if (-1 == connector.connect(peer, peer_addr))
    {
        log("connector.connect failed\n");
        return 1;
    }
    
    
    char buf[BUFSIZ];

    iovec iov[3];
    iov[0].iov_base = (void*)"GET ";
    iov[0].iov_len = 4;
    iov[1].iov_base = (void*)pathname;
    iov[1].iov_len = strlen(pathname);
    iov[2].iov_base = (void*)" HTTP/1.0\r\n\r\n";
    iov[2].iov_len = 13;

    if (-1 == peer.sendv_n(iov, 3))
    {
        log("peer.sendv_v failed\n");
        return 1;
    }

    for (ssize_t n = 0; (n = peer.recv(buf, sizeof(buf))) > 0; )
    {
        ACE::write_n(ACE_STDOUT, buf, n);
    }

    return peer.close();
}
