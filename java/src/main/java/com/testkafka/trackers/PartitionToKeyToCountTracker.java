package com.testkafka.trackers;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.LongAdder;

public class PartitionToKeyToCountTracker {

    private static final Map<String, Map<String, LongAdder>> partitionToKeyToCount = new ConcurrentHashMap<>();
    private final boolean out;

    public PartitionToKeyToCountTracker(boolean out) {
        this.out = out;
    }

    public void increment(String partition, String key) {
        Map<String, LongAdder> keyToCount = partitionToKeyToCount.putIfAbsent(partition, new ConcurrentHashMap<>());
        if (null == keyToCount) {
            keyToCount = partitionToKeyToCount.get(partition);
        }

        LongAdder longAdder = keyToCount.putIfAbsent(key, new LongAdder());
        if (null == longAdder) {
            longAdder = keyToCount.get(key);
        }
        longAdder.increment();
    }

    @Override
    public String toString() {
        if (0 == partitionToKeyToCount.size()) {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        partitionToKeyToCount.forEach((key, value) -> {
            sb.append(key).append("{");
            value.forEach((key1, value1) -> sb.append(key1).append(" : ").append(value1).append("\n"))
            ;
        });
        return sb.append("\n").toString();
    }

    public static void print(PartitionToKeyToCountTracker tracker) throws InterruptedException {
        while (true) {
            Thread.currentThread().sleep(1000);
            String trackerVal = tracker.toString();
            if (tracker.out && 0 < trackerVal.trim().length()) {
                System.out.println(tracker);
            }
        }
    }
}
