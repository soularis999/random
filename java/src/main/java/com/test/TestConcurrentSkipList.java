package com.test;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentSkipListSet;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.LongAdder;

public class TestConcurrentSkipList {

    int numBuckets = 5;
    int size = 5;

    private final AtomicInteger counter = new AtomicInteger(0);
    private final ConcurrentSkipListSet<Data> set = new ConcurrentSkipListSet<>();
    private final ConcurrentHashMap<Data, Data> map = new ConcurrentHashMap<>();

    private final Data search = new Data();

    public static void main(String[] str) throws InterruptedException, ParseException {
        Date date = new SimpleDateFormat("yyyyMMdd").parse("20170110");
        TestConcurrentSkipList testConcurrentSkipList = new TestConcurrentSkipList(date.getTime());
    }

    private TestConcurrentSkipList(long time) throws InterruptedException, ParseException {
        for (int i = 0; i < 10000; i++) {
            long timestamp = time + ((0 == i % 2) ? 1 : -1) * 2 * i;
            add(timestamp, i);
        }

        System.out.println("-----");
        set.forEach(System.out::println);
        System.out.println("-----");

        long totals = getTotal();

        System.out.println(totals);
        System.out.println("-----");
        map.keySet().forEach(System.out::println);
        System.out.println("-----");
        set.forEach(System.out::println);
        System.out.println("-----");
    }

    private void add(long timestamp, long value) {
        search.bucket = normalize(timestamp);
        Data data = map.get(search);
        if (null != data) {
            data.value.add(value);
            return;
        }

        data = new Data();
        data.bucket = search.bucket;
        data.value.add(value);
        Data temp = map.putIfAbsent(data, data);
        if (null == temp) {

            int count = counter.incrementAndGet();
            set.add(data);

            if (count > numBuckets) {
                data = set.pollFirst();
                if (null != data) {
                    map.remove(data);
                }
                counter.decrementAndGet();
            }
        } else {
            temp.value.add(value);
        }
    }

    /**
     * Round the result to bucket start
     *
     * @param timestamp
     * @return
     */
    private long normalize(long timestamp) {
        long result = timestamp / 1000L; // Normalize to seconds
        return (result / size) * size; // round to start of bucket
    }

    private long getTotal() {
        Iterator<Data> iterator;
        Data data;
        long value = 0;
        long nextBucket = 0;
        long numBucketsProcessed = 0;

        for (iterator = set.descendingIterator(); iterator.hasNext(); ) {
            if (numBucketsProcessed++ == numBuckets) {
                break;
            }

            data = iterator.next();
            if (0 != nextBucket && data.bucket < nextBucket) {
                continue;
            }

            nextBucket = data.bucket - size;
            value += data.value.sum();
        }

        return value;
    }

    public class Data implements Comparable<Data> {
        private volatile long bucket;
        private final LongAdder value = new LongAdder();

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;

            Data data = (Data) o;

            return bucket == data.bucket;
        }

        @Override
        public int hashCode() {
            return (int) (bucket ^ (bucket >>> 32));
        }


        @Override
        public int compareTo(Data o) {
            return Long.compare(bucket, o.bucket);
        }

        @Override
        public String toString() {
            return "Data{" +
                    "bucket=" + bucket +
                    ", value=" + value +
                    '}';
        }
    }

}

