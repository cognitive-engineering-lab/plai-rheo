#import "/prelude.typ": *

== Where Types Diverge from Evaluation

Something very important, and subtle, happened above. Compare the _type rule_ for a conditional with the _evaluation_ process. If the rule is too abstract, just look at the example judgments (or failed judgments) above. The evaluator evaluates only _one_ branch out of `T` and `E`; indeed, that is the _entire point_ of a conditional. The type-checker, in contrast, traverses _both_ branches! In other words, it looks at code that _might_ evaluate, not only code that absolutely _does_ evaluate.

In other words, the idea that a type-checker is like an "evaluator that runs over simple values" is a convenient starting analogy, but it is in fact false. An evaluator and type-checker follow different traversal strategies. That is why a program like `(if true 1 "hi")` might run without any difficulty but is rejected by a type-checker. While this particular example may make the type-checker look overly pedantic, what if the same program were

```
(if (is-full-moon) 1 "hi")
```

What now? Should the type-checker pass the program every month? Should it consider the moon's phase at the time of type-checking or at execution? Unfortunately, the type-checker doesn't know when the program will run; indeed, the program is type-checked once but may run an arbitrary number of times. Therefore, a type-checker must necessarily be _conservative_.

This also lets us relate type-checking to *testing*. In software testing, making sure that all branches are visited is called _branch coverage_, and making sure all branches have coverage is both important and very difficult (because each branch may have additional branches which in turn may have even more branches which…). In contrast, a type-checker effortlessly covers both branches. The trade-off is that it does so only at the _type_ level (and indeed, the abstraction of values to types is precisely what enables it to do this).

Thus, testing and type-checking are complementary. Type-checking provides code coverage at a lightweight level; testing typically provides only partial coverage but at the deep level of specific values. In recent years, people have invented a notion of #link("https://en.wikipedia.org/wiki/Concolic_testing")[concolic]---i.e., "concrete" + "symbolic"---testing to try to create the best of both worlds.
