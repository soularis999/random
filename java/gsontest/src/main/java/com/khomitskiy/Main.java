package com.khomitskiy;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.util.Arrays;
import java.util.List;

public class Main {

  public static void main(String[] args) {

    Gson gson = new GsonBuilder().create();

    List<Base> list = Arrays.asList(
        ImmutableC1.builder()
          .prop1(1L)
          .build(),
        ImmutableC2.builder()
          .prop2("TEST")
          .build());

    System.out.println(list);

    System.out.println(gson.toJson(list));

    List<Base> result = gson.fromJson(gson.toJson(list), List.class);
    System.out.println(result);

  }

}
