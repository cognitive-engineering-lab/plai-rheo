#import "/prelude.typ": *

== A Refined "Class" Pattern

With this change, we can now refine our pattern for classes:

```
(define (class-w/-private constructor-params)
  (let ([private-vars …] …)
    … the object pattern …))
```

which we can also write as:

```
(define class-w/-private
  (lambda (constructor-params)
    (let ([private-vars …] …)
      … the object pattern …)))
```

We'll see in a moment why we might want to do this.
