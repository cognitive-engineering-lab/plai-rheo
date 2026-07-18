#import "/prelude.typ": *

== Types and Tags

Finally, we should clarify something important about the `typeof` operator in JavaScript, which is analogous to the `type` function in Python. When we impose a type system on JavaScript, we expect, say, the type `(Number -> String)` to be different from the type `(String -> Boolean)`. Similarly, an object that contains only the fields `x` and `y` is very different from the object that contains only the method `draw`.

However, these nuances are lost on `typeof`, which is innocent to even the existence of any such type systems. Therefore, all those functions are lumped under one tag, `"function"`, and all those objects are similarly treated uniformly as one tag, `"object"` (and analogously in Python). This is because their names are misleading: what they are reporting are not the _types_ but rather the run-time _tags_.

The difference between types and tags can grow arbitrarily big. After all, the number of types in a program can grow without bound, and so can their size (e.g., you can have a list of lists of arrays of functions from …). But the set of tags is fixed in many languages, though in those that allow you to define new (data)classes, this set might grow. Nevertheless, tags are meant to take up a fixed amount of space and be checked in a small constant amount of time.

Of course, this difference is not inherently problematic. After all, even in statically-typed languages with algebraic datatypes, we still need space to track variants, which requires a kind of (intra-type) tag. The issue is rather with the choice of _name_: that `typeof` and `type` do not, actually, return "types". A more accurate name for them would be something like `tagof`, leaving the term "type" free for actual static type systems.
