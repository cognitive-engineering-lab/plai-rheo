#import "/prelude.typ": *
#show: book-style
#set document(title: [How SMoL Becomes Large])

= How SMoL Becomes Large

We have already been introduced to the idea of SImPl, the Standard Implementation Plan. The core idea is that the program's syntax is represented as abstract syntax using a (mutually) recursive algebraic datatype, and we then write a similar (mutually) recursive program to process it. What that program produces depends on the process we are trying to implement: an interpreter produces _values_, a compiler produces _programs_ (in another language), a type-checker produces _judgments about type-correctness_ (and more, as we'll soon see), and so on. But they all have the same basic structure.

In practice, this means that a SImPl needs to have a case to handle each of the constructs in the language. This is not a problem in principle, but it can become onerous in practice. Suppose we have two constructs that have a lot of repetition. Not only does it mean we have to duplicate programming, it also means we have to duplicate _maintenance_: if we fix a bug in one, we have to remember to fix it in the other in the corresponding way.

#include "01-how-smol-becomes-large/redundancy-in-languages.typ"
#include "01-how-smol-becomes-large/desugaring.typ"
#include "01-how-smol-becomes-large/macros-by-example.typ"
#include "01-how-smol-becomes-large/a-new-conditional.typ"
#include "01-how-smol-becomes-large/local-binding.typ"
#include "01-how-smol-becomes-large/binding-more-locals.typ"
#include "01-how-smol-becomes-large/multi-armed-conditionals.typ"
