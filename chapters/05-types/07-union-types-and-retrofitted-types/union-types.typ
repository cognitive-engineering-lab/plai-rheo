#import "/prelude.typ": *

== Union Types

Oops---what do we write here?!? We have to also introduce a notion of a binary tree. But we already have two existing types, `mt` and (in progress) `node`. Therefore, we need a way to define a binary tree that has a sum that combines these two existing types. This suggests that we have a way of describing a new type as a _union_ of existing types:

```
(define-type-alias BT (U mt node))
```

Observe that in this case, there are no special constructors to distinguish between the two kinds of BT. Therefore, this is called an _untagged union_, in contrast to tagged unions #iconlink(<chapters:05-types:06-algebraic-datatypes>).

Now we can go back and complete our definition of `node`:

```
(struct node ([v : Number] [l : BT] [r : BT]))
```

Now let's look at what Typed Racket tells us are the types of `node`'s constructor, predicate, and selectors:

```
> node
- : (-> Number BT BT node)
> node-v
- : (-> node Number)
> node-l
- : (-> node BT)
> node-r
- : (-> node BT)
```

Using these definitions we can create trees: e.g.,

```
(define t1
  (node 5
        (node 3
              (node 1 (mt) (mt))
              (mt))
        (node 7
              (mt)
              (node 9 (mt) (mt)))))
```

But now let's try to write a program to compute its size:

```
(define (size-tr [t : BT]) : Number
  (cond
    [(mt? t) 0]
    [(node? t) (+ 1 (size-tr (node-l t)) (size-tr (node-r t)))]))
```

It is not clear at all that this program should type-check. Consider the expression `(node-l t)`. The type of `node-l` expects its argument to be of type `node`. However, all we know is that `t` is of type `BT`. Yet this program type-checks!

The fact that this does type-check, however, should not fill us with too much joy. We saw how `size-wrong` type-checked, only to halt with an undesired run-time error. So what if we instead write its analog, which is this?

```
(define (size-tr-wrong [t : BT]) : Number
  (+ 1 (size (node-l t)) (size (node-r t))))
```

This program does *not* type-check! Instead, it gives us a type error of exactly the sort we would have expected: `node-l` and `node-r` both complain that they were expecting an `node` and were given a `BT`. So the wonder is not that `size-tr-wrong` has a type-error, but rather that `size-tr` does not!

To understand why it type-checks, we have to go back to the types of the predicates:

```
> mt?
- : (-> Any Boolean : mt)
> node?
- : (-> Any Boolean : node)
```

Critically, the `: mt` and `: node` are Typed Racket's way of saying that the Boolean will be true only when the input is an `mt` or `node`, respectively. This crucial _refinement_ information is picked up by the type-checker. In the right-hand-side of the `cond` clauses, it _narrows_ the type of `t` to be `mt` and `node`, respectively. Thus, `(node-l t)` is type-checked in a type environment where the type of `t` is `node` and not `BT`.

To test this theory, we can try another wrong program:

```
(define (size-tr-w2 [t : BT]) : Number
  (cond
    [(node? t) 0]
    [(mt? t) (+ 1 (size-tr-w2 (node-l t)) (size-tr-w2 (node-r t)))]))
```

Here, we have swapped the predicates. It is not only important that this version produces a type error, it is also instructive to understand why, by reading the type error. This explicitly says that the program expected an `node` (for instance, in `node-l`) and was given an `mt` (based on the `mt?`). This confirms that Typed Racket is refining the types in branches based on predicates.
