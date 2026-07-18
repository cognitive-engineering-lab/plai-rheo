#import "/prelude.typ": *

== Laziness Via Closures: Beyond Numbers

Laziness becomes more interesting when we consider data structures. Conventionally, data constructors are _not_ strict, so their arguments are not evaluated eagerly. We can illustrate this using lists, though technically we will be constructing _streams_ (which are infinite, as opposed to lists, which are finite).

First, read about streams represented using closures:

#link("https://dcic-world.org/2025-02-09/func-as-data.html#%28part._streams-from-funs%29")[https://dcic-world.org/2025-02-09/func-as-data.html\#%28part.\_streams-from-funs%29]

What would the same code look like in a language that was already lazy?

To experiment with that, we'll now use the Racket language

```
#lang lazy

(define ones (cons 1 ones))

(define (nats-from n)
  (cons n (nats-from (add1 n))))

(define nats (nats-from 0))

(define (take n s)
  (if (zero? n)
      empty
      (cons (first s) (take (sub1 n) (rest s)))))
```

Observe how some of these values print:

```
> ones
#<promise:ones>
> nats
#<promise:nats>
```

The word "promise" means these are _thunks_ that represent the stream. To view the thunk's content, we need to "force" the "promise", which we do using the `!` operator:

```
> (! ones)
#0='(1 . #<promise!#0#>)
> (! nats)
'(0 . #<promise:...e/pkgs/lazy/base.rkt:299:29>)
```

In the case of `ones`, Racket is telling us that the rest of the stream is the _same_ stream as the one we are viewing: i.e., it's a cyclic stream. For `nats`, it tells us that the first element is `0`, followed by another promise. We can explore these streams a bit further:

```
> (! (rest ones))
#0='(1 . #<promise!#0#>)
> (! (rest (rest (rest ones))))
#0='(1 . #<promise!#0#>)
> (! (rest nats))
'(#<promise:...e/pkgs/lazy/base.rkt:299:29> . #<promise:...e/pkgs/lazy/base.rkt:299:29>)
> (! (rest (rest (rest nats))))
'(#<promise:...e/pkgs/lazy/base.rkt:299:29> . #<promise:...e/pkgs/lazy/base.rkt:299:29>)
```

Unsurprisingly, `ones` does not change. But with `nats`, as we explore more of the stream, we run into more thunks. This is where `take` is useful: it gives us a finite prefix of the potentially infinite stream. Unfortunately, that also seems to just produce more thunks, and it seems like we would need to laboriously apply `!` to each part:

```
> (take 10 ones)
'(#<promise:...e/pkgs/lazy/base.rkt:299:29> . #<promise:...e/pkgs/lazy/base.rkt:299:29>)
> (take 10 nats)
'(#<promise:...e/pkgs/lazy/base.rkt:299:29> . #<promise:...e/pkgs/lazy/base.rkt:299:29>)
```

For situations like this, where we _know_ the output is going to be finite, we might want to resolve all the thunks. For this, Lazy Racket provides `!!`, which recursively applies strictness to all contained thunks:

```
> (!! (take 10 ones))
'(1 1 1 1 1 1 1 1 1 1)
> (!! (take 10 nats))
'(0 1 2 3 4 5 6 7 8 9)
```

Sure enough, we get the expected answer.

#callout("Exercise:")[What happens if we apply `!!` to `ones` and to `nats`? Try it out, and explain what you see.]
