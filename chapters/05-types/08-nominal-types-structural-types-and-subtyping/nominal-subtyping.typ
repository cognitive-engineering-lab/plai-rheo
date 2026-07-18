#import "/prelude.typ": *

== Nominal Subtyping

We've been writing a bit gingerly about Java above: because we know that the `m` method will accept not only `mt`'s but also anything that is a sub-class of `mt`. Let's explore this further.

To simplify things, let's make some basic classes:

```
class A { String who = "A"; }
class B extends A { String who = "B"; }
class C extends A { String who = "C"; }
class D { String who = "D"; }
```

We'll also create a shell "runner":

```
class Main {
 public static void main(String[] args) {
   System.out.println((true ? _____ : _____).who);
 }
}
```

and try filling in different values for the blanks and seeing what output we get:

#code(```
System.out.println((true ? @1|new B()| : @1|new B()|).who);
```)

Unsurprisingly, this prints `"B"`. What about:

#code(```
System.out.println((true ? @1|new B()| : @1|new A()|).who);
```)

You might expect this to also print `"B"`, because that's the value that we created. However, it actually prints `"A"`! Let's see a few more examples:

#code(```
System.out.println((true ? @1|new B()| : @1|new C()|).who);
```)

Will this print `"B"`? No, in fact, this also prints `"A"`! How about:

#code(```
System.out.println((true ? @1|new B()| : @1|new D()|).who)
System.out.println((true ? @1|new B()| : @1|3|).who)
```)

Both of these produce a static error. It's instructive to read the error message: in both cases they reference `Object`. In the former case, it's because there is nothing else common to B and D. But in the latter case, the primitive value 3 was effectively converted into an object---`new Integer(3)`---and those two object types were compared.

What is happening in the type system that causes this error? The cause is documented here:

#link("https://docs.oracle.com/javase/specs/jls/se8/html/jls-15.html#jls-15.25.3")[https://docs.oracle.com/javase/specs/jls/se8/html/jls-15.html\#jls-15.25.3]

Specifically, the document says:

The type of the conditional expression is the result of applying capture conversion (§5.1.10) to lub(T1, T2).

where "lub" stands for "least upper bound": the "lowest" class "above" all the given ones. This type is determined _statically_. That is, the type rule is essentially:

```
Γ |- C : Bool    Γ |- T : V    Γ |- E : W    X = lub(V, W)
----------------------------------------------------------
Γ |- (if C T E) : X
```

Contrast this to the other rules we've seen for conditionals! The first type rule we saw was the most rigid, but produced the most usable values (because there was no ambiguity). The second type rule, for union types, was less rigid, but as a result the output type could have a union that needed to be split. This type rule is even less rigid (in terms of what the two branches produce), but the result could be as general as `Object`, with which we can do almost nothing.
