#import "/prelude.typ": *
#show: book-style
#set document(title: [Nominal Types, Structural Types, and Subtyping])

= Nominal Types, Structural Types, and Subtyping

Let's go back to

```
(define-type BT
  [mt]
  [node (v : Number) (l : BT) (r : BT)])
```

and ask how we could have represented this in Java.

#callout("Do Now:")[Represent this in Java!]

How did you do it? Did you create a single class with `null` for the empty case?

#callout("Exercise:")[Why is that solution not object-oriented?]

#include "08-nominal-types-structural-types-and-subtyping/algebraic-datatypes-encoded-with-nominal-types.typ"
#include "08-nominal-types-structural-types-and-subtyping/nominal-types.typ"
#include "08-nominal-types-structural-types-and-subtyping/structural-types.typ"
#include "08-nominal-types-structural-types-and-subtyping/nominal-subtyping.typ"
#include "08-nominal-types-structural-types-and-subtyping/subtyping.typ"
