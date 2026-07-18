#import "/prelude.typ": *

== A Macro Definition Hazard

However, this macro contains a subtle (almost hidden), important hazard. Consider this example:

```
(or-2 (print "hello") "not found")
```

That also returns a truthy value, but now we see the print _twice_. So we need

```
(define-syntax or-2
  (syntax-rules ()
    [(_ e1 e2)
     (let ([v e1])
       (if v v e2))]))
```

#callout("Exercise:")[Confirm that this produces the correct answer.]

The problem here is that we've forgotten that macros are _syntactic_ abstractions. Thus, when we write (if e1 e1 e2) we are asking for e1 to get copied into the output twice. This is messy no matter what (e.g., it causes any computation to happen twice in the truth case; it also blows up the size of the generated program!), but it is especially problematic if the computation has an observable effect. Thus, we have to avoid computing it more than once.

Observe that our modification works because e1 is guaranteed to be evaluated. Otherwise, the let would force it to be evaluated in situations where it might not otherwise. It is therefore important to put the let in the right place: where it was going to be evaluated anyway.
