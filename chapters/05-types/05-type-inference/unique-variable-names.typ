#import "/prelude.typ": *

== Unique Variable Names

In what follows, we will assume that all variable names in the program are unique. That is, a given variable name is bound in at most one place in a program. This greatly simplifies the presentation below, because we can speak of the type of a variable and know _which_ variable it refers to, instead of having to constantly qualify which variable of that name we mean.

This restriction does not actually preclude any programs in a language with static scope. Consider this program, which produces `7`:

```
(let ([x 3])
  (+ (let ([x 4])
       x)
     x))
```

We can just as well _consistently rename_ one of the `x`s to something else (heck, we can even use the DrRacket interface to have Racket do the renaming for us), and leave the program meaning exactly the same:

```
(let ([x 3])
  (+ (let ([y 4])
       y)
     x))
```

This renaming process is called _alpha conversion_ or _alpha renaming_.
