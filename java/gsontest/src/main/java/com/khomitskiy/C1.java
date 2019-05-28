package com.khomitskiy;

import org.immutables.gson.Gson;
import org.immutables.value.Value;

@Gson.TypeAdapters
@Value.Immutable
public interface C1 extends Base {

  long prop1();
}
