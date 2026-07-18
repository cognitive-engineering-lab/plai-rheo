#import "/prelude.typ": *

== Implementing Conditionals

Okay, so we have many decisions to make! To first get a working evaluator, without having to go beyond numbers, we can use a slightly different conditional construct: one that checks whether evaluates to a special numeric value, such as `0`. That is, instead of a proper `if`, we really have something we might call `if0` that works only for numbers.

How do we make this choice? Luckily, we're writing our interpreter in plait, which of course already has a conditional. Therefore, we can just reuse it:

```
(define (calc e)
  (type-case Exp e
    [(num n) n]
    [(plus l r) (+ (calc l) (calc r))]
    [(cnd c t e) (if (zero? (calc c))
                     (calc t)
                     (calc e))]))
```

Observe that the semantics of the conditional---that `0` is true, and everything else is false---is now made manifest in the body of `calc`. If we want a different semantics, that's the part of the program to zero into and change.

This solution, and indeed so far our entire evaluator, might feel a bit… disappointing? We have numbers and conditionals, sure, but all we've done is (mostly) deferred to plait to handle these. Here are some thoughts on this:

+ This is true!
+ This is not entirely true. We have made some conscious decisions, like the handling of conditionals.
+ In fact, we have made even more decisions, whether or not we were conscious of them, such as the handling of numbers. We just happened to defer those to plait, but we could have made other decisions if we wanted.
+ This reuse is actually part of the _power_ of an interpreter: it lets you exploit features that have already been built instead of having to re-implement all of them from scratch.
+ By reusing the _host_ language (here, plait), we can zero in on the differences (like the handling of conditionals), which would otherwise be lost if we had to implement everything. Later we will see stronger departures from the semantics of plait.
