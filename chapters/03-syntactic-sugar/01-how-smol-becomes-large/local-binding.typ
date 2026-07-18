#import "/prelude.typ": *

== Local Binding

Now let's look at the `let` bindings we've been using until now. Imagine we want to extend Racket with a `let1` construct: for example, we want

```
(let1 (x 3) (+ x x))
```

to evaluate to 6.

#callout("Do Now:")[Can `let1` be defined as a function? Why or why not?]

`let1` can't be a function. If it were, we would first try to evaluate each of the sub-terms as arguments. There are two things here that look like argument expressions: `(x 3)` and `(+ x x)`. Suppose we try to _evaluate_ `(x 3)`. First of all, it looks like an application. Second, `x` isn't even bound. Third, there is no meaningful "value" it could produce: its only job is instead to _bind_ `x`. No, `let1` is also a new piece of syntax.

#callout("Terminology:")[We will often refer to these new pieces of syntax as _constructs_ (as in, "a new language construct"). In the Lisp/Scheme/Racket community, these are sometimes also called _special forms_, because they are syntactic forms with their own special rules for binding and evaluation.]

From now on we'll use the prefix `my-` on our macros, because we don't want to clash with the names of macros already built into Racket.

From what we've seen above, we can probably figure out half of the macro for `my-let1`:

```
(define-syntax my-let1
  (syntax-rules ()
    [(my-let1 (var val) body)
     …]))
```

But what would it `expan`d into? We certainly _could_ just expand it into the existing `let` construct in Racket, but there's another interesting option.

Let's think about what `my-let1` does: it _binds_ a name to a value, and then immediately _evaluates_ its body in an environment extended by its name. Now, can we think of anything else that binds names to values? Yes, functions. And functions evaluate a body in an extended environment. When do functions evaluate their body? When they are applied to an argument. Therefore, we can express `my-let1` in terms of an anonymous function that is applied immediately:

```
(define-syntax my-let1
  (syntax-rules ()
    [(my-let1 (var val) body)
     ((lambda (var) body) val)]))
```

Sure enough,

```
(my-let1 (x 3) (+ x x))
```

will produce `6`. Use the Macro Stepper to see how!

#callout("Terminology:")[This pattern, of an anonymous function that is used right away, is commonly called _left-left-lambda_ (where "left" stands for left-parenthesis). For a long time this remained an obscure term in the Lisp/Scheme community. But JavaScript made this pattern popular again under the name _Immediately Invoked Function Expression_ (IIFE), because of problems with the handling of scope in earlier versions of the language. If you think the parentheses look bad here, look up some examples of IIFE on the Web.]

#callout("Exercise:")[Suppose we make a mistake in the macro and swap two parts:]

```
(define-syntax my-let1
  (syntax-rules ()
    [(my-let1 (var val) body)
     ((lambda (var) val) body)]))
```

What happens when we try to evaluate

```
(my-let1 (x 3) (+ x x))
```

? Use the Macro Stepper to see what happened.
