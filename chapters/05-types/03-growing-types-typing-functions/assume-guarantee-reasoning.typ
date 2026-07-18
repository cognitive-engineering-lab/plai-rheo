#import "/prelude.typ": *

== Assume-Guarantee Reasoning

There is a delicate dance going on between these typing rules for application and definition (now updated to have the environment). We'll use colors to highlight this:

#code(```
Γ |- F : @1|(T -> U)|    Γ |- A : @2|T|
-------------------------------
Γ |- (F A) : U
```)

#code(```
Γ[V <- @2|T|] |- B : U
--------------------------------
Γ |- (lambda V : T B) : @1|(T -> U)|
```)

The rule for `lambda` _assumes_ the parameter will be given a value of type #hl(2)[`T`]\; the application rule _guarantees_ that that the actual parameter will indeed have the expected type. The application rule _assumes_ that the function, if given a `T`, will produce a `U` (because the type is #hl(1)[`(T -> U)`]); the `lambda` rule _guarantees_ that the function will indeed perform that way. (There are indeed more connections to draw just from this pair of rules; hopefully this illustrates the general idea.)

#aside[
  The notation `(T -> U)` is not chosen at random. The `->` may remind you of the notation for implication in mathematics. That's intentional. We can read the type as "giving the function a `T` implies that it will produce a `U`" (not giving it a `T` implies nothing about what it will do…). It is that _implication_ that is assumed in the application rule, and that is guaranteed by the rule for lambda.
]

This assume-guarantee reasoning shows up in many places, so look out for this pattern in other places as well.
