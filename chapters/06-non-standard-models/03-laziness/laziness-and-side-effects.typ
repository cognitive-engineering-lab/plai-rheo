#import "/prelude.typ": *

== Laziness and Side-Effects

Given the (potential) benefits of lazy evaluation, why is laziness not more widely used?

The problem is that laziness makes it much harder to predict what will happen in programs that use state. Therefore, popular lazy languages do not have state, or have it in very controlled forms. (This is not a bad thing! State _should_ only be used in very controlled ways, and Haskell, for instance, has very interesting designs that help with that. But programmers have traditionally expected to have unfettered access to state.)

Consider, for instance, the following pair of functions:

```
(define (f x y)
  (g x y))

(define (g x y)
  (if (zero? (random 2)) x y))
```

On their own, they seem harmless. However, now consider this call:

```
(f (print "X") (print "Y"))
```

In an eager language, we know both strings would be printed right away. However, in a lazy language, only one will, and we cannot tell which one. To understand which, we can no longer treat `f` as an abstraction but instead have to peer into its implementation, which in turn forces us to examine the source of `g` as well. We would have to examine every call, and track all the strictness points along the way, to determine which effects will occur and when. Here is another example:

```
(define n 0)
(f (set! n (add1 n)) (set! n (sub1 n)))
```

Again, if we ran this eagerly, we know `n` would be set back to `0` before the body of `f` even begins to evaluate. In lazy evaluation, we cannot be sure what value `n` will have: it could be `-1` or `1`. Furthermore if, tomorrow, `g` were altered to be

```
(define (g x y)
  (if (zero? (random 2)) "X" "Y"))
```

then `n` remains `0`---but we can't know without examining its code!

A natural reaction to reading these programs might be, "Don't do that!" That is in fact an entirely legitimate reaction. The problem is not laziness: it's the interaction between laziness and state. As we deprecate the use of unfettered state in programming, that increases the potential for laziness. Still, there are other situations---like errors---that we cannot avoid, and that can stay latent under lazy evaluation.
