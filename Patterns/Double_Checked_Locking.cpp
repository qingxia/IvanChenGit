// Double checked locking optimization pattern:
// Used to reduce the overhead of acquireing a lock by first testing
// the locking criterion without actually acquiring the lock.
// Only does if the locking criterion check indicates that locking is required.

// Used with Singleton pattern
// With this optimization, we theoretical only need to acquire the lock once 

T* GetInstance()
{
    // First test whether need to acquire lock
    if (0 == m_pInstance)
    {
        Acquire_Lock();

        // Second test whether some other thread has alredy initialized
        if (0 == m_pInstance)
        {
            m_pInstance = new Instance();
        }

        Release_Lock();
    }

    return m_pInstance;
}
