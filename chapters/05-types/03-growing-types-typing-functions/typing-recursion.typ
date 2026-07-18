#import "/prelude.typ": *

== Typing Recursion

What went wrong above? The problem is that each application "uses up an arrow" in a function type; because a program text must be finite, it can contain at most a finite number of "arrows", so eventually the program must terminate. To get around this, we need a way to effectively have an "infinite quiver".

We typically do this by adding a recursive function construct to the language, and create a custom type for it. Let's start with a type rule for the analogous, but simpler, `let`:

```
Γ |- E : T    Γ[V <- T] |- B : U
--------------------------------
Γ |- (let V : T E B) : U
```

Note that we're going to expect an annotation in `let` for the same reason we do for function definitions. So this says that we'll check that `E` actually does have the type promised in the declaration, `T`; when we extend the type environment with the `V` having type `T`, if the body `B` produces type `U`, then that's the type of the whole expression.

#aside[
  Notice that there's an assume-guarantee pair in the antecedent: the first term is guaranteeing the annotation, which the second term is assuming.
]

#aside[
  Technically, the type of `E` could be _calculated_. Therefore, the `T` annotation is not strictly necessary.
]

Observe that this is basically the type rule we would get from expanding the syntactic sugar for `let`. Therefore, this still doesn't let us write a recursive definition. We need something more. Let's introduce a new construct, `rec`, for recursive definitions. An example of a `rec` (in an untyped setting) might be

```
(rec ([inf-loop (lambda (n) (inf-loop n))])
  (inf-loop 0))

(rec ([fact (lambda (n) (if (zero? n) 1 (* n (fact (- n 1)))))])
  (fact 10))
```

In the typed world, we'll want rec to have the form

```
(rec V : T E B)
```

so we'd instead have to write

```
(rec inf-loop : (Number -> Number)
     (lambda (n) (inf-loop n))
  (inf-loop 0))

(rec fact : (Number -> Number)
     (lambda (n) (if (zero? n) 1 (* n (fact (- n 1)))))
  (fact 10))
```

where `V` is `fact`, `T` is `(Number -> Number)`, `E` is the big `lambda` term, and `B` is `(fact 10)`.

So this introduces a recursive definition, and then uses it. How might we type this?

```
???
------------------------
Γ |- (rec V : T E B) : U
```

Well, clearly one part of it must be the same: we have to type the body in the extended environment, and the environment must be extended with the annotated type:

```
???    Γ[V <- T] |- B : U
-------------------------
Γ |- (rec V : T E B) : U
```

We also know that we need to confirm that the annotation is correct:

```
??? |- E : T    Γ[V <- T] |- B : U
----------------------------------
Γ |- (rec V : T E B) : U
```

But clearly, _something_ needs to be different, otherwise we've just reproduced `let`. Look at the example use of `rec`: the `E` term also needs to have `V` bound in it! In other words, both `E` and `B` are typed in the same environment:

```
Γ[V <- T] |- E : T    Γ[V <- T] |- B : U
----------------------------------------
Γ |- (rec V : T E B) : U
```

From the type, we can read off how the recursion happens: the extended environment for `B` _initiates_ the recursion, while that for `E` _sustains_ it. Essentially, the environment of `E` enables arbitrary recursive depth.

In short, to obtain arbitrary recursion---and hence infinite loops---we have to add a special construct to the language and its type-checker; we cannot obtain it just through desugaring. Once we add `rec` to the STLC, however, we obtain a conventional programming language again.
