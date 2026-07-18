#import "/prelude.typ": *

== A Subtle Test

In the examples above, we always use the closure in the scope in which it was defined. However, our language is actually more powerful than that: we can _return_ a closure and use it _outside_ the scope in which it was defined. Here's a sample Racket program:

```
((let ([x 3])
   (lambda (y) (+ x y)))
 4)
```

#callout("Do Now:")[Take a moment to read it carefully. What should it produce?]

First we bind the `x`, then we evaluate the lambda. This creates a closure that remembers the binding to `x`. This closure is the value returned by this expression:

#code(```
(@1|(let ([x 3])|
@1|   (lambda (y) (+ x y)))|
 4)
```)

This value is now applied to `4`. It's legal to do this, because the value returned is a function. When we apply it to `4`, that evaluates the sum of `4` and `3`, producing `7`. Sure enough, translating this and sending it to our interpreter produces `7`:

```
(test (interp (appE (let1E 'x (numE 3)
                           (lamE 'y (plusE (varE 'x) (varE 'y))))
                    (numE '4))
              mt-env)
      (numV 7))
```

#callout("Exercise:")[Here's another test to try out, written as a Racket program:]

```
((let ([y 3])
   (lambda (y) (+ y 1)))
 5)
```

What does it produce in Racket? Translate it and try it in your interpreter.
