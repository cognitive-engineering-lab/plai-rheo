#import "/prelude.typ": *

== Using Truthy-Falsy Values

Some languages use truthy-falsy values to handle partial functions. Instead of signaling an error, they return a falsy value when the argument cannot be handled. For instance, it is common to return `#false` in Racket or `None` in Python as an error code, and a proper value for normal execution. Consider this Racket example:

```
(define (g s)
  (+ 1 (or (string->number s) 0)))
```

This function accepts a string that may or may not represent a number. If it does, it returns one bigger number; otherwise it returns `1`:

```
(test (g "5") 6)
(test (g "hello") 1)
```

This works because `string->number` returns a number or, if the string is not legal, `#false`. In Racket, all values other than `#false` are truthy. Thus, legitimate strings short-circuit evaluation of the `or`, while non-numeric strings result in `0`. These therefore serve as a rough-and-ready option types in languages that don't (or didn't) have proper datatype constructors.

We will discuss this issue further later in the book #iconlink(<chapters:05-types:07-union-types-and-retrofitted-types>).
