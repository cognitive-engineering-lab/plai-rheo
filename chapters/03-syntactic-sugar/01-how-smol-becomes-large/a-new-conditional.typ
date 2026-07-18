#import "/prelude.typ": *

== A New Conditional

Recall that Racket is a truthy/falsy language, where `if` takes any non-false value to be true. Suppose we want a strict `if` that takes only Booleans. That is, we want to extend Racket itself with a `strict-if`. Let's try this:

```
(define (strict-if C T E)
  (if (boolean? C)
      (if C T E)
      (error 'strict-if "expected a boolean")))
```

Try examples like:

```
(strict-if true 1 2)
(strict-if 0 1 2)
```

Seems to work as desired!

#callout("Do Now:")[Do you see what the problem is?]

The problem is that we have an eager language (this is true of SMoL in general!), so `strict-if`s arguments are going to be evaluated before the body begins to execute. However, the whole point of a conditional is to avoid evaluating part of the evaluation: Try

```
(strict-if true 1 (/ 1 0))
```

Compare this to what happens with

```
(if true 1 (/ 1 0))
```

Okay, so we can't use functions for this purpose. We need some other definition mechanism that consumes the _syntax_ and rewrites that, instead of letting it evaluate right away. These are macros.

Let's dive into how the macro is written, because it's not so different from the function:

```
(define-syntax strict-if
  (syntax-rules ()
    [(strict-if C T E)
     (if (boolean? C)
         (if C T E)
         (error 'strict-if "expected a boolean"))]))
```

What are the pieces? `define-syntax` says we're defining a new piece of _syntax_ (as opposed to a function). `syntax-rules` introduces a pattern-matcher (for now, ignore what the `()` means: but you do need to include it). Each rule, in brackets, is a pattern and output: if the input matches the pattern, then the desugarer (here called a _macro expander_) produces the corresponding output, but with the _names_ in the pattern (here, `C`, `T`, and `E`) copied as program source into the output. Thus, given

```
(strict-if true 1 (/ 1 0))
```

the above macro definition transforms it into

```
(if (boolean? true)
    (if true 1 (/ 1 0))
    (error 'strict-if "expected a boolean"))
```

which then evaluates exactly as we'd expect.

One nice feature of Racket is the Macro Stepper (#image("/images/image25.png", width: 100pt)). It shows the program expanding step-by-step, which is useful both for understanding macros and debugging them. If necessary, change the "Macro hiding" option at the bottom-left to read "Standard".

#callout("Exercise:")[Try it out with the above macro definition and use. See what you get. Observe how, at each step, it highlights the macro use about to be expanded followed by the result of that expansion.]

#callout("Note:")[The Macro Stepper is not an _evaluator_. It does not show the steps of evaluation, only the steps of expansion! Thus, if you write a program that will produce an error at run-time, the Macro Stepper does not show that error. It only shows _syntax_ errors.]

#callout("Note:")[When you first use the Macro Stepper, check the "Macro hiding" menu at the bottom-left. If it is not set to Standard, change it to Standard. Otherwise you will see many more steps than are useful for learning about macros. Eventually, you may have a sufficiently thorny program that makes you Disable hiding or use Custom hiding, but most of the time, Standard is the most convenient and useful.]
