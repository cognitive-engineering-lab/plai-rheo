#import "/prelude.typ": *

== Translating to SMoL

The following program is a rough simulation of the above Python program _if_ SMoL had a notion of `yield`, which it does not. To avoid unbound identifier errors, we will use the following simple definition of `yield`:

```
(deffun (yielder n)
  n)
```

We can then translate the above code #link("https://smol-tutor.xyz/stacker/?syntax=Lispy&randomSeed=defvar&hole=%E2%80%A2&nNext=0&program=%28deffun+%28yielder+n%29%0A++n%29%0A%0A%28deffun+%28gen%29%0A++%28defvar+n+0%29%0A++%28deffun+%28loop%29%0A++++%28yielder+n%29%0A++++%28set%21+n+%28%2B+n+1%29%29%0A++++%28loop%29%29%0A++%28loop%29%29%0A%0A%28%2B+%28gen%29+%28gen%29+%28gen%29%29%0A")[as follows]:

```
(deffun (gen)
  (defvar n 0)
  (deffun (loop)
    (yielder n)
    (set! n (+ n 1))
    (loop))
  (loop))

(+ (gen) (gen) (gen))
```

For simplicity, we're ignoring the step where we _instantiate_ the generator: i.e., we can have only one copy of the generator in this version, whereas the Python version lets us instantiate multiple. We will return to this later.

Observe that running the above program goes into an infinite loop, because `yield` does not "yield". However, because the Stacker shows us intermediate steps in the computation, it still provides something very useful.

Now that we have this program, let's run it through the Stacker. We will see a few preliminary states, and then one that #link("https://smol-tutor.xyz/stacker/?syntax=Lispy&randomSeed=defvar&hole=%E2%80%A2&nNext=2&program=%28deffun+%28yielder+n%29%0A++n%29%0A%0A%28deffun+%28gen%29%0A++%28defvar+n+0%29%0A++%28deffun+%28loop%29%0A++++%28yielder+n%29%0A++++%28set%21+n+%28%2B+n+1%29%29%0A++++%28loop%29%29%0A++%28loop%29%29%0A%0A%28%2B+%28gen%29+%28gen%29+%28gen%29%29%0A")[looks like this]:

#image("/images/image9.png", width: 468pt)

At this point, the oldest frame represents the top-level expression, which is waiting for the first call to `gen` to compute. Inside `gen`, we have initialized `n` to `0`. Now we are about to start computing the (potentially) infinite loop.

A little bit later, #link("https://smol-tutor.xyz/stacker/?syntax=Lispy&randomSeed=defvar&hole=%E2%80%A2&nNext=4&program=%28deffun+%28yielder+n%29%0A++n%29%0A%0A%28deffun+%28gen%29%0A++%28defvar+n+0%29%0A++%28deffun+%28loop%29%0A++++%28yielder+n%29%0A++++%28set%21+n+%28%2B+n+1%29%29%0A++++%28loop%29%29%0A++%28loop%29%29%0A%0A%28%2B+%28gen%29+%28gen%29+%28gen%29%29%0A")[we see the following]:

#image("/images/image2.png", width: 468pt)

#centered[_This picture is the essence of generators. Understanding it is critical._]

Here is what is happening here. The top-level computation is waiting for the call to `gen` to finish and produce an answer. _Within_ the generator, the computation has initialized n and is about to yield its current value. What is critical is the _context_ of this operation:

```
•
(set! n (+ n 1))
(loop)
```

in \@8500, which has no bindings and hence defers to \@4762. This binds `n` to `0`.

Now, suppose we could break up this stack into two parts (with the environment and store shared as needed):

```
(+ • (gen) (gen))
```

in \@top-level

```
•
(set! n (+ n 1))
(loop)
```

in \@8500

Observe that each part looks like a full-fledged stack in its own right! The environment \@top-level refers to names that the top-level uses (such as `gen`), while the environment \@8500 (and hence \@4762) refers to ones that the generator uses (such as `n`).

Until now, however, we have acted as if a program has only one stack. The simplest conceptual model for a generator is:

#centered[Each generator instance has its own local stack.]

That is, the generator's stack does not know about the computation in the main program or in any other generators. It only knows about the computation that it is performing. A `yield` does two things:

+ It transparently (i.e., without the programmer's knowledge) stores the _local_ stack with the generator data structure.
+ It returns the yielded value to the stack that invoked the generator.

Everything else---variables, aliasing, closures, growth and decline of the stack with functions calls and returns, etc.---stays exactly the same. The only difference is that calling a generator causes computation to start, or resume the context, in a separate, disconnected stack.

Thus, in the above model, after the first `yield` succeeds, the top-level stack frame would be

```
(+ 0 • (gen))
```

invoking the generator. This would resume the previous stack, so `n` would be set to 1, and the next iteration of the loop would run, which would

+ Store the generator's stack (which, conceptually, is exactly the same---only the value of `n` has changed, but that is in the environment), and
+ return the new value of `n` (i.e., `1`) to the top-level stack.

This would result in

```
(+ 0 1 •)
```

repeating the above process, and hence producing `3`.
