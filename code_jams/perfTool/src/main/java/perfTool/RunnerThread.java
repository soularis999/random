package perfTool;

import java.util.concurrent.CountDownLatch;

class RunnerThread extends Thread
{
    boolean isStopped = true;
    private final CountDownLatch startLatch;
    private final CountDownLatch stopLatch;
    private final RunnerAttr attr;
    private final Runnable item;
    private final Stats stats;

    public RunnerThread(
            CountDownLatch startLatch,
            CountDownLatch stopLatch,
            RunnerAttr attr,
            Runnable item)
    {
        this.startLatch = startLatch;
        this.stopLatch = stopLatch;
        this.attr = attr;
        this.item = item;
        this.stats = new Stats(this.getName());
    }

    public void run()
    {
        this.isStopped = false;

        try
        {
            this.startLatch.await();
        }
        catch (InterruptedException e)
        {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            stopThread();
            return;
        }

        for(int i = 0; i < this.attr.getNumRuns(); i++)
        {
            long time = System.currentTimeMillis();
            this.item.run();

            if(i > this.attr.getWarmUpNum())
            {
                this.stats.addRun(System.currentTimeMillis() - time);
            }

            try
            {
                Thread.sleep(this.attr.getSleepTimeMillis());
            }
            catch (InterruptedException e)
            {
                e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
            }

            if(this.isStopped) {
                break;
            }
        }

        this.stopLatch.countDown();
        this.stopThread();
    }

    public void stopThread()
    {
        this.isStopped = true;
        this.interrupt();
    }
}
