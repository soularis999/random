package com.khomitskiy;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import org.immutables.value.Generated;

/**
 * Immutable implementation of {@link C2}.
 * <p>
 * Use the builder to create immutable instances:
 * {@code ImmutableC2.builder()}.
 */
@Generated(from = "C2", generator = "Immutables")
@SuppressWarnings({"all"})
@javax.annotation.Generated("org.immutables.processor.ProxyProcessor")
public final class ImmutableC2 implements C2 {
  private final String prop2;

  private ImmutableC2(String prop2) {
    this.prop2 = prop2;
  }

  /**
   * @return The value of the {@code prop2} attribute
   */
  @Override
  public String prop2() {
    return prop2;
  }

  /**
   * Copy the current immutable object by setting a value for the {@link C2#prop2() prop2} attribute.
   * An equals check used to prevent copying of the same value by returning {@code this}.
   * @param value A new value for prop2
   * @return A modified copy of the {@code this} object
   */
  public final ImmutableC2 withProp2(String value) {
    String newValue = Objects.requireNonNull(value, "prop2");
    if (this.prop2.equals(newValue)) return this;
    return new ImmutableC2(newValue);
  }

  /**
   * This instance is equal to all instances of {@code ImmutableC2} that have equal attribute values.
   * @return {@code true} if {@code this} is equal to {@code another} instance
   */
  @Override
  public boolean equals(Object another) {
    if (this == another) return true;
    return another instanceof ImmutableC2
        && equalTo((ImmutableC2) another);
  }

  private boolean equalTo(ImmutableC2 another) {
    return prop2.equals(another.prop2);
  }

  /**
   * Computes a hash code from attributes: {@code prop2}.
   * @return hashCode value
   */
  @Override
  public int hashCode() {
    int h = 5381;
    h += (h << 5) + prop2.hashCode();
    return h;
  }

  /**
   * Prints the immutable value {@code C2} with attribute values.
   * @return A string representation of the value
   */
  @Override
  public String toString() {
    return "C2{"
        + "prop2=" + prop2
        + "}";
  }

  /**
   * Creates an immutable copy of a {@link C2} value.
   * Uses accessors to get values to initialize the new immutable instance.
   * If an instance is already immutable, it is returned as is.
   * @param instance The instance to copy
   * @return A copied immutable C2 instance
   */
  public static ImmutableC2 copyOf(C2 instance) {
    if (instance instanceof ImmutableC2) {
      return (ImmutableC2) instance;
    }
    return ImmutableC2.builder()
        .from(instance)
        .build();
  }

  /**
   * Creates a builder for {@link ImmutableC2 ImmutableC2}.
   * <pre>
   * ImmutableC2.builder()
   *    .prop2(String) // required {@link C2#prop2() prop2}
   *    .build();
   * </pre>
   * @return A new ImmutableC2 builder
   */
  public static ImmutableC2.Builder builder() {
    return new ImmutableC2.Builder();
  }

  /**
   * Builds instances of type {@link ImmutableC2 ImmutableC2}.
   * Initialize attributes and then invoke the {@link #build()} method to create an
   * immutable instance.
   * <p><em>{@code Builder} is not thread-safe and generally should not be stored in a field or collection,
   * but instead used immediately to create instances.</em>
   */
  @Generated(from = "C2", generator = "Immutables")
  public static final class Builder {
    private static final long INIT_BIT_PROP2 = 0x1L;
    private long initBits = 0x1L;

    private String prop2;

    private Builder() {
    }

    /**
     * Fill a builder with attribute values from the provided {@code C2} instance.
     * Regular attribute values will be replaced with those from the given instance.
     * Absent optional values will not replace present values.
     * @param instance The instance from which to copy values
     * @return {@code this} builder for use in a chained invocation
     */
    public final Builder from(C2 instance) {
      Objects.requireNonNull(instance, "instance");
      prop2(instance.prop2());
      return this;
    }

    /**
     * Initializes the value for the {@link C2#prop2() prop2} attribute.
     * @param prop2 The value for prop2 
     * @return {@code this} builder for use in a chained invocation
     */
    public final Builder prop2(String prop2) {
      this.prop2 = Objects.requireNonNull(prop2, "prop2");
      initBits &= ~INIT_BIT_PROP2;
      return this;
    }

    /**
     * Builds a new {@link ImmutableC2 ImmutableC2}.
     * @return An immutable instance of C2
     * @throws java.lang.IllegalStateException if any required attributes are missing
     */
    public ImmutableC2 build() {
      if (initBits != 0) {
        throw new IllegalStateException(formatRequiredAttributesMessage());
      }
      return new ImmutableC2(prop2);
    }

    private String formatRequiredAttributesMessage() {
      List<String> attributes = new ArrayList<>();
      if ((initBits & INIT_BIT_PROP2) != 0) attributes.add("prop2");
      return "Cannot build C2, some of required attributes are not set " + attributes;
    }
  }
}
