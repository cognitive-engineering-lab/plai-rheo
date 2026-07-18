#import "/prelude.typ": *
#show: book-style
#set document(title: [A Standard Model of Objects])

= A Standard Model of Objects

Now we're ready to start looking at our first major language feature that goes beyond SMoL: objects. Not all SMoL languages have objects; though many do, they have them in very different ways. Nevertheless, what we will see is that there is a fairly uniform way to think about objects across all these languages, and furthermore this way of thinking really builds on our understanding of SMoL.

When building the essence of objects, though, we now have a choice: we can do it either in the core or through syntactic sugar. The former is frustrating in several ways:

- We have to do more low-level bookkeeping (e.g., with environments) that may not necessarily be _instructive_.
- The interpreter gets larger and more unwieldy, because all the new constructs go in the same place rather than each being independent definitions.
- Most of all: it becomes a lot harder to write illustrative programs and tests, because the core language may not have all the features we need to make this convenient.

In contrast, all these problems go away if we use syntactic sugar instead. Therefore, even though a real implementation may well have at least parts of objects (especially the parts needed for efficiency) in the core language, we are going to build objects entirely through desugaring, using macros. In fact, in this book, we will do something even simpler: we will give #emph[concrete examples] of what programs desugar _to_. Figuring out the general desugaring will be left as an exercise for you. To aid in that process, we will write code in as stylized a form as possible, not using any short-cuts that might obscure the macro rules.

#callout("Note:")[
  The programs in this section cannot be written in the language `plait`. Instead, we will use `#lang racket`, which does not perform static type-checking. Add the line

```
(require [only-in plait test print-only-errors])
```

  at the top to access the testing operator and printing control parameter from `plait`.
]

#callout("Exercise:")[Spot the point at which the type-checker would become problematic. *Hint:* The easiest way is, of course, to keep using `#lang plait` until you run into a problem. Make sure you understand what the problem is!]

#include "01-a-standard-model-of-objects/what-is-an-object.typ"
#include "01-a-standard-model-of-objects/the-object-pattern.typ"
#include "01-a-standard-model-of-objects/constructors.typ"
#include "01-a-standard-model-of-objects/the-class-pattern.typ"
#include "01-a-standard-model-of-objects/state.typ"
#include "01-a-standard-model-of-objects/private-members.typ"
#include "01-a-standard-model-of-objects/a-refined-class-pattern.typ"
#include "01-a-standard-model-of-objects/static-members.typ"
#include "01-a-standard-model-of-objects/a-re-refined-class-pattern.typ"
#include "01-a-standard-model-of-objects/objects-with-self-reference.typ"
#include "01-a-standard-model-of-objects/dynamic-dispatch.typ"
