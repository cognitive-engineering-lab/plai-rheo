#import "/prelude.typ": *

== Space Consumption

The ability to automatically memoize computation seems to show even more benefit to making lazy evaluation a default. Why not do it?

One problem is that lazy evaluation can often take up significant amounts of space, _beyond_ the space consumed by memoization. To understand this, consider this squaring function:

```
(define (sq x)
  (* x x))
```

Because we are evaluating lazily, `x` is bound to an _expression_ represented as a closure. Now suppose our program looks like

```
(define v (make-vector 1000 0))
(sq (vector-ref v 2))
```

and beyond this we make no further reference to `v`. In an eager language, we would extract the second element of `v` and can reclaim all the remaining storage. But in a lazy language, the _entire vector_ needs to stay alive until the last use of the closure that refers to it. Seemingly straightforward programs that have an intuitive space model in an eager language can have much more subtle and complicated space models in lazy programming. Observe that the issue above has nothing to do with memoization; it's inherent in laziness.
