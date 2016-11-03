package perfTool;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

public final class Stats
{
    private final String name;
    private final List<Long> time;

    private double mean = 0;
    private double var = 0;
    private double stdev = 0;
    private long min = 0;
    private long max = 0;

    public Stats(String name)
    {
        this.name = name;
        this.time = new LinkedList<Long>();
    }

    public synchronized void addRun(long time)
    {
        if(time < 0) {
            throw new IllegalArgumentException("time cannot be less that 0");
        }

        this.time.add(time);
    }

    public synchronized void calculateStats()
    {
        if(0 == this.time.size()) {
            this.mean = 0;
            this.var = 0;
            this.stdev = 0;
            this.min = 0;
            this.max = 0;
        }

        Collections.sort(this.time);

        this.min = this.time.get(0);
        this.max = this.time.get(this.time.size() - 1);

        long tmpMean = 0;
        for(Long l : this.time) {
            tmpMean += l;
        }
        this.mean = tmpMean / this.time.size();

        double tmpVar = 0;
        double tmpSkew = 0;
        for(Long l : this.time) {
            tmpVar += (l - this.mean) * (l - this.mean);
        }
        this.var = tmpVar / this.time.size();
        this.stdev = Math.sqrt(this.var);
    }

    public String getName() {
        return name;
    }

    public double getMean() {
        return mean;
    }

    public double getVar() {
        return var;
    }

    public double getStdev() {
        return stdev;
    }

    public long getMin() {
        return min;
    }

    public long getMax() {
        return max;
    }
}
