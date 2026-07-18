#import "/prelude.typ": *

== Generic Printing

One of the consequences of our tagged representation is that when extracting a value from memory, we don't _have_ to know whether to use `safe-read-num` or `safe-read-str`; the tag at the address can tell us which to use. That is, we can define

```
(define (generic-read a)
  (let ([tag (vector-ref MEMORY a)])
    (cond
      [(= tag NUMBER-TAG) (safe-read-num a)]
      [(= tag STRING-TAG) (safe-read-str a)]
      [else (error 'generic-print "invalid tag")])))
```

Unfortunately, this code can't be typed by plait because the two branches return different types. We can solve this in a few ways:

+ We could use a datatype, similar to `Value`, to represent the memory values.  However, this creates a much more complicated representation for memory, which masks what is happening at a lower level. Therefore, we don't explore that avenue.
+ We can use a hack: use `#lang plait #:untyped`, which provides the same syntactic language, features, and run-time behavior, but turns off the type-checker. (Curiously, we were using the type-checker to keep us disciplined: so that the only values we could store in `MEMORY` would be numbers! Therefore, it's good to not use the untyped version often.)
+ Notice that in the end, what printers do is essentially print a string. Therefore, we just need to return a string in all cases:

  `(define (generic-read a)`

  ```
    (let ([tag (vector-ref MEMORY a)])
      (cond
        [(= tag NUMBER-TAG) (number->string (safe-read-num a))]
        [(= tag STRING-TAG) (safe-read-str a)]
        [else (error 'generic-print "invalid tag")])))
  ```

A consequence of having this function is that we can rewrite our tests to be more proper:

```
(test (generic-read (calc (plus (num 1) (num 2)))) "3")
(test (generic-read (calc (plus (num 1) (plus (num 2) (num 3))))) "6")
(test (generic-read (calc (cat (str "hel") (str "lo")))) "hello")
(test (generic-read (calc (cat (cat (str "hel") (str "l")) (str "o")))) "hello")
```

This is much closer to how we would write the test in the original interpreter; the only difference here is that the evaluator produces an address as the value, but we would like to inspect the value in a human-readable and -writable form, so we use `generic-read`.

#callout("Alert:")[If you run these tests in addition to the preceding ones, you may need to enlarge `MEMORY`.]
