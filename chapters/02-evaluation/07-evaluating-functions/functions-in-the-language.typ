#import "/prelude.typ": *

== Functions in the Language

There are many ways to think about adding functions to the language. Many languages, for instance, have top-level functions; e.g.:

```
fun f(x):
  x + x
```

Indeed, some languages (such as C) _only_ have top-level functions. Most modern languages, however, have the ability to write functions outside the top-level: e.g.,

```
fun f(x):
  fun sq(y):
    y * y
  sq(x) + sq(x)
```

and even to _return_ those functions, and even to allow them to be written _anonymously_. Since just about every modern language supports it, we'll think of this as a component of SMoL. Indeed, with such a facility, we don't really need a named function construct per se: we could instead have written

```
fun f(x):
  sq = lam(y): y * y
  sq(x) + sq(x)
```

And in turn we can replace `f` with a name-binding and `lam`, too.
