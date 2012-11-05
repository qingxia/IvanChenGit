// Double checked locking optimization pattern:
// Used to reduce the overhead of acquireing a lock by first testing
// the locking criterion without actually acquiring the lock.
// Only if the locking criterion check indicates that locking is 
// required does the catual locking logic proceed.

// Used with Singleton pattern
// With this optimization, we theoretical only need to acquire the lock once 

T* GetInstance()
{
    // First test whether need to acquire lock
    if (0 == pInstance)
    {
        Acquire_Lock();

        // Second test whether some other thread has alredy initialized
        if (0 == pInstance)
        {
            pInstance = new Instance();
        }

        Release_Lock();
    }

    return pInstance;
}
