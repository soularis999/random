package com.khomitskiy;

import com.google.gson.*;
import com.google.gson.reflect.*;
import com.google.gson.stream.*;
import java.io.IOException;
import javax.annotation.Generated;

/**
 * A {@code TypeAdapterFactory} that handles all of the immutable types generated under {@code C2}.
 * @see ImmutableC2
 */
@SuppressWarnings({"all", "MethodCanBeStatic"})
@Generated("org.immutables.processor.ProxyProcessor")
@org.immutables.value.Generated(from = "com.khomitskiy", generator = "Gsons")
public final class GsonAdaptersC2 implements TypeAdapterFactory {
  @SuppressWarnings({"unchecked", "raw"}) // safe unchecked, types are verified in runtime
  @Override
  public <T> TypeAdapter<T> create(Gson gson, TypeToken<T> type) {
    if (C2TypeAdapter.adapts(type)) {
      return (TypeAdapter<T>) new C2TypeAdapter(gson);
    }
    return null;
  }

  @Override
  public String toString() {
    return "GsonAdaptersC2(C2)";
  }

  @org.immutables.value.Generated(from = "C2", generator = "Gsons")
  @SuppressWarnings({"unchecked", "raw"}) // safe unchecked, types are verified in runtime
  private static class C2TypeAdapter extends TypeAdapter<C2> {

    C2TypeAdapter(Gson gson) {
    } 

    static boolean adapts(TypeToken<?> type) {
      return C2.class == type.getRawType()
          || ImmutableC2.class == type.getRawType();
    }

    @Override
    public void write(JsonWriter out, C2 value) throws IOException {
      if (value == null) {
        out.nullValue();
      } else {
        writeC2(out, value);
      }
    }

    @Override
    public C2 read(JsonReader in) throws IOException {
      return readC2(in);
    }

    private void writeC2(JsonWriter out, C2 instance)
        throws IOException {
      out.beginObject();
      out.name("prop2");
      out.value(instance.prop2());
      out.endObject();
    }

    private  C2 readC2(JsonReader in)
        throws IOException {
      if (in.peek() == JsonToken.NULL) {
        in.nextNull();
        return null;
      }
      ImmutableC2.Builder builder = ImmutableC2.builder();
      in.beginObject();
      while (in.hasNext()) {
        eachAttribute(in, builder);
      }
      in.endObject();
      return builder.build();
    }

    private void eachAttribute(JsonReader in, ImmutableC2.Builder builder)
        throws IOException {
      String attributeName = in.nextName();
      switch (attributeName.charAt(0)) {
      case 'p':
        if ("prop2".equals(attributeName)) {
          readInProp2(in, builder);
          return;
        }
        break;
      default:
      }
      in.skipValue();
    }

    private void readInProp2(JsonReader in, ImmutableC2.Builder builder)
        throws IOException {
      builder.prop2(in.nextString());
    }
  }
}
