#include "ace/OS.h"
#include "ace/ACE.h"
#include "ace/Process.h"

int main(int argc, char** argv)
{
    ACE_Process_Options options;
    FILE* fp = 0;
    char* n_env = 0;
    int n = 0;

    if (1 == argc) // Top-level process.
    {
        n_env = ACE_OS::getenv("FACTORIAL");
        n = n_env == 0 ? 0 : atoi(n_env);
        options.command_line("%s %d", argv[0], 0 == n ? 10 : n);

        const char* working_dir = ACE_OS::getenv("WORKING_DIR");
        if (working_dir)
            options.working_directory(working_dir);

        fp = fopen("factorial.log", "a");
        options.setenv("PROGRAM", ACE::basename(argv[0]));
    }
    else
    {
        fp = fopen("factorial.log", "a");

        if (1 == atoi(argv[1]))
        {
            fprintf(fp, "[%s | %d] : base case\n", ACE_OS::getenv("PROGRAM"), ACE_OS::getpid());
            fclose(fp);

            return 1; // Base case
        }
        else
        {
            n = atoi(argv[1]);
            options.command_line("%s %d", argv[0], n - 1);
        }
    }

    ACE_Process child;
    child.spawn(options); // Make the "recursive" call.
    child.wait();

    int factorial = n * child.exit_code(); // Compute n factorial.
    fprintf(fp, "[%s | %d] : %d! == %d\n", ACE_OS::getenv("PROGRAM"), ACE_OS::getpid(), n, factorial);

    fclose(fp);
    return factorial;
}
