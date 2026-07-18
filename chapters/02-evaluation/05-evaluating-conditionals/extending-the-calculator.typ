#import "/prelude.typ": *

== Extending the Calculator

Clearly, adding conditionals doesn't change what our calculator previously did, we can leave that intact, and just focus on the handling of `if`:

```
(define (calc e)
  (type-case Exp e
    [(num n) n]
    [(plus l r) (+ (calc l) (calc r))]
    [(cnd c t e) …]))
```

Indeed, we can recursively evaluate each term, in case it's useful:

```
(define (calc e)
  (type-case Exp e
    [(num n) n]
    [(plus l r) (+ (calc l) (calc r))]
    [(cnd c t e) … (calc c) … (calc t) … (calc e) …]))
```

Let's take these one at a time.

But now we run into a problem. What is the result of calling `(calc c)`? We expect it to be some kind of Boolean value. But we don't _have_ Boolean values in the language!

That's not all. Above, we have written both `(calc t)` and `(calc e)`. However, the whole point of a conditional is that we _don't_ want to evaluate both, only one. So we have to pick which one to evaluate based on some criterion.
