package com.khomitskiy;

import com.google.gson.*;
import com.google.gson.reflect.*;
import com.google.gson.stream.*;
import java.io.IOException;
import javax.annotation.Generated;

/**
 * A {@code TypeAdapterFactory} that handles all of the immutable types generated under {@code C1}.
 * @see ImmutableC1
 */
@SuppressWarnings({"all", "MethodCanBeStatic"})
@Generated("org.immutables.processor.ProxyProcessor")
@org.immutables.value.Generated(from = "com.khomitskiy", generator = "Gsons")
public final class GsonAdaptersC1 implements TypeAdapterFactory {
  @SuppressWarnings({"unchecked", "raw"}) // safe unchecked, types are verified in runtime
  @Override
  public <T> TypeAdapter<T> create(Gson gson, TypeToken<T> type) {
    if (C1TypeAdapter.adapts(type)) {
      return (TypeAdapter<T>) new C1TypeAdapter(gson);
    }
    return null;
  }

  @Override
  public String toString() {
    return "GsonAdaptersC1(C1)";
  }

  @org.immutables.value.Generated(from = "C1", generator = "Gsons")
  @SuppressWarnings({"unchecked", "raw"}) // safe unchecked, types are verified in runtime
  private static class C1TypeAdapter extends TypeAdapter<C1> {

    C1TypeAdapter(Gson gson) {
    } 

    static boolean adapts(TypeToken<?> type) {
      return C1.class == type.getRawType()
          || ImmutableC1.class == type.getRawType();
    }

    @Override
    public void write(JsonWriter out, C1 value) throws IOException {
      if (value == null) {
        out.nullValue();
      } else {
        writeC1(out, value);
      }
    }

    @Override
    public C1 read(JsonReader in) throws IOException {
      return readC1(in);
    }

    private void writeC1(JsonWriter out, C1 instance)
        throws IOException {
      out.beginObject();
      out.name("prop1");
      out.value(instance.prop1());
      out.endObject();
    }

    private  C1 readC1(JsonReader in)
        throws IOException {
      if (in.peek() == JsonToken.NULL) {
        in.nextNull();
        return null;
      }
      ImmutableC1.Builder builder = ImmutableC1.builder();
      in.beginObject();
      while (in.hasNext()) {
        eachAttribute(in, builder);
      }
      in.endObject();
      return builder.build();
    }

    private void eachAttribute(JsonReader in, ImmutableC1.Builder builder)
        throws IOException {
      String attributeName = in.nextName();
      switch (attributeName.charAt(0)) {
      case 'p':
        if ("prop1".equals(attributeName)) {
          readInProp1(in, builder);
          return;
        }
        break;
      default:
      }
      in.skipValue();
    }

    private void readInProp1(JsonReader in, ImmutableC1.Builder builder)
        throws IOException {
      builder.prop1(in.nextLong());
    }
  }
}
