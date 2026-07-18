#import "/prelude.typ": *
#show: book-style
#set document(title: [Growing Types: Typing Functions])

= Growing Types: Typing Functions

Now we're ready to grow our language further, to include functions. As we've noted before, concepts like functions come in pairs: a way to introduce them and a way to use ("eliminate") them. As in our interpreter, we'll use a `lambda` form to represent the former and application for the latter. We've already seen that once we have `lambda`, we use syntactic sugar to obtain other forms like `let`, so this suffices for our core language. (Mostly, as we'll see…)

So we have to come up with typing rules for application and `lambda`. Let's do them in that order.

#include "03-growing-types-typing-functions/typing-function-applications.typ"
#include "03-growing-types-typing-functions/typing-function-definitions.typ"
#include "03-growing-types-typing-functions/typing-variables.typ"
#include "03-growing-types-typing-functions/back-to-typing-function-definitions.typ"
#include "03-growing-types-typing-functions/more-divergence-between-types-and-evaluation.typ"
#include "03-growing-types-typing-functions/assume-guarantee-reasoning.typ"
#include "03-growing-types-typing-functions/recursion-and-infinite-loops.typ"
#include "03-growing-types-typing-functions/typing-recursion.typ"
