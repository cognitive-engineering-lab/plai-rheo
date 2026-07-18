#import "/prelude.typ": *

== Evaluating Without Substitution

Above, we saw how we can think of lazy evaluation using substitution. While this is a useful mental model, as we have seen in earlier interpreters, we don't really want to use substitution as our implementation strategy. That involves repeatedly rewriting program source, which is not how our interpreter worked.

So let's say we don't pass the value but instead "the expression". Does it mean the above sequence becomes this?

```
  (f (+ 2 3))
```

`→ (g (+ x x))` where `x` is bound to `(+ 2 3)`

`→ (h (* y 2))` where `y` is bound to `(+ (+ 2 3) (+ 2 3)))`

`→ (+ x 5)` where `x` is bound to `(* (+ (+ 2 3) (+ 2 3)) 2)`

In fact, even this isn't quite right. It should rather be

```
  (f (+ 2 3))
```

`→ (g (+ x x))` where `x` is bound to `(+ 2 3)`

`→ (h (* y 2))` where `y` is bound to `(+ x x))` whose `x` is `(+ 2 3)`

`→ (+ x 5)` where `x` is bound to `(* y 2)` whose `y` is `(+ x x))` whose `x` is `(+ 2 3)`

In other words, we want to pass the unevaluated expression…but you can probably see where this is going! If we're not careful, we will end up with dynamic scope. Even setting that aside, we can't just pass the expression on its own, because when we eventually get a strictness point, we simply will have no idea what value a variable resolves to.

However, the solution also presents itself very naturally. We don't just pass an expression, we pass along its corresponding environment. An expression and environment combine to form a…closure! Of course, this closure does not take any parameters; its only job is to _suspend the evaluation of the expression_ until we reach a strictness point, and at that point, _evaluate it in the right environment_. Fortunately, we don't need to do any new work here; closure application already does it for us.
