#import "/prelude.typ": *

== Extending Tests

Well, actually, we shouldn't be too happy. Consider the following examples:

```
(let1E 'x (numE 1)
       (let1E 'f (lamE 'y (varE 'x))
              (let1E 'x (numE 2)
                     (appE (varE 'f) (numE 10)))))
```

What do we expect it to produce? If in doubt, we can write the same thing as a Racket program:

```
(let ([x 1])
  (let ([f (lambda (y) x)])
    (let ([x 2])
      (f 10))))
```

What we see is that _in Racket_, the inner binding of `x` does _not_ override the outer one, the one that was present at the time the function bound to `f` was defined. Therefore, this produces `1` in Racket.

We should want this! Otherwise, consider this program:

```
(let1E 'f (lamE 'y (varE 'x))
       (let1E 'x (numE 1)
              (appE (varE 'f) (numE 10))))
```

This corresponds to

```
(let ([f (lambda (y) x)])
  (let ([x 1])
    (f 10)))
```

which has an unbound identifier (`x`) error. But our interpreter produces `1` instead of halting with an error, which leads us right back to ☠️*dynamic scope* ☠️!
