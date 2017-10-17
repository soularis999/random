package com.test;

import java.util.*;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.IntBinaryOperator;
import java.util.function.Predicate;

import static java.lang.Math.sqrt;

public class OverallJava8StuffTest {

    public interface Person {
        abstract int getAge();

        default int calculateAge(int age) {
            return getAge() - 10;
        }
    }

    @FunctionalInterface
    public interface Calculator {
        int sum(int first, int second);
    }

    // http://winterbe.com/posts/2014/03/16/java-8-tutorial/
    public static void main(String[] data) {
        // defaults
        Person p = new Person() {
            @Override
            public int getAge() {
                return 20;
            }
        };

        System.out.println("Has to be 10 = " + p.calculateAge(5));

        // lambdas
        List<String> list = Arrays.asList("bob", "ben", "bill");
        list.sort((String first, String second) -> {
            return first.compareTo(second);
        });

        System.out.println("Has to be ben,bill,bob = " + String.join(",", list));

        Calculator c = (first, second) -> first + second;
        // functional lambdas
        System.out.println("Has to be 20 = " + c.sum(15, 5));

        // scopes
        int outer = 100;
        c = (first, second) -> first + second + outer;
        System.out.println("Has to be 120 = " + c.sum(15, 5));

        // defaults
        c = (first, second) -> (int) sqrt(first + second);
        System.out.println("Has to be 5 = " + c.sum(20, 5));

        // build ins
        IntBinaryOperator compare = Integer::compare;
        System.out.println("Has to be 1 = " + compare.applyAsInt(10, 5));

        // Optionals
        Optional<String> optional = Optional.ofNullable(null);

        System.out.println("Has to be false = " + optional.isPresent());
//        System.out.println("Has to be null = " + optional.get());
        System.out.println("Has to be test = " + optional.orElse("fallback"));

        Predicate<Optional<String>> predicate = Optional::isPresent;
        System.out.println("Has to be test none  = ");
        optional.ifPresent(System.out::println);

        System.out.println("Has to be test true  = " + predicate.negate());

        // streams
        List<String> stringCollection = new ArrayList<>();
        stringCollection.add("ddd2");
        stringCollection.add("aaa2");
        stringCollection.add("bbb1");
        stringCollection.add("aaa1");
        stringCollection.add("bbb3");
        stringCollection.add("ccc");
        stringCollection.add("bbb2");
        stringCollection.add("ddd1");


        stringCollection.stream().filter((s) -> s.startsWith("b")).forEach(System.out::println);

    }
}
