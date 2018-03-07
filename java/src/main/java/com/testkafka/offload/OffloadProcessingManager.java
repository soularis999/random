package com.testkafka.offload;

import java.io.Closeable;

public interface OffloadProcessingManager<T> extends Closeable {


    interface Offloader<T> {
        /**
         * Called before the lock is initiated - can be used to setup the state before the processing is done
         * Returned 'true' to continue with locking and offloading or 'false' to skip
         *
         * @param resource - the resource that was provided to the manager - could be null if null was provided in init method
         */
        default boolean onBeforeOffload(T resource) throws Exception {
            return true;
        }


        /**
         * Called after lock was initiated - thus the shared stated can be safely modified
         *
         * @param resource - the resource that was provided to the manager - could be null if null was provided in init method
         */
        void onOffload(T resource) throws Exception;

        /**
         * Called after the lock was released - to clean up the resources
         *
         * @param resource    - the resource that was provided to the manager - could be null if null was provided in init method
         * @param wasExecuted will indicate if the offload was performed and depends on what was returned in @see onBeforeOffload
         * @param throwable   is the exception thrown the value will be an exception otherwise null will be passed
         */
        default void onAfterOffload(T resource, boolean wasExecuted, Throwable throwable) throws Exception {
            // No - Op
        }
    }

    /**
     * Initialize the manager
     */
    void init(T resource);

    void addOffloader(Offloader<T> offloader);

    void removeOffloader(Offloader<T> offloader);

    void begin();

    void commit();
}