#import "/prelude.typ": *

== If-Splitting

To summarize, `size-tr` type-checks is because the type-checker is doing something special when it sees the pattern

```
(define (size-tr [t : BT]) : Number
  (cond
    [(mt? t) …]
    [(node? t) …]))
```

It knows that every `BT` is related to `mt` and `node` through the union. When it sees the predicate, it _narrows_ the type from the full union to the branch of the union that the predicate has checked. Thus, in the `mt?` branch, it narrows the type of `t` from `BT` to `mt`; in the `node?` branch, similarly, it narrows the type of `t` to just `node`. Now, `node-l`, say, gets confirmation that it is indeed processing a `node` value, and the program is statically type-safe. In the absence of those predicates, in `size-tr-wrong`, the type of `t` does not get narrowed, resulting in the error. In `size-tr-w2`, swapping the predicates also gives an error. Here is one more version:

```
(define (size-tr-else [t : BT]) : Number
  (cond
    [(mt? t) 0]
    [else (+ 1 (size-tr (node-l t)) (size-tr (node-r t)))]))
```

This program could go either way! It just so happens that it does type-check in typed/racket, because typed/racket is "smart" enough to determine that there are only two kinds of `BT` and one has been excluded, so in the `else` case, it must be the other kind. But one could also imagine a less clever checker that expects to see an explicit test of `node?` to be able to bless the second clause.

In short, both the algebraic datatype and union type approaches need some special treatment of syntax by the type-checker to handle variants. In the former case it's through pattern-matching. The narrowing technique above is sometimes called _if-splitting_, because an `if` (which `cond` and other conditional constructs desugar to) "splits" the union. You will sometimes also see the terms _occurrence typing_ and _flow typing_ to describe variants of the ideas in this chapter.

#aside[
  This idea was invented by #link("https://docs.racket-lang.org/ts-guide/occurrence-typing.html")[Typed Racket] by studying how programmers write code in Scheme and Racket programs. It has later proved to be relevant to many real-world retrofitted type systems.
]
