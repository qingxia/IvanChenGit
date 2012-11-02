#include "ace/OS.h"
#include "ace/Process.h"
#include "ace/Log_Msg.h"

int main(int argc, char** argv)
{
    ACE_Process_Options options;
    char* n_env = 0;
    int n = 0;
    int result = 0;

    if (1 == argc) // Top-level process.
    {
        n_env = ACE_OS::getenv("FACTORIAL");
        n = (n_env == 0 ? 0 : atoi (n_env));

        options.command_line("%s %d", argv[0], 0 == n ? 10 : n);
    }
    else if (1 == atoi(argv[1]))
    {
        n = 1;
        result = 1;

        ACE_DEBUG((LM_INFO, "%P : n is %d, result is %d\n", n, result));

        return result; // Base case.
    }
    else
    {
        n = atoi(argv[1]);
        options.command_line("%s %d", argv[0], n - 1);
    }

    ACE_Process child;
    child.spawn(options); // Make the "recursive" call.
    child.wait();

    result = n * child.exit_code();

    ACE_DEBUG((LM_INFO, "%P : n is %d, child.exit_code() is %d, result is %d\n", n, child.exit_code(), result));

    return result; // Compute n factorial.
}
