#import "/prelude.typ": *

== Laziness in Eagerness

As a result of these issues, laziness has not gained popularity as a default option. At the same time, it is very useful in some settings. As we have seen above, we can always _simulate_ laziness by using thunks. This can, however, be syntactically unwieldy, so some languages provide syntactic support for it. In languages like Racket, for instance, `delay` is a syntactic form that thunks its expression, and `force` is a function that evaluates it (caching the result).
