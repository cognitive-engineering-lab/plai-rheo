#import "/prelude.typ": *

== From Axioms and Rules to Judgments

When we need to apply type rules to a program, we compose them recursively, just as the type-checker runs. Consider this program:

```
(+ 5 (+ 6 7))
```

To decide its type, we will use our current rules #iconlink(<chapters:05-types:01-introduction-to-types>). Observe that it does not fit any axiom, because the program does not match the syntax of a single number or string. Therefore, we have to use a conditional rule. We have seen only one so far, and fortunately this term does match the consequent: it requires two terms, and we have two terms, so `e1` is `5` and `e2` is `(+ 6 7)`. Therefore, applying this conditional rule, we get:

```
|- 5 : Num    |- (+ 6 7) : Num
----------------------
|- (+ 5 (+ 6 7)) : Num
```

So far, so good. Now let's look at the two terms in the antecedent. The first one now actually matches to an axiom; therefore, we'll mark that in green and can stop with that:

#code(```
@1|\|- 5 : Num|    |- (+ 6 7) : Num
----------------------
|- (+ 5 (+ 6 7)) : Num
```)

For the other, we have to apply the same conditional rule again:

#code(```
              |- 6 : Num    |- 7 : Num
              ------------------------
@2|\|- 5 : Num|    |- (+ 6 7) : Num
----------------------
|- (+ 5 (+ 6 7)) : Num
```)

These new terms also match the axiom for numbers, so we can mark them also in green:

#code(```
              @2|\|- 6 : Num|    @2|\|- 7 : Num|
              ------------------------
@2|\|- 5 : Num|    |- (+ 6 7) : Num
----------------------
|- (+ 5 (+ 6 7)) : Num
```)

Every part of the tree now terminates in an axiom. We therefore consider this program to have successfully type-checked. This tree is called a _judgment_, because it passes judgment on the initial term: in this case, judging it to have type-checked and to produce a value of type `Num`.

Observe closely that this is the same pattern of execution we had with the type-checker! The difference is that we were able to skip the tedious details of passing and returning things, and instead simply used pattern-matching. This will save us a fair bit of work as we go forward.
