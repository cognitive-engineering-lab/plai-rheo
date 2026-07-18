#import "/prelude.typ": *

== Back to Hygiene

This now works fine for the printing example. But now we have to worry about

```
(let ([v 1])
  (or-2 false v))
```

Using fresh names, there are two things this could expand into:

```
(let ([v 1])
  (let ([v false])
    (if v
        v
        v)))

(let ([v0 1])
  (let ([v1 false])
    (if v1
        v1
        v0)))
```

Which does the macro version produce? That's right, the latter: the one corresponding to

```
(let ([v 1])
  (let ([v false])
    (if v
        v
        v)))
```

In other words, hygiene works just as well for local variables, not just for built-in functions! In other words, we have spent a whole bunch of time on something you _don't_ need to worry about. In return, it means you can use names with impunity in your macro programs, just as you do inside functions and methods because of static scoping.
