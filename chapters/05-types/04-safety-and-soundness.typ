#import "/prelude.typ": *
#show: book-style
#set document(title: [Safety and Soundness])

= Safety and Soundness

A critical component of SMoL is the concept of _safety_: that some operations are _partial_ over the set of all values, and that a SMoL language enforces this by reporting violations. Typical examples of partiality may include `+` applying only to certain types of values. However, I intentionally write "operations" rather than, say, "functions", because these could be primitive operations like application (expecting the first position to be a function or method) as well. In fact, in some languages like JavaScript, there are very few violations, as the #link("https://www.destroyallsoftware.com/talks/wat")[Wat talk] shows.

How must these be enforced? It can be either statically or dynamically. In Python and JavaScript, for instance, all safety violations are reported dynamically. In Java or OCaml, most of them are reported statically. Either way, safety means that _data have integrity_: there is some notion of "what they are", and that identity is respected by operations. Put differently, data are not _misinterpreted_.

These are all very abstract statements, which we will soon concretize.

#include "04-safety-and-soundness/revisiting-the-basic-calculator.typ"
#include "04-safety-and-soundness/making-memory-explicit-unsafely.typ"
#include "04-safety-and-soundness/recovering-safety.typ"
#include "04-safety-and-soundness/what-price-safety.typ"
#include "04-safety-and-soundness/soundness.typ"
#include "04-safety-and-soundness/generic-printing.typ"
#include "04-safety-and-soundness/the-representation-of-numbers.typ"
