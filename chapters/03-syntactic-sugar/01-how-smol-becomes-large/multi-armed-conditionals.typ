#import "/prelude.typ": *

== Multi-Armed Conditionals

Here's one last example that clarifies what … means: it means "zero or more instances of the preceding pattern". Using it, we can define our own multi-armed conditional. Suppose we want to define a function called `sign` that produces a string based on the sign of a number:

```
(define (sign n)
  (my-cond
   [(< n 0) "negative"]
   [(= n 0) "zero"]
   [(> n 0) "positive"]))
```

Again, it's clear that `my-cond` can't be a function; we need to extend the language with a new construct, using a macro.

How many arms should our multi-armed conditional have? As many as the programmer wants, of course. We'll further stipulate that if we have exhausted all the questions and none has yielded a true value, the "falling through" produces an error.

Thus, we want to peel off the first question-answer pair and evaluate the question. If it succeeds, we evaluate the answer. Otherwise, we want to recur on the remaining questions…which is essentially a smaller instance of `my-cond`. (That's right, we're recurring on _syntax_ now!)

Since `…` means "zero or more", we end up with a pattern where we repeat a pattern: the first copy peels off the first instance, while the second, followed by a `…`, captures all the remaining instances:

```
(define-syntax my-cond
  (syntax-rules ()
    [(my-cond) (error 'my-cond "should not get here")]
    [(my-cond [q0 a0] [q1 a1] ...)
     (if q0
         a0
         (my-cond [q1 a1] ...))]))
```

#callout("Exercise:")[Examine this code in detail. Try out the example above. It's _essential_ that you run this through the Macro Stepper: you'll learn a lot about macros from this example!]
