#import "/prelude.typ": *

== Evaluating Functions

Now let's think about the evaluator, which by now we can think of as turning into a full-blown interpreter.

Let's start with the (almost) simplest kind of new program:

```
{lam x {+ x x}}
```

which is represented as

```
(lamE 'x (plusE (varE 'x) (varE 'x)))
```

#callout("Do Now:")[What do we want this program to evaluate to? Think in terms of types!]

Remember that `calc` produces numbers. What _number_ does the above expression evaluate to? What number do you _expect_ it to produce?

If we really want to stretch our credibility, we could either make up an encoding of it in a number, or use a number in memory. But neither of these is what we would _expect_! Let's look at what some other languages do:

```
> (lambda (x) (+ x x))
#<procedure>
> (number? (lambda (x) (+ x x)))
#f

>>> lambda x: x + x
<function <lambda> at 0x108fd16a8>
>>> isinstance(lambda x: x + x, numbers.Number)
False
```

Both Racket and Python agree: the result of creating an anonymous function is a function-kind of value, not a number. What this says is that we have to broaden the kinds of values that `interp` can produce.

#callout("Terminology:")[A _side-effect_ is a change to the system that is visible from outside the body of a function. Typical side-effects are modifications to variables that are defined outside the function, communication with a network, changes to files, and so on.]

#callout("Terminology:")[A function is _pure_ if, for a given input, it always produces the same output, and has no side-effects. In reality, a computation always has _some_ side-effects, such as the consumption of energy and production of heat, but we usually overlook these because they are universal. In a few settings, however, they can matter: e.g., if a cryptographic key can be stolen by measuring these side-effects.]

#callout("Terminology:")[Traditionally, some languages have used the terms _procedure_ and _function_ for similar but not identical concepts. Both are function-like entities that encapsulate a body of code and can be applied (or "called"). A procedure is an encapsulation that does not produce a value; therefore, it must have side-effects to be of any use. In contrast, a function always produces a value (and may be expected to not have any side-effects). This terminology has gotten completely scrambled over the years and people now use the terms interchangeably, but if someone seems to be making a distinction between the two, they probably mean something like the above.]
