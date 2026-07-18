#import "/prelude.typ": *

== A Definitional Convenience

Supposing we want to define a "one-armed `if`" (e.g., useful for checking erroneous conditions and proceeding only if the coast is clear): this is commonly called `unless`. We can write it this way:

```
(define-syntax unless
  (syntax-rules ()
    [(_ cond body ...)
     (if (not cond)
         (begin
           body
           ...)
         (void))]))
```

For instance, we can use it this way:

```
(unless false
  (println 1)
  (println 2))
```

Notice that in the pattern, we don't have to repeat the `unless`; we can just use an `_` instead.

#aside[The full truth is, this isn't just a _convenience_. They actually do slightly different things that you can detect in subtle situations. You can safely, and should, just use `_` instead of repeating the name of the macro.]
