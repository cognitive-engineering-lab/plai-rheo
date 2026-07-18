#import "/prelude.typ": *

== Updating the Evaluator

Now suppose we try to use our existing code:

```
[(plusE l r) (+ (calc l) (calc r))]
```

This has two problems. The first is we can't return a number; we have to return a `numV`:

```
[(plusE l r) (numV (+ (calc l) (calc r)))]
```

But now we run into a subtler problem. The type-checker is not happy with this program. Why?

Because the result of `calc` is a `Value`, and `+` consumes only `Number`s. Indeed, the type checker is forcing us to _make a decision_ here: what happens if one of the sides of `+` does not evaluate to a number?

First, let's build an abstraction to handle this, so that we can keep the core of the interpreter relatively clean:

```
[(plusE l r) (add (calc l) (calc r))]
```

Now we can defer all the logic of evaluating `+` to `add`. _Now we have to make a semantic decision_. Should we be allowed to "add" two Boolean values? What about adding a number to a Boolean or vice versa? Though there isn't quite a SMoL decision here---some languages are very strict while others are very permissive---the least-non-standard policy is to require both branches to evaluate to numbers, which we would express as follows:

```
(define (add v1 v2)
  (type-case Value v1
    [(numV n1)
     (type-case Value v2
       [(numV n2) (numV (+ n1 n2))]
       [else (error '+ "expects RHS to be a number")])]
    [else (error '+ "expects LHS to be a number")]))
```

Observe that these `else` clauses can easily represent other decisions. We can embed an entire family of mystery languages in the different choices available!

#callout("Exercise:")[Why did we write the numV constructor in `add` rather than in `calc`?]

#callout("Pro Tip:")[
  You've just added a complex chunk of code. Now would be a very good time to test your evaluator. Here are two things to consider:

  + Right now the code for conditionals _also_ does not type-check. You may find it convenient to replace the entire RHS with something semantically incorrect but type-correct, like `(numV 0)`, so you restore your working evaluator.

  + Don't forget to test for the error cases! You would do so using `test/exn`. For instance:

    `(test/exn (calc (plusE (numE 4) (boolE #false))) "RHS")`
]

Let's now turn our attention to the conditional (with the constructor name updated):

```
[(cndE c t e) …]
```

The core logic must clearly be similar: check something about the condition, and based on it, evaluate only one of the other two clauses. Once again, we have to make decisions about how we handle the conditional: should we strictly require a Boolean value, or should we make a truthy/falsy decision? We can again defer that to a helper function:

```
    [(cndE c t e) (if (boolean-decision (calc c))
                      (calc t)
                      (calc e))]))
```

Again, the least non-standard policy, and one that sets up later material, is to be strict about requiring a Boolean:

```
(define (boolean-decision v)
  (type-case Value v
    [(boolV b) b]
    [else (error 'if "expects conditional to evaluate to a boolean")]))
```

But again, starting from a strict interpretation, we can see where we can give in to any urges we feel to design a more liberal semantics: by replacing the `else` clause.

Observe, by the way, that we did something different with conditionals than we did for addition. With `add`, we evaluated both branches and gave it their corresponding `Value`s. It would be a terrible idea to do that with conditionals, because the entire point of a conditional is to *not* evaluate one of the branches! We could have sent the ASTs for the branches to a helper function, but what we have done above also works well: it localizes the _variation_ in the semantics to the helper function, but keeps what is not expected to change (the fact that a conditional syntax leads to a conditional evaluation) in the core of the evaluator.
