#import "/prelude.typ": *

== Reactivity

There is an alternative, called _functional-reactive programming_ (FRP). We will see one particular instantiation, which is baked into Racket with an interesting user interface. The language is called FrTime. For technical reasons, we will not use a `#lang` but rather choose it from the Language menu (under Other Languages).

#callout("Do Now!")[Below are some expressions whose output is best experienced in DrRacket. Run them in DrRacket and see the output for yourself!]

FrTime essentially provides a basic version of Racket, so basic computations work exactly as we would expect:

```
> 5
5
> (+ 2 3)
5
> (string-length "hello")
5
```

We can also ask for values like the current system time:

```
> (current-seconds)
1668363009
> (add1 (current-seconds))
1668363010
```

You will likely see a different value than the one shown above, because you are not reading this at the same time as when I wrote it. But that is a problem: indeed, even I am seeing a _stale_ value, because time has passed since I ran the command.

The typical solution is to use callbacks. We can imagine a timer that takes a callback, which is called every time the time changes. However, this would invert control, which is exactly what happens in our timer example.

But FrTime, following the principles of FRP, provides a special kind of value. Try it:

```
> seconds
```

See what happens? `seconds` is a _time-varying value_: i.e., it is (technically: evaluates to) a value, but what it evaluates to changes over time. (It changes, in fact, every second.)

Naturally, we should ask: if `seconds` evaluates to a value, we can use it in expressions, so what happens if we write expressions like these?

```
> (add1 seconds)

> (modulo seconds 10)
```

Notice that both `add1` and `modulo` demand that their first argument be numbers. `seconds` is a time-varying value that at every point in time is a number. Therefore, these expressions are well-typed, producing no errors, and in fact produce the answer we might expect (but also perhaps be a bit surprised by).

Nothing prevents us from writing even longer expressions. Consider the function `build-list`:

```
> (build-list 5 (lambda (n) n))
'(0 1 2 3 4)
```

What happens if we now use a time-varying value?

```
> (build-list (modulo seconds 10) (lambda (n) n))
```

Or build an even deeper expression:

```
> (length (build-list (modulo seconds 10) (lambda (n) n)))
```
