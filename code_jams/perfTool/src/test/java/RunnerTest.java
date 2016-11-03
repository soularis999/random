import org.junit.Test;
import perfTool.NUM_RUNS_TYPE;
import perfTool.Runner;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import static org.junit.Assert.*;

public class RunnerTest {

    @Test
    public void testPopulation()
    {
        Runner r = new Runner()
                .setNumRuns(10)
                .setNumThreads(10)
                .setRuntype(NUM_RUNS_TYPE.PER_RUN)
                .setSleepTimeMillis(100)
                .setWarmUpNum(15);

        assertEquals("Num runs", 10, r.getNumRuns());
        assertEquals("Num threads", 10, r.getNumThreads());
        assertEquals("run type", NUM_RUNS_TYPE.PER_RUN, r.getRuntype());
        assertEquals("sleep time", 100, r.getSleepTimeMillis());
        assertEquals("warmup time", 15, r.getWarmUpNum());
    }

    @Test(expected = IllegalArgumentException.class)
    public void testZeroNumRuns() {
         Runner r = new Runner()
                .setNumRuns(0);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testNegativeNumRuns() {
         Runner r = new Runner()
                .setNumRuns(-1);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testZeroNumThreads() {
         Runner r = new Runner()
                .setNumThreads(0);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testNegativeNumThreads() {
         Runner r = new Runner()
                .setNumThreads(-1);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testNullRuntype() {
         Runner r = new Runner()
                .setRuntype(null);
    }

    @Test
    public void testZeroSleepTime() {
         Runner r = new Runner()
                .setSleepTimeMillis(0);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testNegativeSleepTime() {
         Runner r = new Runner()
                .setSleepTimeMillis(-1);
    }

    @Test
    public void testZeroWarmupTime() {
         Runner r = new Runner()
                .setWarmUpNum(0);
    }

    @Test(expected = IllegalArgumentException.class)
    public void testNegativeWarmupTime() {
         Runner r = new Runner()
                .setWarmUpNum(-1);
    }

}
