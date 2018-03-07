package com.testkafka.offload;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public abstract class AbstractOffloadProcessingManager<T> implements OffloadProcessingManager<T> {

    private static final Logger logger = LoggerFactory.getLogger(AbstractOffloadProcessingManager.class);

    private final Runnable runnable = () -> {
        final Offloader<T> offloader = AbstractOffloadProcessingManager.this.offloader;
        final T resource = AbstractOffloadProcessingManager.this.resource;

        if (null == offloader) {
            return;
        }

        boolean result = false;
        Throwable throwable = null;
        try {
            /*
            do before offload - before the lock is taken
             */
            result = offloader.onBeforeOffload(resource);

            if (result) {
                try {
                    /*
                    Take a lock and do offload
                     */
                    int count = 0;
                    while (!AbstractOffloadProcessingManager.this.writeLock.tryLock(100, TimeUnit.MILLISECONDS)) {
                        count++;
                        logger.info("Cannot acquire write lock {}. Continue looping {}", AbstractOffloadProcessingManager.this.lock, count);
                        if (10 == count) {
                            throw new Exception("Could not acquire lock " + count + " times");
                        }
                    }

                    offloader.onOffload(resource);
                } finally {
                    AbstractOffloadProcessingManager.this.writeLock.unlock();
                }
            }
        } catch (Throwable e) {
            logger.error("Error offloading process ", e);
            throwable = e;
        } finally {
            try {
                /*
                cleanup resources after lock was released
                */
                offloader.onAfterOffload(resource, result, throwable);
            } catch (Exception e1) {
                logger.error("Error after offloading process ", e1);
            }
        }
    };

    private final Lock readLock;
    private final Lock writeLock;
    private final ReadWriteLock lock;

    private volatile Offloader<T> offloader;
    private volatile T resource;
    private volatile boolean isInitDone = false;

    public AbstractOffloadProcessingManager(ReadWriteLock lock) {
        this.lock = lock;
        this.readLock = lock.readLock();
        this.writeLock = lock.writeLock();
    }

    @Override
    public void init(T resource) {
        try {
            this.writeLock.lock();

            if (isInitDone) {
                return;
            }
            this.resource = resource;
            registerJob(runnable);
            isInitDone = true;

        } finally {
            this.writeLock.unlock();
        }
    }

    /**
     * register will be called on initial startup only
     *
     * @param runnable
     * @return
     */
    protected abstract boolean registerJob(Runnable runnable);

    @Override
    public void addOffloader(Offloader<T> offloader) {
        this.offloader = offloader;
    }

    @Override
    public void removeOffloader(Offloader<T> offloader) {
        this.offloader = null;
    }

    @Override
    public void begin() {
        readLock.lock();
    }

    @Override
    public void commit() {
        readLock.unlock();

    }
}
