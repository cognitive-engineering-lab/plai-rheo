#import "/prelude.typ": *

== What is an Object?

The central question we must answer, before we start thinking about implementations, is what an object is. There is a lot of variation between languages, but they all seem to agree that an object is

- a value, that
- maps names to
- stuff: either other values or "methods".

From a minimalist perspective, methods seem to be just functions, and since we already have those in the language, we can put aside this distinction.

#callout("Terminology:")[We will use the term _member_ to refer to a generic entry in an object, when we don't want to make a distinction between fields and methods.]

How can we capture this? An object is just a value that dispatches on a given name. For simplicity, we'll use `lambda` to represent the object and Racket's `case` construct to implement the dispatching. Here's an object that responds to either add1 or sub1, and in each case returns a function that either increments or decrements:

```
(define o
  (lambda (m)
    (case m
      [(add1) (lambda (x) (+ x 1))]
      [(sub1) (lambda (x) (- x 1))])))
```

We would use this as follows:

```
(test ((o 'add1) 5) 6)
```

#aside[Observe that basic objects are a generalization of `lambda` to have multiple "entry-points". Conversely, a `lambda` is an object with only _one_ entry-point; therefore, it doesn't need a "method name" to disambiguate.]

Of course, writing method invocations with these nested function calls is unwieldy (and is about to become even more so), so we'd be best off equipping ourselves with a convenient syntax for invoking methods:

```
(define (msg o m . a)
  (apply (o m) a))
```

This enables us to rewrite our test:

```
(test (msg o 'add1 5) 6)
```

#aside[We've taken advantage of Racket's variable-arity syntax: `. a` says "bind all the remaining---zero or more---arguments to a list named `a`". The `apply` function "splices" in such lists of arguments to call functions.]

Observe something very subtle about our language: nothing precludes us from writing an arbitrary expression in the second position of a call to `msg`. That is, we can _compute_ which member we want to access. For instance:

```
(test (msg o (first '(add1)) 5) 6)
```

This is unlike many languages with objects, which force you to write the literal _name_ of the member (e.g., in Java, in most cases). We'll return to this later!

#aside[This is a general problem with desugaring: the target language may allow expressions that have no counterpart in the source, and hence cannot be mapped back to it. Fortunately we don't often need to perform this inverse mapping, though it does arise in some debugging and program comprehension tools. More subtly, however, we must ensure that the target language does not produce _values_ that have no corresponding equivalent in the source.]

Now that we have basic objects, let's start adding the kinds of features we've come to expect from most object systems.
