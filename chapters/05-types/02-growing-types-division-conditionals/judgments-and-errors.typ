#import "/prelude.typ": *

== Judgments and Errors

Let's see another example, which will illustrate an important principle:

```
(+ 5 (+ 6 "hi"))
```

This proceeds analogously to the previous example. This leaves us with the following attempted judgment:

#code(```
              @1|\|- 6 : Num|    |- "hi" : Num
              ---------------------------
@1|\|- 5 : Num|    |- (+ 6 "hi") : Num
-------------------------
|- (+ 5 (+ 6 "hi")) : Num
```)

But now we have a problem: we need to type-check

```
|- "hi" : Num
```

but _we don't have a rule that matches_. Therefore, we _cannot_ construct a successful tree:

#code(```
              @1|\|- 6 : Num|    @2|\|- "hi" : Num|
              ---------------------------
@1|\|- 5 : Num|    |- (+ 6 "hi") : 
-------------------------
|- (+ 5 (+ 6 "hi")) : 
```)

Remember the "if … and … then" interpretation. Because we cannot satisfy all the antecedents, we cannot prove anything about the consequents, leaving the tree incomplete.

_A type error is simply a failure to construct a judgment._ It may not be the most satisfying user feedback, but our concern here is with a concise way of expressing ideas; going from this to an implementation is not too hard, and the user interface details can be added to the latter.

This requires some clarification. We only call it a judgment if the tree is "checked off" completely: i.e., every antecedent is generated using given rules, and all the leaves are actual axioms. In this example, we are unable to check off the tree: there is no available rule _or_ axiom that lets us conclude that `"hi"` is a `Num`. Therefore, we cannot "judge" the initial expression. This is a technical meaning of the word _judgment_, not to be confused with potentially colloquial interpretations of the term.

Similarly, imagine that we started with this program:

```
(+ 5 (- 6 7))
```

We would get this far:

#code(```
@1|\|- 5 : Num|    @2|\|- (- 6 7) : Num|
----------------------
|- (+ 5 (- 6 7)) : Num
```)

Again we would fail, this time because we haven't provided a (conditional) rule for `(- e1 e2)`. Obviously it's not difficult to define one; we just haven't done so yet, so our pattern-matcher would fail.

#callout("Exercise:")[Construct the conditional rule for `++` (string concatenation). Compare it to the code in the type-checker.]
