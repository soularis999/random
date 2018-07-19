package com.test;

import java.time.Duration;

class PinTest {

    public static void main(String[] str) {
        PinTest instance = new PinTest();

        new Thread(() -> {
            try {
                instance.calc((byte) 4);
            } catch (UnsatisfiedLinkError e) {
                e.printStackTrace();
            }
        }, "Non Daemon").start();

        Thread dt = new Thread(() -> {
            try {
                instance.calc((byte) 8);
            } catch (UnsatisfiedLinkError e) {
                e.printStackTrace();
            }
        }, "Daemon");
        dt.setDaemon(true);
        dt.start();
    }

    private void calc(byte pinbyte) {
        Pin pin = new Pin();
        Pin.CpuSetT setT = pin.getAffinity();
        for (int i = 0; i < 8; i++) {
            System.out.println(Thread.currentThread().getName() + "::byte" + i + " - " + setT.get(i));
        }

        setT.clear();
        setT.set(0, pinbyte);
        pin.setAffinity(setT);

        System.out.println("====================");

        setT = pin.getAffinity();
        for (int i = 0; i < 8; i++) {
            System.out.println(Thread.currentThread().getName() + "::byte" + i + " - " + setT.get(i));
        }

        double total = 0;
        long time = Duration.ofMillis(System.currentTimeMillis()).plusSeconds(100).toMillis();
        while (System.currentTimeMillis() < time) {
            double val = Math.sqrt(Math.random());
            total += val * val;
        }

        System.out.println("==================== - " + total);

        setT = pin.getAffinity();
        for (int i = 0; i < 8; i++) {
            System.out.println(Thread.currentThread().getName() + "::byte" + i + " - " + setT.get(i));
        }
    }
}
