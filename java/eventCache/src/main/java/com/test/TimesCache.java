package com.test;

import java.time.ZonedDateTime;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.stream.Collectors;

public class TimesCache {

  private final Map<Class<?>, Holder<?>> holders;

  public TimesCache(Set<Item<?>> data) {
    holders = data.stream().collect(Collectors.toMap(item -> item.clazz,
        (Object t) -> new Holder(clazz, expirationFunction, expiration, expirationUnits)));
  }

  public void add(Object o) {
    final Class<?> tClass = o.getClass();
    final Holder<?> holder = holders.get(tClass);
    Objects.requireNonNull(holder, "Time check is not setup for class " + o.getClass());
    holder.save(o);
  }

  public boolean isReady() {
    return holders.values().stream().map(h -> h.data).anyMatch(Objects::nonNull);
  }

  public Object get(Class<?> clazz) {
    return holders.get(clazz);
  }

  // Bilder and getter
  private static class Holder<T> {

    private final Class<T> clazz;
    private final Function<T, ZonedDateTime> expirationFunction;
    private final long expiration;
    private final TimeUnit expirationUnits;

    private T data;

    Holder(Class<T> clazz) {
      this.clazz = clazz;

    }

    Holder(Class<T> clazz, Function<T, ZonedDateTime> expirationFunction, long expiration,
        TimeUnit expirationUnits) {
      this.clazz = clazz;
      this.expirationFunction = expirationFunction;
      this.expiration = expiration;
      this.expirationUnits = expirationUnits;
    }

    void save(final Object o) {
      this.data = clazz.cast(o);
    }
  }
}
