#import "/prelude.typ": *

== Soundness

Running on an unsafe evaluator is, as the name suggests, dangerous. Therefore, we should only do it if we can be sure that nothing can go wrong. That means that our type system needs to come with a _guarantee_.

The way this guarantee is usually formulated is as follows. Suppose we have

```
e : t
```

and suppose we evaluate it and find that

```
e -> v
```

The latter---its value---is the ground truth. The type checker's job is to make sure it matches what the evaluator produces. That is, we would ideally like that

`e : t` if and only if `e -> v` and `v : t`

This says that the type checker's job is to perfectly mirror the evaluator: whatever type the program's result value has is the same type the type-checker says it has.

Unfortunately, for a Turing-complete language, this full guarantee is impossible to obtain, because of #link("https://en.wikipedia.org/wiki/Rice%27s_theorem")[Rice's Theorem]. Instead, we have to compromise and see if we can get at least one of the two directions. When we think about it, we realize that, in a typed language, we're only really interested in programs that pass the type-checker (i.e., have a type). Therefore, we expect that

If `e : t` then

if `e -> v`, then `v : t`

This says that whatever type the type-checker predicted is exactly the type that the program has. That means we can rely on the type-checker's prediction. Which in turn means that we can be sure there are no type violations. Which tells us we can safely run the program atop an unsafe evaluator! This property is called _type soundness_.

Note that soundness is not a given: it's a property that must be formally, mathematically _proven_ of a given type-checker and evaluator. The proof can be quite complex. This is because the "shape" of program evaluation and that of type-checking can be very different, as we have seen before for conditionals #iconlink(<chapters:05-types:02-growing-types-division-conditionals>) and functions #iconlink(<chapters:05-types:03-growing-types-typing-functions>). And failure to prove it correctly---i.e., claiming it holds when in fact it doesn't---means we've allowed a vulnerability to slip through. This can manifest as uncaught exceptions, crashes, segmentation faults, etc. In addition, a clever attacker can construct a program that exploits the vulnerability, and our system can be subjected to a security or other attack. Thus, any soundness violations are emergencies and result in panic.
