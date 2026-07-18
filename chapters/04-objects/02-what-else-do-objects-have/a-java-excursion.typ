#import "/prelude.typ": *

== A Java Excursion

Let's first understand what's going on in Java. For simplicity, let's use a canonical "2d point" and "3d point" example. We'll start with this class:

```
class Pt2 {
    Pt2(int x, int y) {
        System.out.println("Pt2 with " + x + " and " + y);
    }
}
```

We can make instances of it easily enough:

```
class Main {
    public static void main(String[] args) {
        Pt2 p2 = new Pt2(1, 2);
    }
}
```

and this prints the expected output. Now suppose we extend this class:

```
class Pt3 extends Pt2 {
    Pt3(int x, int y, int z) {
        System.out.println("Pt3 with " + z);
    }
}
```

_This won't even compile_. We will get a somewhat strange-looking error. The error is because Java is expecting to make an instance of `Pt2` as well, but we have not told it how to. In the absence of anything else, it invokes a "default constructor", which takes _no_ parameters (because Java has no way of knowing which parameters to pass). If we modify `Pt2` to instead be

```
class Pt2 {
   Pt2() {
       System.out.println("default constructor");
   }
    Pt2(int x, int y) {
        System.out.println("Pt2 with " + x + " and " + y);
    }
}
```

then we find that the program compiles and, if we change `Main` suitably,

```
class Main {
  public static void main(String[] args) {
    Pt3 p3 = new Pt3(1, 2, 3);
  }
}
```

it runs, but perhaps without the effect we were expecting. The solution, in Java terms, is to explicitly invoke the constructor of the super-class:

```
class Pt3 extends Pt2 {
    Pt3(int x, int y, int z) {
        System.out.println("Pt3 with " + z);
        super(x, y);
    }
}
```

but this won't work either: Java expects the `super` invocation to be the _first_ thing in the sub-class's constructor.

As the error message above reveals, hidden in the constructor of the extended class is lurking something important: it tries to _create an instance_ of the super-class, just as if we had written `new Pt2`. This is entirely masked by the syntactic sugar of `super`. The actual `Pt2` instance is hidden out of sight, and it takes a little effort to coax it into view.

To see it, let's first add some instance variables:

```
class Pt2 {
    public int x;
    Pt2(int x, int y) {
        this.x = x - 3;
        System.out.println("Pt2 with " + x + " and " + y);
    }
}

class Pt3 extends Pt2 {
    public int x;
    Pt3(int x, int y, int z) {
        super(x, y);
        this.x = x + 7;
        System.out.println("Pt3 with " + z);
    }
}
```

We've purposely made the instance variables have values that look different from those of the parameters, so that when we try to examine them, we can tell them apart. Now let's modify the constructor to make two objects:

```
class Main {
    public static void main(String[] args) {
        Pt3 p3345 = new Pt3(3, 4, 5);
        Pt3 p3678 = new Pt3(6, 7, 8);
    }
}
```

_Two_ objects…how many objects did we really make? Well, we made _at least_ two, because adding

```
        System.out.println(p3345.x);
        System.out.println(p3678.x);
```

to the constructor shows that there are two different objects with two different values for `x`. So far, so unsurprising.

However, I've claimed that there are two more objects, of type `Pt2`. Can we _see_ them? Yes, in fact, we can. The problem is that they're of type `Pt2`, and what we have are `Pt3` objects. We can't just make a `Pt2`, because that doesn't reveal the _hidden_ `Pt2`. But in fact the Java type system lets us get to the `Pt2` by _casting_:

```
        System.out.println(((Pt2)p3345).x);
        System.out.println(((Pt2)p3678).x);
```

And that's how we can see that there are actually two `Pt2` objects lurking as well!
