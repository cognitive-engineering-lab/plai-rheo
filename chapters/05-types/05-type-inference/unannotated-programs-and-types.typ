#import "/prelude.typ": *

== Unannotated Programs and Types

Consider the following plait program:

```
(lambda (x y)
  (if x
      (+ y 1)
      (+ y 2)))
```

If we enter this program into plait, e.g., as follows, something remarkable happens:

```
> (lambda (x y)
    (if x
        (+ y 1)
        (+ y 2)))
- (Boolean Number -> Number)
#<procedure>
```

In response, plait _figures out_ the type of this function _without_ our having to provide any annotations. This is in contrast to the type-checker we just wrote #iconlink(<chapters:05-types:03-growing-types-typing-functions>), which required us to extend the syntax just to provide (required) type annotations. That tells us that something different---and more---must be happening under plait. In contrast, consider another example:

```
(lambda (x)
    (if x
        (+ x 1)
        (+ x 2)))
```

This produces an error, observing that we are using `x` both in a position that requires it to be a Boolean (in `if`) and a number (in the two additions). Again, plait has figured this out without our having to write any annotations at all!

The algorithm that sits underneath plait is essentially the same algorithm under OCaml, Haskell, and several other programming languages. These languages provide _type inference_: figuring out (inferring) types automatically from the program source. Now we're going to see how this works.

The key idea is to break this seemingly very complex problem into two rather simple parts. In the first, we recursively visit each sub-expression of the program (following SImPl) and generate a set of _constraints_ that formally do what we've been doing informally above. The second phase _solves_ this set of constraints, using a process that is a generalization of the process you used for solving "systems of simultaneous equations" in school. The solution is a _type_ for each variable. That lets us fill in the annotations that the programmer left blank.

The process of generation will also have applied the type constraints, so there will be no further need to type-check the program; but we can use the annotations, for instance, in an IDE for tool-tips, in a compiler for optimization, etc. That is, with inference, we can program as if we're in a "scripty" language without annotations, yet achieve most of the benefits of types. (I say "most" because one of the benefits is documentation; leaving off all annotations makes programs harder to read and understand. For that reason, inference should be used sparingly.)
