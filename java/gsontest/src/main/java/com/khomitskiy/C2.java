package com.khomitskiy;


import org.immutables.gson.Gson;
import org.immutables.value.Value;

@Gson.TypeAdapters
@Value.Immutable
public interface C2 extends Base {

  String prop2();
}
