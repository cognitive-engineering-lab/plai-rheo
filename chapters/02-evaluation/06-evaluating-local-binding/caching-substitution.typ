#import "/prelude.typ": *

== Caching Substitution

We repeatedly---and rightly---refer back to substitution to understand how programs should work, and indeed will do so again later. But substitution as an _evaluation_ technique is messy. This requires us to constantly keep rewriting the program text, which takes time linear in the size of the program (which can get quite large) for _every_ variable binding. Most real language implementations do not work this way.

Instead, we might think of employing a space-time tradeoff: we'll use a little extra space to save ourselves a whole lot of time. That is, we'll _cache_ the substitution in a data structure called the _environment_. An environment records names and their corresponding values: that is, it's a collection of key-value pairs. Thus, whenever we encounter a binding we remember its value, and when we encounter a variable, we look up its value.

#aside[As with all caches, we want them to only improve performance along a dimension, not change the meaning. That is, we no longer want substitution to define _how_ we produce an answer. But, we still want it to tell us _what_ answer to produce. This will become important below.]

We will use a hash table to represent the environment:

```
(define-type-alias Env (Hashof Symbol Value))
(define mt-env (hash empty)) ;; "empty environment"
```

We will need the interpreter to actually take an environment as a formal parameter, to use in place of substitution. Thus:

```
(interp : (Exp Env -> Value))
(define (interp e nv) …)
```

Now what happens when we encounter a variable? We try to look it up in the environment. That may succeed or, in the case of our last example above, fail. We will use `hash-ref`, which looks up keys in hash tables, and returns an `Optionof` type to account for the possibility of failure. We can encapsulate it in a function that we will repeatedly find useful:

```
(define (lookup (s : Symbol) (n : Env))
  (type-case (Optionof Value) (hash-ref n s)
    [(none) (error s "not bound")]
    [(some v) v]))
```

In the event the lookup succeeds, then we want the value found, which is wrapped in `some`. This function enables our interpreter to stay very clean and readable:

```
    [(varE s) (lookup s nv)]
```

Finally, we are ready to tackle `let1`. What happens here? We must

- evaluate the body of the expression, in
- an environment that has been extended, with
- the new name
- bound to its value.

Phew!

Fortunately, this isn't as bad as it sounds. Again, a function will help a lot:

```
(extend : (Env Symbol Value -> Env))
(define (extend old-env new-name value)
  (hash-set old-env new-name value))
```

With this, we can see the structure clearly:

```
    [(let1E var val body)
     (let ([new-env (extend nv
                            var
                            (interp val nv))])
```

(Observe that we used `let` in plait to define `let1`. We'll see more of this…)

In sum, our core interpreter is now:

```
(define (interp e nv)
  (type-case Exp e
    [(numE n) n]
    [(varE s) (lookup s nv)]
    [(plusE l r) (+ (interp l nv) (interp r nv))]
    [(let1E var val body)
     (let ([new-env (extend nv
                            var
                            (interp val nv))])
       (interp body new-env))]))
```

#callout("Exercise:")[
  + What if we had not called `(interp val nv)` above?
  + What if we'd used `nv` instead of `new-env` in the call to `interp`?
  + Are there any other errors in the interpreter based on copying what we had before?
  + We seem to extend the environment but never remove anything from it. Is that okay? If not, it should cause an error. What program would demonstrate this error, and does it actually do so? (If not, why not?)
]

This concludes our first interesting "programming language". We have already been forced to deal with some fairly subtle questions of scope, and with how to interpret them. Things will only get more interesting from here!
