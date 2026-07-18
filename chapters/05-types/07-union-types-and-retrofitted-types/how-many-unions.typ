#import "/prelude.typ": *

== How Many Unions?

When we wrote an algebraic datatype, the variants "belonged" to the new type. We had no mechanism for mixing-and-matching variants.

In contrast, with union types, a new type is a collection of existing types. There's nothing that prevents those existing types from engaging in several different unions. For instance, we had

```
(define-type-alias BT (U mt node))
```

But we could also write, say,

```
(struct link ((v : Number) (r : LinkedList)))
```

and reusing mt to define

```
(define-type-alias LinkedList (U mt link))
```

Therefore, given an mt, what "is" it? Is it a `BT`? A `LinkedList`? It's all those, but it's also just an `mt`, which can participate in any number of unions. This provides a degree of flexibility that we don't get with algebraic datatypes---since we can create ad-hoc unions of existing types---but that also means it becomes harder to tell all the ways a value might be used, and also complicates inferring types (if we see an `mt` constructed, are we also constructing a `BT`? a `LinkedList`?). The Hindley-Milner inference algorithm #iconlink(<chapters:05-types:05-type-inference>) doesn't cover these cases, though it can be extended to do so.
