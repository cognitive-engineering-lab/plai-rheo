#import "/prelude.typ": *

== Structural Types

In contrast, we can imagine a different type system: one where the type of each of the above classes is not its name but rather a description of what fields and methods it has: i.e., it's structure, or its "services". For instance, we might have:

```
mt : {size : ( -> int)}
node : {size : ( -> int)}
```

That is, each of these is a collection of names (one name, to be precise), which is a method that takes no parameters and returns an `int`. Whenever two types are the same, objects of one can be used where objects of the other kind are expected. Indeed, it is unsurprising that both kinds of trees have the same type, because programs that process one will invariably also need to process the other because trees are a union of these two types. Similarly, we also have

```
empty : {size : ( -> int)}
```

The above m method might be written as:

#code(```
static int m(o @1|: {size : (-> int)}|) {
  return o.size();
}
```)

That is, it only indicates what shape of object it expects, and doesn't indicate which constructor should have made it. This is called _structural_ typing, though the Internet appears to have decided to call this "duck" typing (though it's hard to be clear: there is no actual theory of duck typing to compare against well-defined theories of structural typing: #link("https://www.springer.com/gp/book/9780387947754")[Abadi and Cardelli] represent a classical viewpoint, and here's an #link("https://cs.brown.edu/~sk/Publications/Papers/Published/pgk-sem-type-fc-member-name/")[extension] for modern "scripting" languages).
