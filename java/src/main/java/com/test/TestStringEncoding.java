package com.test;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;

public class TestStringEncoding {

    public static void main(String[] str) {
        String result = "";
        for (int i = 0; i < 100_000; i++) {
            result += "a";
        }

        printRuntime();
        result.getBytes(StandardCharsets.ISO_8859_1);
        ByteBuffer byteBuffer = StandardCharsets.ISO_8859_1.encode(result);

        printRuntime();
        StandardCharsets.ISO_8859_1.decode(byteBuffer);
    }

    private static void printRuntime() {
        System.gc();
        Runtime.getRuntime().runFinalization();
        System.out.println(String.format("Free: %s, max %s", Runtime.getRuntime().freeMemory(),
                Runtime.getRuntime().maxMemory()));
    }
}
