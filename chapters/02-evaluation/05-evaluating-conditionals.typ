#import "/prelude.typ": *
#show: book-style
#set document(title: [Evaluating Conditionals])

= Evaluating Conditionals

So far our language has had only arithmetic. Building on Mystery Language: Conditionals, we will now examine how to extend our language to also support conditionals. There can be quite complex conditional expressions in real languages, but for our purposes it will suffice to have an `if` with three parts: the conditional, the then-branch, and the else-branch. Later, when we learn how to extend the language, we can see how to layer more sophisticated conditional expressions atop this.

In SImPl, we have to do at least two things:

+ Extend the datatype representing expressions to include conditionals.
+ Extend the evaluator to handle (the representation of) these new expressions.

Optionally, if we have a parser, we should also

+ Extend the parser to produce these new representations.

#include "05-evaluating-conditionals/extending-the-ast.typ"
#include "05-evaluating-conditionals/extending-the-calculator.typ"
#include "05-evaluating-conditionals/the-design-space-of-conditionals.typ"
#include "05-evaluating-conditionals/using-truthy-falsy-values.typ"
#include "05-evaluating-conditionals/implementing-conditionals.typ"
#include "05-evaluating-conditionals/adding-booleans.typ"
#include "05-evaluating-conditionals/the-value-datatype.typ"
#include "05-evaluating-conditionals/updating-the-evaluator.typ"
