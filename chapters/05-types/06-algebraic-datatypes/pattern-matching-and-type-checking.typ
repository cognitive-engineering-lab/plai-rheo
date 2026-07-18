#import "/prelude.typ": *

== Pattern-Matching and Type-Checking

This kind of error cannot occur naturally in languages like OCaml and Haskell. Instead of exposing all these predicates and accessors, instances of an algebraic datatype are deconstructed using pattern-matching. Thus, the size computation would be written as (`-pm` stands for "pattern matching"):

```
(size-pm : (BT -> Number))

(define (size-pm t)
  (type-case BT t
    [(mt) 0]
    [(node v l r) (+ 1 (+ (size-pm l) (size-pm r)))]))
```

This might seem like a convenience---it certainly makes the code much more compact and perhaps also much more readable---but it's also doing something more. The pattern-matcher is effectively baked into the way programs are type-checked. That is, the above algebraic datatype definition effectively adds the following typing rule to the type checker:

#code(```
Γ |- e : @1|BT|
@2|Γ| |- e1 : @3|T|
Γ@4|[V <- Number, L <- BT, R <- BT]| |- e2 : @3|T|
-----------------------------------------
@2|Γ| |- (type-case BT e
      [(mt) e1]
      [(node V L R) e2]) : T
```)

The first antecedent is clear: we have to confirm that the expression `e` evaluates to a #hl(1)[`BT`] before we pattern-match `BT` patterns against it. 
The second type-checks `e1` in the #hl(2)[same] environment as in the consequent because the `mt` variant does not add any local bindings. The type of this expression needs to be the #hl(3)[same] as the type from the other branch, due to how we're handling conditionals. 
Finally, to type-check `e2`, we have to #hl(4)[extend] the consequent's type environment with the bound variables; their types we can read off directly from the data _definition_. In short, the above typing rule can be defined automatically by desugaring.

#aside[
  Notice that there is also an assume-guarantee here: we type-check `e2` in an environment that _assumes_ the annotated types; this is _guaranteed_ by the node constructor.
]

In particular, observe what we _couldn't_ do! We didn't have awkward selectors, like `node-v`, for which we had to come up with some type. By saying they consumed a `BT`, we had to let them statically consume any kind of `BT`, which caused a problem at run-time. Here, there is no selector: pattern-matching means we can only write pattern-variables in variants where the algebraic datatype definition permits it, and the variables automatically gets the right type. Thus, pattern-matching plays a crucial role in the _statically safe_ handling of types.