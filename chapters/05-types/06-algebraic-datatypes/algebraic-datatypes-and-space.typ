#import "/prelude.typ": *

== Algebraic Datatypes and Space

Earlier, we've seen that types can save us both time and space. We have to be a little more nuanced when it comes to algebraic datatypes.

The new type introduced by an algebraic datatype still enjoys the space saving. Because the type checker can tell a `BT` apart from every other type, at run-time we don't need to record that a value is a `BT`: it doesn't need a type-tag. However, we still need to tell apart the different _variants_: the function `size-pm` effectively desugars into (`-ds` stands for "desugared"):

```
(define (size-pm-ds (t : BT))
  (cond
    [(mt? t) 0]
    [(node? t)
     (let ([v (node-v t)]
           [l (node-l t)]
           [r (node-r t)])
       (+ 1 (+ (size-pm-ds l) (size-pm-ds r))))]))
```

(We've introduced the `let` to bind the names introduced by the pattern.) What this shows is that at run-time, there are conditional checks that need to know what kind of `BT` is bound to `t` on this iteration. Therefore, we need just enough tagging to tell the variants apart. In practice, this means we need as many bits as the logarithm of the number of variants; since this number is usually small, this information can often be squeezed into other parts of the data representation.
