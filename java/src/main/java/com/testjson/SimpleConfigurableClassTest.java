package com.testjson;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;

import java.io.IOException;
import java.util.Arrays;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.LongAdder;

public class SimpleConfigurableClassTest {

    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class TestClass {

        @JsonProperty
        private final int size;
        @JsonProperty
        private final int[] internal;
        @JsonProperty
        protected int[] internal2;

        @JsonProperty
        @JsonDeserialize(using = LongAdderDeserializer.class)
        private final LongAdder currentBucketValue = new LongAdder();
        @JsonProperty
        private final AtomicLong currentBucketTimestamp = new AtomicLong(0);

        @JsonCreator
        public TestClass(@JsonProperty(value = "size") int size) {
            this.size = size;
            this.internal = new int[size];
            currentBucketValue.increment();
            currentBucketTimestamp.set(1000l);

            internal2 = new int[15];
        }

        public void put(int pos, int val) {
            internal[pos] = val;
        }

        @Override
        public String toString() {
            return "TestClass{" +
                    "size=" + size +
                    ", internal=" + Arrays.toString(internal) +
                    ", internal2=" + Arrays.toString(internal2) +
                    ", currentBucketValue=" + currentBucketValue +
                    ", currentBucketTimestamp=" + currentBucketTimestamp +
                    '}';
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;

            TestClass testClass = (TestClass) o;

            if (size != testClass.size) return false;
            if (!Arrays.equals(internal, testClass.internal)) return false;
            if (currentBucketValue != null ? !currentBucketValue.equals(testClass.currentBucketValue) : testClass.currentBucketValue != null)
                return false;
            return currentBucketTimestamp != null ? currentBucketTimestamp.equals(testClass.currentBucketTimestamp) : testClass.currentBucketTimestamp == null;
        }

        @Override
        public int hashCode() {
            int result = size;
            result = 31 * result + Arrays.hashCode(internal);
            result = 31 * result + (currentBucketValue != null ? currentBucketValue.hashCode() : 0);
            result = 31 * result + (currentBucketTimestamp != null ? currentBucketTimestamp.hashCode() : 0);
            return result;
        }
    }

    public static class LongAdderDeserializer extends StdDeserializer<LongAdder> {

        protected LongAdderDeserializer() {
            super(LongAdder.class);
        }

        @Override
        public LongAdder deserialize(JsonParser p, DeserializationContext ctxt) throws IOException, JsonProcessingException {
            LongAdder longAdder = new LongAdder();
            long val = p.getValueAsLong();
            longAdder.add(val);
            return longAdder;
        }
    }


    public static void main(String[] str) throws IOException {
        new SimpleConfigurableClassTest().run();
    }

    private void run() throws IOException {
        TestClass testClass = new TestClass(10);
        for (int i = 0; i < testClass.internal.length; i++) {
            testClass.put(i, i * i);
        }
        for (int i = 0; i < testClass.internal2.length; i++) {
            testClass.internal2[i] = i;
        }

        print(testClass);

        ObjectMapper objectMapper = new ObjectMapper();
        byte[] result = objectMapper.writeValueAsBytes(testClass);
        print(result);

        objectMapper = new ObjectMapper();
        TestClass testClass1 = objectMapper.readValue(result, TestClass.class);

        print(testClass1);
        assert testClass1.equals(testClass);

        byte[] data = new byte[]{
                123, 34, 115, 105, 122, 101, 34, 58, 49, 48, 44, 34, 105, 110, 116, 101, 114, 110, 97, 108, 34, 58, 91, 48, 44, 49, 44, 52, 44, 57, 44, 49, 54, 44, 50, 53, 44, 51, 54, 44, 52, 57, 44, 54, 52, 44, 56, 49, 93, 44, 34, 105, 110, 116, 101, 114, 110, 97, 108, 50, 34, 58, 91, 48, 44, 49, 44, 50, 44, 51, 44, 52, 44, 53, 44, 54, 44, 55, 44, 56, 44, 57, 44, 49, 48, 44, 49, 49, 44, 49, 50, 44, 49, 51, 44, 49, 52, 44, 49, 53, 44, 49, 54, 44, 49, 55, 44, 49, 56, 44, 49, 57, 93, 44, 34, 99, 117, 114, 114, 101, 110, 116, 66, 117, 99, 107, 101, 116, 86, 97, 108, 117, 101, 34, 58, 49, 44, 34, 99, 117, 114, 114, 101, 110, 116, 66, 117, 99, 107, 101, 116, 84, 105, 109, 101, 115, 116, 97, 109, 112, 34, 58, 49, 48, 48, 48, 125
        };
        print(new String(data));
        objectMapper = new ObjectMapper();
        TestClass testClass2 = objectMapper.readValue(result, TestClass.class);
        print(testClass1);
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
