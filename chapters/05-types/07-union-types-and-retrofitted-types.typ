#import "/prelude.typ": *
#show: book-style
#set document(title: [Union Types and Retrofitted Types])

= Union Types and Retrofitted Types

Typed Racket is an instance of a _retrofitted_ type system: adding a type system to a language that did not previously have types. The original language, which does not have a static type system, is usually called _dynamic_. There are now numerous retrofitted type systems: e.g., TypeScript for JavaScript and Static Python for Python. There are even multiple retrofitted type systems for some languages: e.g., both TypeScript and Flow add types to JavaScript.

The goal of a retrofitted type system is to turn run-time errors into static type errors. Due to the Halting Problem, we cannot precisely turn every single run-time error into a static one, so the designer of the type system must make some decisions about which errors matter more than others. In addition, programmers have already written considerable code in many dynamic languages, so changes that require programmers to rewrite code significantly would not be adopted. Instead, as much as possible, type system designers need to accommodate _idiomatic type-safe programs_.

Algebraic datatypes present a good example. Typically, they have tended to not be found in dynamic languages. Instead, these languages have some kind of structure definition mechanism (such as classes, or lightweight variants thereof, like Python's #link("https://docs.python.org/3/library/dataclasses.html")[dataclasses]). Therefore, the elegant typing that goes with algebraic datatypes and their pattern-matching does not apply. Because it is not practical to force dynamic language programmers to wholesale change to this "new" (to that dynamic language) style of programming, type system designers must find the idioms they use (that happen to be type-safe) and try to bless them. We will look at some examples of this.

A good working example of a retrofitted typed language is Typed Racket, which adds types to Racket while trying to preserve idiomatic Racket programs. (This is in contrast to plait, which is also a typed form of Racket but does _not_ try very hard to preserve Racket idioms. The accessors we saw earlier, for algebraic datatypes #iconlink(<chapters:05-types:06-algebraic-datatypes>), are forgiving in what they accept, at the cost of static safety.)

#include "07-union-types-and-retrofitted-types/you-get-a-type-and-you-get-a-type-and-you-get-a-type.typ"
#include "07-union-types-and-retrofitted-types/union-types.typ"
#include "07-union-types-and-retrofitted-types/if-splitting.typ"
#include "07-union-types-and-retrofitted-types/introducing-union-types.typ"
#include "07-union-types-and-retrofitted-types/how-many-unions.typ"
#include "07-union-types-and-retrofitted-types/union-types-and-space.typ"
#include "07-union-types-and-retrofitted-types/if-splitting-with-control-flow.typ"
#include "07-union-types-and-retrofitted-types/if-splitting-with-control-flow-and-state.typ"
#include "07-union-types-and-retrofitted-types/the-price-of-retrofitting.typ"
#include "07-union-types-and-retrofitted-types/types-and-tags.typ"
