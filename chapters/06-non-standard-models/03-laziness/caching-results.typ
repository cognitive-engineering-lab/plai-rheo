#import "/prelude.typ": *

== Caching Results

If we use lazy programming without side effects, we get a nice benefit: each expression always produces the same result. In that case, we don't ever have to recompute an expression; we can just store its result and reuse it on subsequent accesses. That is, we can _cache_ the result, enabling us to trade space for time.

#aside[
  If you are not familiar with trading space for time in computation---as found in techniques such as memoization and dynamic programming---see DCIC:

  #link("https://dcic-world.org/2025-02-09/avoid-recomp.html")[https://dcic-world.org/2025-02-09/avoid-recomp.html]
]

There are, however, two kinds of result caching one can perform.

One is what happens in Lazy Racket, where each expression's result is cached locally. This means that if the same source _location_ is evaluated multiple times, the cached value can be reused. Other implementation strategies can look for the same expression even in a dynamic setting (as happens, for instance, in a Fibonacci function, which dynamically generates sub-problems). This requires a rather different implementation approach, but can yield even bigger time-space trade-offs.
