package com.testkafka.offload;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.concurrent.*;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public class ScheduledOffloadProcessingManager<T> extends AbstractOffloadProcessingManager<T> {

    private static final Logger logger = LoggerFactory.getLogger(ScheduledOffloadProcessingManager.class);

    private final ScheduledExecutorService service;
    private final TimeUnit intervalUnits;
    private final long interval;

    private ScheduledFuture<?> future;

    public ScheduledOffloadProcessingManager(long interval, TimeUnit intervalUnits) {
        this(interval, intervalUnits, Executors.newSingleThreadScheduledExecutor(r -> {
            Thread thread = new Thread(r);
            thread.setName("Offload thread");
            thread.setDaemon(true);
            return thread;
        }));
    }

    public ScheduledOffloadProcessingManager(long interval, TimeUnit intervalUnits, ScheduledExecutorService service) {
        this(interval, intervalUnits, service, new ReentrantReadWriteLock(true));
    }

    public ScheduledOffloadProcessingManager(long interval, TimeUnit intervalUnits, ScheduledExecutorService service,
                                             ReadWriteLock lock) {
        super(lock);
        this.interval = interval;
        this.intervalUnits = intervalUnits;
        this.service = service;
    }

    @Override
    protected boolean registerJob(final Runnable runnable) {
        if (null != future && !future.isCancelled()) {
            return false;
        }

        try {
            future = this.service.scheduleWithFixedDelay(runnable, interval, interval, intervalUnits);
        } catch (RejectedExecutionException e) {
            return false;
        }

        return true;
    }

    @Override
    public void close() throws IOException {
        try {
            this.service.shutdown();
            this.service.awaitTermination(1, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            // no - op
            logger.warn("Error closing manager. Will continue shutting down.", e);
        } finally {
            if (!this.service.isShutdown()) {
                this.service.shutdownNow();
            }
        }
    }
}
