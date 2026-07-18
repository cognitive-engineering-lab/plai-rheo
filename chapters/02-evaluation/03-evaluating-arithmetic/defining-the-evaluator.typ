#import "/prelude.typ": *

== Defining the Evaluator

Having seen how to represent arithmetic programs, we turn to writing an evaluator program that turns them into answers.

What is the type of this evaluator? Clearly it consumes programs, which here are represented by `Exp`s. What does it produce? In this case, all these expressions are going to produce numbers. For this reason, we'll call this a calculator, or `calc` for short, for now. We can thus give `calc` the type

```
(calc : (Exp -> Number))
```

Let's now try to define its body. Clearly we must have

```
(define (calc e)
  …)
```

In the body, given an `Exp`, we will want to take it apart using `type-case`, which tells us there are two options, each with some additional data (this is the moral equivalent of the method dispatch we'd have used in Java):

```
  (type-case Exp e
    [(num n) …]
    [(plus l r) …])
```

What happens in the case that the whole expression is already a number? Well, we have our answer, so we just return it. Otherwise, we have to add the two sides:

```
  (type-case Exp e
    [(num n) n]
    [(plus l r) (+ l r)])
```

giving us an overall body of:

```
(define (calc e)
  (type-case Exp e
    [(num n) n]
    [(plus l r) (+ l r)]))
```

Let's run it to…oops! We get a type error! It tells us that addition is expecting a number, but `l` is not a number: it's an `Exp`. Ah, that's because `l` and `r` still represent _expressions_, not the _answer_ that the expressions evaluate to. To fix that, we need something that can turn an expression into a number…which is precisely what we're defining! Thus, we instead write

```
(define (calc e)
  (type-case Exp e
    [(num n) n]
    [(plus l r) (+ (calc l) (calc r))]))
```

The type-checker is happy now. And sure enough, we can confirm that our examples produce what we expect. For instance:

```
(calc (num 1))
```

produces `1`,

```
(calc (plus (num 1) (num 2)))
```

produces `3`, and

```
(plus (num 1)
      (plus (num 2) (num 3)))
```

produces` 6`.

#aside[
  We've glossed over a detail: we've assumed that `+` always means numeric addition (which was already implicit in calling it "`plus`" in the AST). But some languages allow any number of different types to be "added": e.g., it can also concatenate strings. In such languages, the name in the AST might be something more generic, and the evaluator would need to handle the different possible behaviors.
]

In fact, we've glossed over something even more basic: what numeric addition means, or for that matter, even what numbers are. As we see from the Mystery Language: Arithmetic, there are many choices here. In our calculator, we have adopted numbers from plait (in `num`) and addition from plait (by using `+`). Those places in `calc` also tell us where we would go to change those choices.
