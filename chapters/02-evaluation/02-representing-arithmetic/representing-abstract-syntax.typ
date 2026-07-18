#import "/prelude.typ": *

== Representing Abstract Syntax

In the rest of this book, except where indicated otherwise, we will implement things in the #link("https://docs.racket-lang.org/plait/index.html")[plait] language of Racket. Please make sure you have plait installed to follow along.

We will create a new tree datatype in plait to represent ASTs. In the sentence diagram above, the leaves of the tree are words, and the nodes are grammatical terms. In our AST, the leaves will be numbers, while the nodes will be operations on the trees representing each sub-expression. For now, we have only one operation: addition. Here's how we can represent this in plait syntax:

```
(define-type Exp
  [num (n : Number)]
  [plus (left : Exp) (right : Exp)])
```

This says:

- We are defining a new type, `Exp`
- There are two ways of making an `Exp`
- One way is through the constructor `num`:
  - A `num` takes one argument
  - That argument must be an actual number
- The other way is through the constructor `plus`:
  - A `plus` takes two arguments
  - Both arguments must be `Exp`s

If it helps as you read what follows, this is very analogous to the following Java pseudocode skeleton (or the analog with Python dataclasses):

```
abstract class Exp {}

class num extends Exp {
  num(Number n) { … }
}

class plus extends Exp {
  plus(Exp left, Exp right) { … }
}
```

Let's look at how some of the previous examples would be represented:

#table(
  columns: 2,
  [*Surface Syntax*], [*AST*],
  [`1`], [`(num 1)`],
  [`2.3`], [`(num 2.3)`],
  [`1 + 2`], [`(plus (num 1) (num 2))`],
  [`(1 + 2) + 3`],
  [```
(plus (plus (num 1) (num 2))
      (num 3))
```],
  [`1 + (2 + 3)`],
  [```
(plus (num 1)
      (plus (num 2) (num 3)))
```],
  [`1 + ((2 + 3) + 4)`],
  [```
(plus (num 1)
      (plus (plus (num 2)
                  (num 3))
            (num 4)))
```],
)

Observe a few things about these examples:

- The datatype definition does not let us _directly_ represent surface syntax terms such as `1 + 2 + 3 + 4`; any ambiguity has to be handled by the time we construct the corresponding AST term.
- The number representation might look a bit odd: we have a `num` constructor whose only job is to "wrap" a number. We do this for consistency of representation. As we start writing programs to process these data, it'll become clear why we did this.
- Notice that every significant part of the expression went into its AST representation, though not always in the same way. In particular, the `+` of an addition is represented by the _constructor_; it is not part of the parameters.
- The AST really doesn't care what surface syntax was used. The last term could instead have been written as

```
(+ 1
   (+ (+ 2 3)
      4))
```

or even as

#image("/images/image10.png", width: 284pt)

and it would presumably produce the same AST.

In short, ASTs are tree-structured data that *represent programs in programs*. This is a profound idea! In fact, it's one of the great ideas of the 20th century, building on the brilliant work of Gödel (encoding), Turing (universal machine), von Neumann (stored program computer), and McCarthy (metacircular interpreter).

#aside[
  Not every part of the source program has been represented in the AST. For instance, presumably both `1 + 2` and `1    +  2` would be represented the same way, ignoring the spaces. In practice, a real language implementation does need to know something about the syntax: for instance, to highlight pieces of the program source when there is an error, as DrRacket does. Therefore, real-world implementations use abstract syntax but with metadata relating it back to the source.
]
