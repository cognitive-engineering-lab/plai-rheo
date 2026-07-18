#import "/prelude.typ": *

== A Re-Refined "Class" Pattern

Now we can refine our pattern for classes even further:

```
(define class-w/-private&static
  (let ([static-vars …] …)
    (lambda (constructor-params)
      (let ([private-vars …] …)
        … the object pattern …))))
```

Put differently:

```
(define class-w/-private&static
  (let ([static-vars …] …)
    … the class-w/-private pattern …))
```

#callout("Exercise:")[Statics, as defined here, are accessed through _objects_. However, statics by definition belong to a _class_, not to objects, and hence should be accessible through the class itself---for instance, even if no instances of the class have ever been created. (In the working example above, one should be able to access the count when it is still `0`.) Modify the pattern above to respect this by making static members be accessible directly through the _class_ rather than through objects.]
