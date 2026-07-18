#import "/prelude.typ": *

== Binding More Locals

As we have noticed in Racket, however, the `let` can bind many names at once, not only one. It becomes clear how: the function takes formal arguments, and is applied to just as many actual arguments. There can be as many as we want! But how do we express this in macro syntax?

In mathematics, it's common to use ellipses (…) to denote a sequence of arbitrary length. Therefore, it would be nice if we could write something like this:

```
(define-syntax my-let2
  (syntax-rules ()
    [(my-let2 ([var val] ...) body)
     ((lambda (var ...) body) val ...)]))
```

This would say, `my-let2` is followed by any number of `var`-`val` pairs, followed by a body. Turn that into a `lambda` with all the `var`s as formal arguments, whose body is `body`, applied to all the same `val`s as the actual argument expressions. We would use it like so (the extra parens are to help us group the bindings):

```
(my-let2 ([x 3] [y 4]) (+ x y))
```

In fact, that is _exactly_ the syntax supported by Racket! Try out the above program: run it, and also examine it in the Macro Stepper!
