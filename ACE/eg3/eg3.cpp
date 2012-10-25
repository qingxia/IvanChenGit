#include "ace/ACE.h"
#include "ace/Message_Block.h"

#include "../base.h"

int main(int argc, char** argv)
{
    ACE_Message_Block* head = new ACE_Message_Block(BUFSIZ);
    ACE_Message_Block* mblk = head;

    while(1)
    {
        size_t nbytesRead = 0;
        ssize_t nbytes = ACE::read_n(ACE_STDIN, mblk->wr_ptr(), mblk->size(), &nbytesRead);

        mblk->wr_ptr(nbytesRead); // Need to adjust the ptr by user if we directly modify the momoey in the message block ...

        mblk->cont(new ACE_Message_Block(BUFSIZ));
        mblk = mblk->cont();

        // nbytes will be zero if encount EOF or error
        // even nbytes is zero the nbytesRead could still not be zero
        if (nbytes <= 0)
        {
            log("Receive EOF\n");
            break;
        }
    }

    for (mblk = head; mblk != 0; mblk = mblk->cont())
    {
        ACE::write_n(ACE_STDOUT, mblk->rd_ptr(), mblk->length());
    }

    head->release(); // Thie releases all the memory in the chain.

    return 0;
}
