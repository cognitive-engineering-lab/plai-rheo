#import "/prelude.typ": *
#show: book-style
#set document(title: [Algebraic Datatypes])

= Algebraic Datatypes

We have written numerous `define-type` definitions so far, e.g., for expressions. Now we will study this mechanism, which is increasingly found in many new programming languages, in more detail.

To simplify things, consider a simple plait data definition of a binary tree of numbers:

```
(define-type BT
  [mt]
  [node (v : Number) (l : BT) (r : BT)])
```

The `define-type` construct here is doing three different things, and it's worth teasing them apart:

- Giving a _name_ to a new type, `BT`.
- Allowing the type to be defined by multiple cases or _variants_ (`mt` and `node`).
- Permitting a _recursive_ definition (`BT` references `BT`).

It's worth asking whether all these pieces of functionality really have to be bundled together, or whether they can be handled separately. While they can indeed be separated, they often end up working in concert, especially when it comes to recursive definitions, which are quite common. A recursive definition needs a name for creating the recursion; therefore, the third feature requires the first. Furthermore, a recursive definition often needs a non-recursive case to "bottom out"; this requires there to be more than one variant, using the second feature. Putting the three together, therefore, makes a lot of sense.

This construct is called an _algebraic datatype_, sometimes also known as a "sum of products". That is because the variants are read as an "or": a `BT` is an `mt` _or_ a `node`. Each variant is an "and" of its fields: a node has a `v` _and_ an `l` _and_ an `r`. In Boolean algebra, "or" is analogous to a sum and "and" is analogous to a product.

Sometimes, you will also see this referred to as a _tagged union_. The word "union" is because we can conceptually think of a `BT` as a union of `mt`s and `node`s. The tag is the constructor. This term makes more sense once we compare it against "untagged" union types #iconlink(<chapters:05-types:07-union-types-and-retrofitted-types>).

#include "06-algebraic-datatypes/generated-bindings.typ"
#include "06-algebraic-datatypes/static-type-safety.typ"
#include "06-algebraic-datatypes/pattern-matching-and-type-checking.typ"
#include "06-algebraic-datatypes/algebraic-datatypes-and-space.typ"