package perfTool;

final class RunnerAttr
{
    private final int numThreads;
    private final int numRuns;
    private final int warmUpNum;
    private final NUM_RUNS_TYPE runtype;
    private final long sleepTimeMillis;

    public RunnerAttr()
    {
        this(
            Runtime.getRuntime().availableProcessors(),
            10000,
            1000,
            NUM_RUNS_TYPE.PER_THREAD,
            1
        );
    }

    public RunnerAttr(
            int numThreads,
            int numRuns,
            int warmUpNum,
            NUM_RUNS_TYPE runtype,
            long sleepTimeMillis)
    {
        this.numThreads = numThreads;
        this.numRuns = numRuns;
        this.warmUpNum = warmUpNum;
        this.runtype = runtype;
        this.sleepTimeMillis = sleepTimeMillis;
    }

    public int getNumThreads() {
        return numThreads;
    }

    public int getNumRuns()
    {
        return NUM_RUNS_TYPE.PER_THREAD == this.getRuntype()
                ? this.getNumRuns()
                : this.getNumRuns() / this.getNumThreads();
    }

    public int getWarmUpNum() {
        return warmUpNum;
    }

    public NUM_RUNS_TYPE getRuntype() {
        return runtype;
    }

    public long getSleepTimeMillis() {
        return sleepTimeMillis;
    }
}
