#import "/prelude.typ": *

== The "Object" Pattern

We can consolidate what we have written above as the "object" pattern: code that looks like

```
  (lambda (m)
    (case m
      … dispatch on each of the members …))
```
