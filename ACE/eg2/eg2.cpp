#include "ace/Auto_Ptr.h"
#include "ace/INET_Addr.h"
#include "ace/SOCK_Acceptor.h"
#include "ace/SOCK_Stream.h"
#include "ace/Mem_Map.h"

#include "../base.h"

char* get_url_pathname(ACE_SOCK_Stream*)
{
    const char* pDummyPath = "./eg2.cpp";
    int iLen = strlen(pDummyPath);

    char* pPath = new char[iLen + 1];
    memset(pPath, 0, iLen + 1);
    strcpy(pPath, pDummyPath);

    return pPath;
}

int main()
{
    ACE_INET_Addr server_addr;
    ACE_SOCK_Acceptor acceptor;
    ACE_SOCK_Stream peer;

    if (-1 == server_addr.set(22334))
    {
        log("server_addr.set faild\n");
        return 1;
    }

    if (-1 == acceptor.open(server_addr))
    {
        log("acceptor.open failed\n");
        return 1;
    }

    while(1)
    {
        if (-1 == acceptor.accept(peer))
        {
            log("acceptor.accept failed\n");
            return 1;
        }

        peer.disable(ACE_NONBLOCK);

        auto_ptr<char> pathname(get_url_pathname(&peer));
        ACE_Mem_Map mapped_file(pathname.get());

        if (-1 == (peer.send_n(mapped_file.addr(), mapped_file.size())))
        {
            log("peer.send_n failed\n");
            return 1;
        }
        
        peer.close();
    }

    return acceptor.close() == -1 ? 1 : 0;
}
