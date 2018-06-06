package com.test;

import java.util.concurrent.TimeUnit;

public class TestThreadGroup {

    public static void main(String[] str) throws InterruptedException {
        ThreadGroup group = new ThreadGroup( "Test group");
        group.setDaemon(true);

        Runnable runnable = () -> {
            for (; ; ) {
                System.out.println("Still alive - " + Thread.currentThread());
                try {
                    TimeUnit.SECONDS.sleep(1);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        };
        Thread t1 = new Thread(group, runnable, "Test thread 1", 0);
        Thread t2 = new Thread(group, runnable, "Test thread 2", 0);

        System.out.println(group);

        t1.start();
        t2.start();
        t2.join();
    }
}
