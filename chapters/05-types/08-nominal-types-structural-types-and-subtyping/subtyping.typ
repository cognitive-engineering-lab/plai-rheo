#import "/prelude.typ": *

== Subtyping

The general principle here is called _subtyping_: we say that type `X` is a subtype of `Y`, written `X <: Y` (read the `<:` like a "less than" or "contained"), whenever `X` can be used wherever a `Y` was expected: i.e., `X` can _safely_ be _substituted_ for `Y`.

Java chose to make sub-_classes_ into sub-_types_. Not all object-oriented languages do this, and indeed many consider it to be a mistake, but that's the design Java has. Therefore, a sub-class is expected to offer at least as many services as its super-class; and hence, it can be substituted where a super-class is expected. The lub computation above finds the _most specific_ common super-type.

This is an account of how subtyping works for _nominal_ systems. This has the virtue of being fairly easy to understand. We can also define subtyping for _structural_ systems, but that is rather more complex: some parts are easy to follow, other parts are a bit more tricky (but essential to obtain a sound type system). For a detailed explanation, with an illustrative example, see #link("https://papl.cs.brown.edu/2020/objects.html#%28part._subtyping%29")[section 33.6.1 of PAPL].
