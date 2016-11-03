package perfTool;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.CountDownLatch;

public final class Runner {

    private final Object LOCK = new Object();

    private RunnerAttr attr;
    private final List<RunnerThread> threads = new ArrayList<RunnerThread>();

    private enum FIELD_TYPE {
        NUM_THREADS,
        NUM_RUNS,
        NUM_WARMUP,
        RUN_TYPE,
        SLEEP_TIME;
    };

    public Runner()
    {
        this.attr = new RunnerAttr();
    }

    public Runner setNumThreads(int numThreads)
    {
        if(numThreads < 1) {
            throw new IllegalArgumentException("Number of threads should be greater than 0");
        }

        replaceAttr(FIELD_TYPE.NUM_THREADS, numThreads);
        return this;
    }

    public int getNumThreads()
    {
        return this.attr.getNumThreads();
    }

    public Runner setNumRuns(int numRuns)
    {
        if(numRuns < 1) {
            throw new IllegalArgumentException("Number of runs should be greater than 0");
        }

        replaceAttr(FIELD_TYPE.NUM_RUNS, numRuns);
        return this;
    }

    public int getNumRuns()
    {
        return this.attr.getNumRuns();
    }

    public Runner setWarmUpNum(int warmUpNum)
    {
        if(warmUpNum < 0) {
            throw new IllegalArgumentException("Number of warmup runs should be greater than or equals to 0");
        }

        replaceAttr(FIELD_TYPE.NUM_WARMUP, warmUpNum);
        return this;
    }

    public int getWarmUpNum()
    {
        return this.attr.getWarmUpNum();
    }

    public Runner setRuntype(NUM_RUNS_TYPE runtype)
    {
        if(null == runtype) {
            throw new IllegalArgumentException("Run type was not provided");
        }

        replaceAttr(FIELD_TYPE.RUN_TYPE, runtype);
        return this;
    }

    public NUM_RUNS_TYPE getRuntype()
    {
        return this.attr.getRuntype();
    }

    public Runner setSleepTimeMillis(long sleepTimeMillis)
    {
        if(sleepTimeMillis < 0) {
            throw new IllegalArgumentException("Number of millis to sleep between runs should be greater than or equals to 0");
        }

        replaceAttr(FIELD_TYPE.SLEEP_TIME, sleepTimeMillis);
        return this;
    }

    public long getSleepTimeMillis()
    {
        return this.attr.getSleepTimeMillis();
    }

    /********************* run method **********************************/
    public void run(Runnable item)
    {
        this.clearThreadList();

        int numThreads = this.attr.getNumThreads();

        CountDownLatch startLatch = new CountDownLatch(1);
        CountDownLatch endLatch = new CountDownLatch(numThreads);

        for(int i = 0; i < numThreads; i++)
        {
            RunnerThread th = new RunnerThread(startLatch, endLatch, this.attr, item);
            th.start();
            this.threads.add(th);
        }

        startLatch.countDown();
        try
        {
            endLatch.await();
        }
        catch (InterruptedException e)
        {
            e.printStackTrace();
        }
    }

    /***************** private methods **************************/
    private void clearThreadList()
    {
        for(RunnerThread th : this.threads)
        {
            th.stopThread();
        }

        this.threads.clear();
    }

    private void replaceAttr(FIELD_TYPE type, Object field)
    {
        synchronized (LOCK)
        {
            int numThreads = FIELD_TYPE.NUM_THREADS == type ? ((Integer) field).intValue() : this.attr.getNumThreads();
            int numRuns = FIELD_TYPE.NUM_RUNS == type ? ((Integer) field).intValue() : this.attr.getNumRuns();
            int warmup = FIELD_TYPE.NUM_WARMUP == type ? ((Integer) field).intValue() : this.attr.getWarmUpNum();
            NUM_RUNS_TYPE runtype = FIELD_TYPE.RUN_TYPE == type ? (NUM_RUNS_TYPE) field : this.attr.getRuntype();
            long sleeptime = FIELD_TYPE.SLEEP_TIME == type ? ((Long) field).longValue() : this.attr.getSleepTimeMillis();

            this.attr = new RunnerAttr(numThreads, numRuns, warmup, runtype, sleeptime);
        }
    }
}
