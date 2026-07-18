#import "/prelude.typ": *

== How Evaluation Works

Dataflow Graphs

What happens when we write these expressions? FrTime rewrites the way function applications happen. If _no_ argument to a function is time-varying, then the function evaluates just as it would in regular Racket. If, however, any of its arguments is time-varying, then FrTime constructs a node in a _dataflow_ graph. This node is attached to the nodes corresponding to the time-varying arguments.

Consider this expression:

```
(length (build-list (modulo seconds 10) (lambda (n) n)))
```

The act of calling length evaluates its argument, which is a call to build-list, which evaluates its two arguments. The second argument is an ordinary closure. The first argument is a call to modulo, which evaluates _its_ two arguments. Again, the second argument is just a number, but the first argument is time-varying. Consequently, this turns into a dataflow graph node, where we use the context notation to indicate where time-varying values go:

#image("/images/image5.png", width: 162pt)

Because `(modulo seconds 10)` evaluates to a time-varying value, so does the next outer expression:

#image("/images/image23.png", width: 162pt)

and finally the outermost one:

#image("/images/image7.png", width: 162pt)

The program source therefore evaluates to this dataflow graph. Now, each time-varying value may evaluate at different rates and for different reasons. `seconds`, naturally, updates once every second. When it does, its updated value is _pushed_ to all the nodes that depend on it, which update their value and push their values, and so on all the way through the graph. Finally, values may arrive at the REPL, which in FrTime is designed to display them automatically updating.

Rewriting Application

Essentially, we can think of reactivity being implemented by rewriting how function application works. In the simplest case, imagine we have a function application, `(f a)`. Let us assume that `f` is itself not a time-varying value. Then, this application rewrites `(f a)` as

```
(let ([a-value a])
  (if (time-varying? a-value)
    …
    (f a-value)))
```

We will return to the `…` in a moment. Observe that this evaluates the argument expression and, if it is not currently a time-varying value, then computation proceeds exactly as it would have in regular Racket. This means that progams that don't use time-varying values behave _exactly_ as they would in Racket, so this is a _conservative_ extension of Racket.

Now let's consider what happens if the parameter _is_ time-varying. That means, instead of immediately computing an answer, we have to create a node in the dataflow graph. We can imagine a time-varying value is an object of the class `tvv%` (`tvv` for time-varying value, and `%` using the Racket convention for classes). We will first illustrate how this might be used, then show its definition. This class has two methods: `add-consumer`, which provides another object of `tvv%` that will receive updated values, and `update`, which receives updated values. We reproduce the bottom three parts of the above dataflow graph as follows and, to keep the output short, compute the remainder relative to `5` rather than `10`:

```
(define seconds
  (new tvv% [updater (λ (v) v)]))
```

In practice, `seconds` would be attached to a system timer that pushes an update every second. For simplicity, we make it an inert object that only changes when we manually call its `updater`.

The remainder node now looks like this:

```
(define mod•5
  (new tvv% [updater (λ (v) (modulo v 5))]))
```

That is, every time it receives a value from `seconds`, it computes that value `modulo` `5`. Of course, right now it has no way of knowing that it must listen to `seconds`; we have to register it as a consumer:

```
(send seconds add-consumer mod•5)
```

Similarly, the `build-list` expression creates a time-varying value object:

```
(define bl•id
  (new tvv% [updater (λ (v) (build-list v (λ (n) n)))]))
```

which too we must attach to its value producer:

```
(send mod•5 add-consumer bl•id)
```

Observe how the `v` parameters in `mod•5` and in `bl•id` correspond to the • in the dataflow graph.

Finally, just as `seconds` is a source in the graph, we will define a sink that prints results, and send values from `bl•id` to it:

```
(define show
  (new tvv% [updater (λ (v) (println v))]))

(send bl•id add-consumer show)
```

Now we're ready to test it all! If we simulate `seconds` updating for the first ten seconds:

```
(for-each (λ (n) (send seconds update n)) (range 0 10))
```

we see the following output printed, just as we would expect:

```
'()
'(0)
'(0 1)
'(0 1 2)
'(0 1 2 3)
'()
'(0)
'(0 1)
'(0 1 2)
'(0 1 2 3)
```

So how did this work? The `tvv%` class keeps track of a list of consumers, of which above we have had only one per object. `add-consumer` merely augments this list. The `update` method receives a value, uses its `updater` function to compute a new current value, and broadcasts it to all of its consumers:

```
(define tvv%
  (class object%
    (init updater)
    (define updater-function updater)

    (super-new)

    (define consumers empty)
    (define/public (add-consumer new-consumer)
      (set! consumers (cons new-consumer consumers)))

    (define/public (update pushed-value)
      (let ([new-current-value (updater-function pushed-value)])
        (for-each (λ (c) (send c update new-current-value))
                  consumers)))))
```

That's (most of) the core logic (but read on). This brings us back to the rewriting of applications: what goes in `…`? Well, we have to

- make a new `tvv%` instance
- supply it an updater function that corresponds to `(f •)`
- registers that node as a consumer to the `tvv%` object that `a-value` references
- return the new `tvv%` instance as the result of this function "application"

#callout("Exercise:")[Turn the above rewriting idea into a proper macro. If you can, turn it into the `#%app` of a `#lang` so that one can program a module in a FrTime-like style.]

Non-Linear Graphs

The above example may be a bit misleading in suggesting that an expression must always have at most one time-varying parameter. Consider this program:

```
(= (modulo seconds 3) (modulo seconds 5))
```

Its dataflow graph looks like

#image("/images/image13.png", width: 162pt)

On every update of `seconds`, _both_ expressions that depend on it update, and their result flows to the equality comparison. Every 15 seconds, we would expect to see 12 consecutive false values followed by three consecutive true values, and that is what we see.

#callout("Exercise:")[Does the above definition of `tvv%` permit non-linear graphs? Can you write the above example with it? If so, show how. If not, modify it to allow such a definition.]

Avoiding Glitches

These forks in the graph, however, might be a cause for concern. Let us see an even simpler example:

```
(< seconds (add1 seconds))
```

Let us first be clear about what we expect this to produce: we want it to always be `#true`.

However, let us view how a simplistic dataflow graph evaluator might work. Here is the graph:

#image("/images/image6.png", width: 162pt)

Suppose the value of `seconds` updates to become 10. This value is pushed, as we would expect, to _both_ its _listeners_. This causes the `(add1 seconds)` node to update its value from `10` to `11`. However, the update to `seconds` might have caused the comparison to occur immediately. At that point FrTime would be evaluating `(< 10 10)`, which is clearly false. So for one instant this expression would evaluate to `#true`, before the update from `(add1 seconds)` arrives and it reverts to `#false`. This is called a _glitch_, a term borrowed from the same phenomenon in #link("https://en.wikipedia.org/wiki/Glitch")[electrical circuits].

Avoiding glitches is actually quite simple. Rather than updating a node in this eager manner, FrTime schedules the graph to be updated in #link("https://en.wikipedia.org/wiki/Topological_sorting")[topographical order]. That ensures that no node will ever see old, or "stale", values, and the expression will evaluate correctly. Of course, we can only apply topological sorting to directed _acyclic_ graphs, so handling cycles requires some additional work, which we do not discuss here.

#callout("Exercise:")[Make the above definition of non-linear graphs behave glitch-free.]
