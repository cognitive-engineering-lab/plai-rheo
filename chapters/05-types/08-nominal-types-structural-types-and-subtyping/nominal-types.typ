#import "/prelude.typ": *

== Nominal Types

The type system in Java is representative of an entire class of languages. These have _nominal_ types, which means the _name_ of a class matters. ("Nominal" comes from the Latin _nomen_, or name.) It's easiest to explain with an example.

Above we have the following class:

```
class mt extends BT {
  public int size() {
    return 0;
  }
}
```

Let's now suppose we create another class that is identical in every respect but its name:

```
class empty extends BT {
  public int size() {
    return 0;
  }
}
```

Let's say we have a method that takes `mt` objects:

```
class Main {
  static int m(mt o) {
    return o.size();
  }
  public static void main(String[] args) {
    System.out.println(m(new mt()));
  }
}
```

But observe that `empty` is a perfectly good substitute for `mt`: it too has a `size` method, which too takes no arguments, and it too returns an `int` (in fact, the very same value). Therefore, we try:

#code(```
class Main {
  static int m(mt o) {
    return o.size();
  }
  public static void main(String[] args) {
    System.out.println(m(new @1|empty|()));
  }
}
```)

But Java rejects this. That's because it expects an object that was constructed by the actual class `mt`, not just one that "looks like" it. That is, what matters is which actual (named) class, not what _structure_ of class, created the value.
