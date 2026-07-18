#import "/prelude.typ": *

== Simulating an Interpreter by Hand

Since we have decided to write an interpreter, let's start by understanding _what_ we are trying to get it to do, before we start to investigate _how_ we will make it do it.

Let's consider the following program:

```
(define (f x) (+ x 1))
(f 2)
```

What does it produce? We can all guess that it produces `3`. Now suppose we're asked, _why_ does it produce `3`? What might you say?

There's a good chance you'll say that it's because x gets replaced with 2 in the body of f, then we compute the body, and that's the answer:

→ `(f 2)`

→ `(+ x 1)` where `x` is replaced by `2`

→ `(+ 2 1)`

→ `3`

These programs are written in Racket. You can put these programs into DrRacket in an early student language level (like Beginning Student) and watch them run, step-by-step, using the Step button in the menu bar:

#centered(image("/images/image22.png", width: 50pt))

Now let's look at an extended version of the program:

```
;; f is the same as before
(define (g z)
  (f (+ z 4)))
(g 5)
```

We can use the same process:

→ `(g 5)`

→ (`f (+ z 4))` where `z` is replaced by `5`

→ `(f (+ 5 4))`

→ `(f 9)`

→ `(+ x 1)` where `x` is replaced by `9`

→ `(+ 9 1)`

→ `10`

#callout("Terminology:")[We call the variables in the function header the _formal parameters_ and the expressions in the function call the _actual parameters_. So in `f`, `x` is the formal parameter, while `9` is an actual parameter. Some people also use _argument_ in place of _parameter_, but there's no real difference between these terms.]

Observe that we had a choice: we could have gone either

→ `(f (+ 5 4))`

→ `(f 9)`

or

→ `(f (+ 5 4))`

→ `(+ x 1)` where `x` is replaced by `(+ 5 4)`

For now, both will produce the same _answer_, but this is actually a very consequential decision! It is in fact one of the most profound choices in programming language design.

#callout("Terminology:")[The former choice is called _eager_ evaluation: think of it as "eagerly" reducing the actual parameter to a value before starting the function call. The latter choice is called _lazy_ evaluation: think of it as not rushing to perform the evaluation.]

_SMoL is eager_. There are good reasons for this, which we will explore later #iconlink(<chapters:06-non-standard-models:03-laziness>).

Okay, so back to evaluation. Let's do one more step:

```
;; f is the same as before
;; g is the same as before
(define (h z w)
  (+ (g z) (g w)))
(h 6 7)
```

Once again, we can look at the steps:

→ `(h 6 7)`

→ (+ `(g z) (g w))` where `z` is replaced by `6` and `w` is replaced by `7`

→ `(+ (g 6) (g 7))`

→ `(+ (f (+ y 4)) (g 7))` where `y` is replaced by `6`

→ `(+ (f (+ 6 4)) (g 7))`

→ `(+ (f 10) (g 7))`

→ `(+ (+ x 1) (g 7))` where `x` is replaced by `10`

→ `(+ (+ 10 1) (g 7))`

→ `(+ 11 (g 7))`

→ `(+ 11 (f (+ y 4)))` where `y` is replaced by `7`

→ `(+ 11 (f (+ 7 4)))`

→ `(+ 11 (f 11))`

→ `(+ 11 (+ x 1))` where `x` is replaced by `11`

→ `(+ 11 (+ 11 1))`

→ `(+ 11 12)`

→ `23`

Observe that we again had some choices:

- Do we replace both calls at once, or do one at a time?
- If the latter, do we do the left or the right one first?

Languages have to make decisions about these, too! Above, we've again done what SMoL does: it finishes one call before starting the other, which makes SMoL _sequential_. Had we replaced both calls at once, we'd be exploring a _parallel_ language. Conventionally, most languages choose a left-to-right order, so that's what we choose in SMoL.
