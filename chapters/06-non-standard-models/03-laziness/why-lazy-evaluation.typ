#import "/prelude.typ": *

== Why Lazy Evaluation

Suppose, instead, we evaluate this lazily. The evaluation would look like this:

```
  (f (+ 2 3))
→ (g (+ (+ 2 3) (+ 2 3)))
→ (h (* (+ (+ 2 3) (+ 2 3))) 2))
→ (+ (* (+ (+ 2 3) (+ 2 3))) 2) 5)
```

A natural question might be, why bother doing this?

+ A reason people often cite is that it can save time, in that we don't need to evaluate parameters we don't need. For instance, suppose we have

  ```
  (deffun (f x y z)
    (if (zero? x)
        y
        z))
  ```

  and we call f with two expensive-to-compute parameters in the last two positions. In an eager language, we have evaluated both whether we want to or not. In a lazy language, we only evaluate the one we need. As we will see below, this is actually not a very compelling argument.

+ A second reason is that it enables us to add new, non-eager constructs to the language through functions. Consider `if`: in an eager language it can't be a function because the whole point of `if` is to not evaluate one of the branches (which would become parameters that are evaluated). Again, this argument has somewhat limited merit: we have seen how we can add such constructs using macros, which can do a great deal more as well.

+ The most interesting reason is probably that _the set of equations that govern the language changes_. Consider the following. Suppose we have the expressions `E` and `(lambda (x) (E x))`. Are they the "same"? It would seem, intuitively, that they are. Suppose `E` is a function. In any setting where we apply `E` to a parameter, the second expression does exactly the same: it takes that parameter, binds it to `x`, and then applies `E` to `x`, which has the same effect.

  However, note that `E` may not be a function! It could be a `print` statement, `(/ 1 0)`, and so on. In those cases, `E` evaluates right away and has some observable effect, but the version "hidden under the `lambda`" will not until it is used.

  Why does this matter? It matters because many parts of programming implementations and tools want to replace some terms with other terms. An optimizing compiler does this (replacing a term with an equivalent one that is better by whatever optimizing criterion is in use), as do program refactoring engines, and more. Thus, the more terms that can be replaced, or the fewer conditions under which terms can be replaced, the better. Lazy languages allow more terms to be replaced.

#callout("Terminology:")[This equivalence is called "rule eta" (η).]

#callout("Terminology:")[You may see some people say that lazy languages have "referential transparency". If you ask them to define it, they may say something like "you can replace equals with equals". Think about that for a moment: you can _always_ replace equals with equals. That is (by some definitions) literally what equality _means_: two things are equal exactly when you can replace one with the other. So that phrase tells us nothing. In fact, every language has some degree of "referential transparency": you can always replace some things with other equivalent things. In lazy languages, the set of things you can replace is usually bigger: the referential transparency relation is larger. That's all.]

+ One very important, practical reason is to create potentially-infinite data structures. See the example on streams below.

+ More fundamentally, the famous paper #link("https://www.cse.chalmers.se/~rjmh/Papers/whyfp.html")[Why Functional Programming Matters] argues that laziness is a _modularity_ concept, and develops this argument through several beautiful examples.
