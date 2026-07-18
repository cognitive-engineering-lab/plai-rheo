#import "/prelude.typ": *

== Algebraic Datatypes Encoded With Nominal Types

We'll take a different approach. Observe from the datatype definition that we have two constructors, and one type that represents their union. We can encode this in Java as:

```
abstract class BT {
  abstract public int size();
}

class mt extends BT {
  public int size() {
    return 0;
  }
}

class node extends BT {
  int v;
  BT l, r;
  node(int v, BT l, BT r) {
    this.v = v;
    this.l = l;
    this.r = r;
  }
  public int size() {
    return 1 + this.l.size() + this.r.size();
  }
}

class Main {
  public static void main(String[] args) {
    BT t = new node(5, new node(3, new mt(), new mt()), new mt());
    System.out.println(t.size());
  }
}
```

How is the "if-splitting" addressed here? It's done in a hidden way, through dynamic dispatch. When we invoke a method, Java makes sure we run the right method: there are actually two concrete `size` methods, and the run-time picks the right one. Once that choice is made, the class in which the method resides automatically determines what is bound. Thus, the `size` in `node` can safely use `this.l` and `this.r`, and the type-checker knows that those fields exist.

This is, then, similar to, yet different from, our two prior solutions: using algebraic datatypes and union types. The solutions are structurally different, but they are all similar in that some _syntactic_ pattern must be used to make the program statically type-able. With algebraic datatypes, it was pattern-matching; with union types, it was if-splitting; in Java, it's the splitting of the code into separate methods.

The algebraic datatype and Java solutions are even more connected than we might imagine. With algebraic datatypes, we fixed the set of variants; but we were free to add new functions _without having to edit existing code_. In Java, we fix the set of behaviors (above, one method), but can add new variants without having to edit existing code. Therefore, neither has an inherent advantage over the other, and one's strengths are the other's weakness. How to do _both_ at once is the essence of the #link("https://en.wikipedia.org/wiki/Expression_problem")[Expression Problem]. See also the concrete examples and approaches given in these two papers, one focusing on a #link("https://cs.brown.edu/~sk/Publications/Papers/Published/kff-synth-fp-oo/")[Java-based approach] and another #link("https://cs.brown.edu/~sk/Publications/Papers/Published/kf-ext-sw-def/")[function-centric].
