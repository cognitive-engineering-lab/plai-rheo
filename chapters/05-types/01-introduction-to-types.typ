#import "/prelude.typ": *
#show: book-style
#set document(title: [Introduction to Types])

= Introduction to Types

We're done with objects. Why weren't objects in SMoL?

+ Not all languages have them.
+ The ones that do have them can't seem to agree on the details (classes versus prototypes, single- versus multiple-inheritance, classes versus traits and mixins, etc.). There's very little "standard" there.
+ We can add most notions through desugaring!

Now we move on to types. We will always use the term _type_ to refer to a _static_ check, i.e., one that can be done purely with the program source. This means types cannot refer to dynamic conditions, and may suffer from either false-positive or false-negative errors (e.g., something that is in the code but can never run in practice may still cause a type error); in return, they give us guarantees without ever having to run the program. This is important when the program is expensive to run, impossible (e.g., it depends on conditions that can't be reproduced by the developer), or dangerous.

Types aren't really a part of SMoL either, but not because we can add them through desugaring (which we can't); rather, it's for the first two reasons: many languages don't have them, and those that do don't often agree on their form (in large part because of their disagreement over the nature of objects). However, there are parts they _do_ (largely) agree on, which we will begin with.

#include "01-introduction-to-types/a-standard-model-of-types.typ"
#include "01-introduction-to-types/a-concise-notation.typ"
