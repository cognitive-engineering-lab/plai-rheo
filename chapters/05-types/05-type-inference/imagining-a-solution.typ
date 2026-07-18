#import "/prelude.typ": *

== Imagining a Solution

Until now, our type checker has required us to annotate the parameter of every function. But let's imagine someone handed us a piece of code without annotations; can we figure out the type anyway? For instance, consider:

```
(+ 1 2)
```

We clearly know the type of this; even our type-checker can calculate it for us without any annotations. But of course that's not surprising: there are no variables to annotate. So now consider this expression:

```
(lambda (x : ___) (+ x 1))
```

With a moment's inspection, we can tell that the function has type `(Num -> Num)`. But our type-checker couldn't have calculated that, because it would have tripped on the empty annotation. So how can _we_ figure it out?

Well, let's see. First we have to figure out the type of `x`. To determine its type, we should look for _uses_ of `x`. There is only one, and it's used in an addition. But the rule for addition

```
Γ |- e1 : Num    Γ |- e2 : Num
------------------------------
Γ |- (+ e1 e2) : Num
```

tells us that the term in that position must have type `Num`. There is no additional information we have about `x` (this remark will become clearer in a moment). Therefore, we can determine that its type must be `Num`. Furthermore, we know that the result of an addition is also a `Num`. From that, we can conclude that the function has type `(Num -> Num)`.
