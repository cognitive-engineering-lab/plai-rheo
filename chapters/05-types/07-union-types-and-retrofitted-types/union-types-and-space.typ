#import "/prelude.typ": *

== Union Types and Space

Therefore, union types combined with if-splitting gives us an alternate approach of obtaining something akin to algebraic datatypes in our programming language. However, we don't obtain the space benefits of the algebraic datatype definition. We created two distinct types; in principle, that's not a problem. However, to write programs, we needed to have predicates (`mt?` and `node?`) that took _any_ value. Therefore, those predicates need type-tags on the values to be able to tell what kind of value they are looking at. Observe that these are _type_ tags, not _variant_ tags, so the amount of space they need is proportional to the number of types in the whole program, not just the number of variants in that particular algebraic datatype definition.
