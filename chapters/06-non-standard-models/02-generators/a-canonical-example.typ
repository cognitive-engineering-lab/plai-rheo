#import "/prelude.typ": *

== A Canonical Example

Consider the following canonical Python program that uses generators:

```
def nats():
  n = 0
  while True:
    yield n
    n += 1

g = nats()

next(g) + next(g) + next(g)
```

produces `0 + 1 + 2` = `3`. But how does it work?

At a textual level, we can understand it as follows. `nats` looks like a function, but it has the keyword `yield` in it. This makes it not a function but a _generator_. Its body initializes `n` to `0`, then goes into an infinite loop. Each time through the loop, it _yields_ the current value of `n`, then increments it, before continuing the loop.

Outside the definition of `nats`, we define `g` to be an _instance_ of the generator, and each call to `next` gets the next yielded value. This explains the result. What we need to do is understand what is going on inside `nats`, and hence what happens with generators in general.

It is clear that we _cannot_ think of `nats` (or of the generator returned by it) as a function. If we do, then clearly it goes into an infinite loop. That means the very first `next` call would run forever; it would never produce a value, which enables the next `next` call, and then the third, producing the sum. To see this, imagine we had the following version instead:

```
def natsr():
  n = 0
  while True:
    return n
    n += 1

natsr() + natsr() + natsr()
```

Here, even though natsr ("`nats` with `return`") has an infinite loop, every time Python runs the `return`, it halts the function and returns. Furthermore, on the next call, we start again from the beginning of `natsr`. As a result, each call produces `0` so the sum is also `0`.

In contrast, that is clearly not what is happening in (the generator created by) `nats`. Rather, it's clear that---as the name `yield` suggests---the computation is _halting_ when the `yield` occurs. When we call `next`, computation does not start at the top of `nats`; if it did, `n` would be `0`. Instead, it _resumes_ from where it left off, so that the value of `n` is incremented and the next iteration of the `while` loop occurs.

If all of this sounds suspiciously like variables in a scope being held on to by a closure, you're on the right track. To understand this more, though, we need to peer a bit more closely at the evaluation. While we could run this in the #link("https://pythontutor.com/python-debugger.html#mode=edit")[Python Tutor], that tool does not really have the support necessary for us to understand what is happening in this program. Instead, we will turn to our Stacker.

#aside[
  In Python, generators are merely syntactic sugar over the more general notion of _iterators_. Iterators respond to the `next` protocol. To learn how a generator desugars into an iterator, see #link("https://stackoverflow.com/questions/2776829/difference-between-pythons-generators-and-iterators")[this StackOverflow post]. To understand Python generators in more depth, see sections 4.1 and 4.3 of #link("https://cs.brown.edu/~sk/Publications/Papers/Published/pmmwplck-python-full-monty/")[this paper].
]
