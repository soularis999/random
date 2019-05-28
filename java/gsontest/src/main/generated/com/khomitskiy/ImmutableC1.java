package com.khomitskiy;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import org.immutables.value.Generated;

/**
 * Immutable implementation of {@link C1}.
 * <p>
 * Use the builder to create immutable instances:
 * {@code ImmutableC1.builder()}.
 */
@Generated(from = "C1", generator = "Immutables")
@SuppressWarnings({"all"})
@javax.annotation.Generated("org.immutables.processor.ProxyProcessor")
public final class ImmutableC1 implements C1 {
  private final long prop1;

  private ImmutableC1(long prop1) {
    this.prop1 = prop1;
  }

  /**
   * @return The value of the {@code prop1} attribute
   */
  @Override
  public long prop1() {
    return prop1;
  }

  /**
   * Copy the current immutable object by setting a value for the {@link C1#prop1() prop1} attribute.
   * A value equality check is used to prevent copying of the same value by returning {@code this}.
   * @param value A new value for prop1
   * @return A modified copy of the {@code this} object
   */
  public final ImmutableC1 withProp1(long value) {
    if (this.prop1 == value) return this;
    return new ImmutableC1(value);
  }

  /**
   * This instance is equal to all instances of {@code ImmutableC1} that have equal attribute values.
   * @return {@code true} if {@code this} is equal to {@code another} instance
   */
  @Override
  public boolean equals(Object another) {
    if (this == another) return true;
    return another instanceof ImmutableC1
        && equalTo((ImmutableC1) another);
  }

  private boolean equalTo(ImmutableC1 another) {
    return prop1 == another.prop1;
  }

  /**
   * Computes a hash code from attributes: {@code prop1}.
   * @return hashCode value
   */
  @Override
  public int hashCode() {
    int h = 5381;
    h += (h << 5) + Long.hashCode(prop1);
    return h;
  }

  /**
   * Prints the immutable value {@code C1} with attribute values.
   * @return A string representation of the value
   */
  @Override
  public String toString() {
    return "C1{"
        + "prop1=" + prop1
        + "}";
  }

  /**
   * Creates an immutable copy of a {@link C1} value.
   * Uses accessors to get values to initialize the new immutable instance.
   * If an instance is already immutable, it is returned as is.
   * @param instance The instance to copy
   * @return A copied immutable C1 instance
   */
  public static ImmutableC1 copyOf(C1 instance) {
    if (instance instanceof ImmutableC1) {
      return (ImmutableC1) instance;
    }
    return ImmutableC1.builder()
        .from(instance)
        .build();
  }

  /**
   * Creates a builder for {@link ImmutableC1 ImmutableC1}.
   * <pre>
   * ImmutableC1.builder()
   *    .prop1(long) // required {@link C1#prop1() prop1}
   *    .build();
   * </pre>
   * @return A new ImmutableC1 builder
   */
  public static ImmutableC1.Builder builder() {
    return new ImmutableC1.Builder();
  }

  /**
   * Builds instances of type {@link ImmutableC1 ImmutableC1}.
   * Initialize attributes and then invoke the {@link #build()} method to create an
   * immutable instance.
   * <p><em>{@code Builder} is not thread-safe and generally should not be stored in a field or collection,
   * but instead used immediately to create instances.</em>
   */
  @Generated(from = "C1", generator = "Immutables")
  public static final class Builder {
    private static final long INIT_BIT_PROP1 = 0x1L;
    private long initBits = 0x1L;

    private long prop1;

    private Builder() {
    }

    /**
     * Fill a builder with attribute values from the provided {@code C1} instance.
     * Regular attribute values will be replaced with those from the given instance.
     * Absent optional values will not replace present values.
     * @param instance The instance from which to copy values
     * @return {@code this} builder for use in a chained invocation
     */
    public final Builder from(C1 instance) {
      Objects.requireNonNull(instance, "instance");
      prop1(instance.prop1());
      return this;
    }

    /**
     * Initializes the value for the {@link C1#prop1() prop1} attribute.
     * @param prop1 The value for prop1 
     * @return {@code this} builder for use in a chained invocation
     */
    public final Builder prop1(long prop1) {
      this.prop1 = prop1;
      initBits &= ~INIT_BIT_PROP1;
      return this;
    }

    /**
     * Builds a new {@link ImmutableC1 ImmutableC1}.
     * @return An immutable instance of C1
     * @throws java.lang.IllegalStateException if any required attributes are missing
     */
    public ImmutableC1 build() {
      if (initBits != 0) {
        throw new IllegalStateException(formatRequiredAttributesMessage());
      }
      return new ImmutableC1(prop1);
    }

    private String formatRequiredAttributesMessage() {
      List<String> attributes = new ArrayList<>();
      if ((initBits & INIT_BIT_PROP1) != 0) attributes.add("prop1");
      return "Cannot build C1, some of required attributes are not set " + attributes;
    }
  }
}
