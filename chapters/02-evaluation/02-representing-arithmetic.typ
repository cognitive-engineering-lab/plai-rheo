#import "/prelude.typ": *
#show: book-style
#set document(title: [Representing Arithmetic])

= Representing Arithmetic

Let's start thinking about actually writing an evaluator. We'll start with a simple arithmetic language, and then build our way up from there. So our language will have

- numbers
- some arithmetic operations: in fact, _just_ addition

and nothing more for now, so we can focus on the basics. Over time we'll build this up.

Before we can think about the body of an evaluator, however, we need to figure out its type: in particular, what will it consume?

#include "02-representing-arithmetic/representing-programs.typ"
#include "02-representing-arithmetic/abstract-syntax.typ"
#include "02-representing-arithmetic/representing-abstract-syntax.typ"
