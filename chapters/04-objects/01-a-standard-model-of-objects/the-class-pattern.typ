#import "/prelude.typ": *

== The "Class" Pattern

We've actually made quite a momentous change with this small addition: we've gone from objects to functions-that-make-objects (notice the object pattern inside the function). But traditionally, what makes objects? Classes! And classes typically have constructors. So in the process of introducing constructors, we have actually also shifted from objects to classes. The "class" pattern, at its simplest, is:

```
(define (class constructor-params)
  … the object pattern …)
```
