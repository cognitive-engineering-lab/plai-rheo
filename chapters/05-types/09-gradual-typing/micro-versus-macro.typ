#import "/prelude.typ": *

== Micro Versus Macro

In gradual typing, we are going to add annotations to programs and then type-check the program. Within this broad principle, there are two schools of thought.

In "micro" gradual typing we can add annotations to any subset of the variables of the language. We saw this earlier in the Static Python example:

```
def insort_right(a, x, lo: int = 0, hi: Optional[int] = None):
```

Here, we have annotations on `lo` and `hi`, but not on `a` and `x`. Ergonomically, this is very convenient for the programmer: use annotations for the parts you care about, and not for the parts you don't. Unfortunately, this comes at a cost: there is now a much more complex language where any parts of a program can be static and any other parts dynamic, and they can freely commingle in the same body of code, even in a single expression or line (e.g., from the same example: `hi = len(a)`). The type system needs to somehow deal with constructs it cannot meaningfully type (like `eval`). Also, previously we had a clean and simple soundness result for the typed program; now it is rather unclear what soundness means. In turn, that means that programmers may put a lot of effort into annotations, but without a clear guarantee of what they are getting in return. (A large body of literature now tries to make sense of this.)

In contrast, there is another approach, often called "macro" gradual typing. In the macro approach, there are _two languages_: the typed and the dynamic one. They are expected to be very similar---so similar that they have the same run-time system and can freely share values---so we'll refer to them as "sibling" languages. However, they may not have the same constructs (e.g., the typed language would not contain `eval`). Instead of freely mixing code between typed and untyped, we only have to figure out what happens when values travel _between_ the languages, not within each one. The expectation is that the programmer will gradually migrate part of their codebase from the dynamic to the typed language, typically a function at a time. Each language can import code from the other, but when importing into typed code, the programmer must specify a type for the imported code.

A canonical example of this approach is Typed Racket. Because Typed Racket is one of the oldest and most developed gradually typed languages (technically, it's the _combination_ of Racket and Typed Racket that is gradually typed---Typed Racket itself is fully typed), and also offers some of the most interesting perspective on what happens when values travel between languages, we will use that as our exemplar for study.
