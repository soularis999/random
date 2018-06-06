package com.test;

public class ThreadPin {


    public static void main(String[] str) throws InterruptedException {
        Runnable runnable = () -> {
            for (int i = 0; ; i++) {
                if(0 == i % 1_000_000) {
                    System.out.println("Still alive - " + Thread.currentThread().getId() + " - " + Thread.currentThread());
                }
            }
        };

        Thread t1 = new Thread(runnable, "test1");
        Thread t2 = new Thread(runnable, "test1");
        t1.start();
        t2.start();


        t2.join();
    }

    public void getAffinity() {

    }
}
