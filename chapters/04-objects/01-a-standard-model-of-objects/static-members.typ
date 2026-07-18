#import "/prelude.typ": *

== Static Members

Another feature often valuable to users of objects is static members: those that are common to all instances of the same type of object. This, however, is merely a lexically-scoped identifier (making it private) that lives outside the constructor (making it common to all uses of the constructor).

Suppose we want to keep a count of how many instances of a kind of object are created. This count cannot be inside any one of those objects, because they would not "know" about each other; rather, the constructor needs to keep track of this. This is the role of static members, and the variable `counter` plays this role in the following example:

```
(define mk-o-static
  (let ([counter 0])
    (lambda (amount)
      (begin
        (set! counter (+ 1 counter))
        (lambda (m)
          (case m
            [(inc) (lambda (n) (set! amount (+ amount n)))]
            [(dec) (lambda (n) (set! amount (- amount n)))]
            [(get) (lambda () amount)]
            [(count) (lambda () counter)]))))))
```

We've written the counter increment where the "constructor" for this object would go, though it could just as well be manipulated inside the methods.

To test it, we should make multiple objects and ensure they each affect the global count:

```
(test (let ([o (mk-o-static 1000)])
        (msg o 'count))
      1)

(test (let ([o (mk-o-static 0)])
        (msg o 'count))
      2)
```

It is productive to see how this program runs through the Stacker. For simplicity, we can ignore most of the details and focus just on the core static pattern. Here is a Stacker-friendly translation:

```
#lang stacker/smol/hof

(defvar mk-o-static
  (let ([counter 0])
    (lambda (amount)
      (begin
        (set! counter (+ 1 counter))
        (lambda (m)
          (if (equal? m "get")
              (lambda () amount)
              (if (equal? m "count")
                  counter
                  (error "no such member"))))))))

(defvar o1 (mk-o-static 1000))
(defvar o2 (mk-o-static 0))
(o1 "count")
(o2 "count")
```

Run this and see how the static member works!
