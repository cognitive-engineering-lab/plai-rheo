#import "/prelude.typ": *

== Introducing Union Types

As we discussed when evaluating conditionals #iconlink(<chapters:02-evaluation:05-evaluating-conditionals>), union types can be useful to represent partial functions. There are several ways of handling them:

#link("https://dcic-world.org/2025-02-09/partial-domains.html")[https://dcic-world.org/2025-02-09/partial-domains.html]

Using an option type avoids the need for ad-hoc type unions. If we have unions anyway, however, then we can give types to partial functions: e.g., `(V U Boolean)` in Racket or `(V U None)` in Python, respectively, where `V` is the normal return type. Thus, Racket's `string->number` can be given the type `(Number U Boolean)`.

What we've just seen is that with if-splitting, we can eliminate union types. That then raises the possibility that we can also introduce union types! One way is of course by giving union types to built-in functions, as above. But what about in user programs? Previously we had rejected such a solution: if we introduced a union, we had no way to deal with it. Now we can safely introduce them in languages that have solutions for deconstructing them.

How do we introduce union types? Curiously, using the same construct that eliminates them! Observe that we no longer need both branches of a conditional to return the same type:

```
Γ |- C : Bool    Γ |- T : V    Γ |- E : W
-----------------------------------------
Γ |- (if C T E) : (U V W)
```

where our notation means "the union of the types represented by `V` and `W`".
