package com.testjson;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.Arrays;

public class NestedClassTest {

    private static int size1 = 10;
    private static int size2 = 20;

    public static class Inner {
        @JsonProperty
        private final int size;
        @JsonProperty
        private final int[] data;

        @JsonCreator
        public Inner(@JsonProperty(value = "size") final int size) {
            this.size = size;
            this.data = new int[size];
        }

        @Override
        public String toString() {
            return "Inner{" +
                    "size=" + size +
                    ", data=" + Arrays.toString(data) +
                    '}';
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;

            Inner inner = (Inner) o;

            if (size != inner.size) return false;
            return Arrays.equals(data, inner.data);
        }

        @Override
        public int hashCode() {
            int result = size;
            result = 31 * result + Arrays.hashCode(data);
            return result;
        }
    }

    public static class Outer {
        @JsonProperty
        private final Inner inner1;
        @JsonProperty
        private final Inner inner2;

        public Outer() {
            inner1 = new Inner(size1);
            inner2 = new Inner(size2);
        }

        @Override
        public String toString() {
            return "Outer{" +
                    "inner1=" + inner1 +
                    ", inner2=" + inner2 +
                    '}';
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;

            Outer outer = (Outer) o;

            if (inner1 != null ? !inner1.equals(outer.inner1) : outer.inner1 != null) return false;
            return inner2 != null ? inner2.equals(outer.inner2) : outer.inner2 == null;
        }

        @Override
        public int hashCode() {
            int result = inner1 != null ? inner1.hashCode() : 0;
            result = 31 * result + (inner2 != null ? inner2.hashCode() : 0);
            return result;
        }
    }

    public static void main(String[] str) throws IOException {
        new NestedClassTest().start();
    }

    private void start() throws IOException {
        size1 = 10;
        size2 = 20;
        Outer outer = make();

        print(outer);

        ObjectMapper objectMapper = new ObjectMapper();
        byte[] data = objectMapper.writeValueAsBytes(outer);
        print(data);

        objectMapper = new ObjectMapper();

        size1 = 5;
        size2 = 10;
        Outer outer1 = objectMapper.readValue(data, Outer.class);
        print(outer1);

        assert outer1.equals(outer);

    }

    private Outer make() {
        Outer outer = new Outer();
        for (int i = 0; i < outer.inner1.data.length; i++) {
            outer.inner1.data[i] = i;
        }
        for (int i = 0; i < outer.inner2.data.length; i++) {
            outer.inner2.data[i] = i;
        }
        return outer;
    }


    private static void print(Object o) {
        if (o instanceof byte[]) {
            for (byte b : (byte[]) o) {
                System.out.print(b + ",");
            }
            System.out.println();
        } else {
            System.out.println(String.valueOf(o));
        }
    }
}
