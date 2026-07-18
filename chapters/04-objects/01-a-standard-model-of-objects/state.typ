#import "/prelude.typ": *

== State

Many people believe that objects primarily exist to encapsulate state.

#aside[Curiously, Alan Kay, who won a Turing Award for inventing Smalltalk and modern object technology, disagrees. In #link("http://worrydream.com/EarlyHistoryOfSmalltalk/")[The Early History of Smalltalk], he says, "\[t\]he small scale \[motivation for OOP\] was to find a more flexible version of assignment, and then to try to eliminate it altogether". He adds, "It is unfortunate that much of what is called 'object-oriented programming' today is simply old style programming with fancier constructs. Many programs are loaded with 'assignment-style' operations now done by more expensive attached procedures."]

We certainly haven't lost that ability. If we desugar to a language with variables, we can easily have multiple methods mutate common state, such as a constructor argument:

```
(define (mk-o-state count)
  (lambda (m)
    (case m
      [(inc) (lambda () (set! count (+ count 1)))]
      [(dec) (lambda () (set! count (- count 1)))]
      [(get) (lambda () count)])))
```

We have changed the name to `mk-o-…` to reflect the fact that this is an object-_maker_, i.e., analogous to a class. For instance, we can test a sequence of operations:

```
(test (let ([o (mk-o-state 5)])
        (begin (msg o 'inc)
                   (msg o 'inc)
               (msg o 'dec)
               (msg o 'get)))
      6)
```

and also notice that mutating one object doesn't affect another:

```
(test (let ([o1 (mk-o-state 3)]
            [o2 (mk-o-state 3)])
        (begin (msg o1 'inc)
               (msg o1 'inc)
               (+ (msg o1 'get)
                  (msg o2 'get))))
      (+ 5 3))
```
