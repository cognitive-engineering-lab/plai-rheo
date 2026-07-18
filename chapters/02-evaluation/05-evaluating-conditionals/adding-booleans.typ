#import "/prelude.typ": *

== Adding Booleans

Okay, so what if we wanted proper Booleans?

Again, to employ SImPl, we need to alter the AST, the evaluator, and the parser.

We can add Booleans much like we did numbers: with a constructor that wraps a plait representation of the Boolean.

```
(define-type Exp
  [num (n : Number)]
  [bool (b : Boolean)]
  [plus (left : Exp) (right : Exp)]
  [cnd (test : Exp) (then : Exp) (else : Exp)])
```

It's very important to keep in mind what the `num` and `bool` constructors stand for. Recall that this is _abstract syntax_: we are just (abstractly) representing the _program that the user wrote_, not the result of its evaluation. Therefore, these constructors are capturing syntactic _constants_ in the source program: values like `3.14` and `-1` for the former and `#true` and `#false` for the latter. They do _not_ represent compound expressions that will _evaluate to_ numbers or Booleans. What an expression will evaluate to, for now, can only be determined by running it. Later #iconlink(<chapters:05-types>), we will see there are other ways of doing it too!

#aside[
  The abstract syntax does not dictate what concrete syntax we use. For instance, we may write numbers as `3` or as `III`. We might write Boolean values as `#t`, `#true`, `true`, `True`, …. We may even have different concrete syntaxes for the same abstract syntax. This is precisely the _abstraction_ that abstract syntax provides!
]

Easy peasy! This naturally suggests what we should do in the evaluator:

```
(define (calc e)
  (type-case Exp e
    [(num n) n]
    [(bool b) b]
    [(plus l r) (+ (calc l) (calc r))]
    [(cnd c t e) (if (zero? (calc c))
                     (calc t)
                     (calc e))]))
```

Oh…oops. This version of `calc` doesn't type-check, because our calculator is supposed to return only numbers, not Booleans!

In fact, we had to know that this couldn't last. We aren't interested only in calculators; we want to build full-fledged programming languages. They have a wide range of values, i.e., answers: numbers, Boolean, strings, images, functions, and more.
