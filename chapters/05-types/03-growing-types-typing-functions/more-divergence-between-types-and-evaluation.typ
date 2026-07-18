#import "/prelude.typ": *

== More Divergence Between Types and Evaluation

It is interesting to contrast the above pair of typing rules with the corresponding evaluation rules. In the evaluator, we visit the body of the function on every _application_---which could be as many as an infinite number of times in a program. In contrast, we visit the body of the function on _definition_, which happens only once. Therefore, even if the program runs forever, the type-checker is guaranteed to terminate!

Why can we get away with this? The evaluator has to run the body with the _specific_ value it was given. The type-checker, however, has abstracted the concrete values away. Therefore, it only needs to make one pass through the body with the "abstract value", the type.

#aside[
  Earlier, when we proposed the type `Fun`, we said that it collapsed all functions in the world into one type. This was too coarse, and we had to refine the type of a function. However, we are _still_ collapsing an infinite number of functions into each of those function types---just as we collapse an infinite number of strings into `Str`, and so on. Both the strength and weakness of type-checking lies in this collapsing.
]

For the same reason, observe that a function application rule only cares about the _type_ of the function, not _which_ specific function is being applied. Therefore, any function that has that type can be used. For that same reason, the type-checker _cannot_ traverse the function's body at application time---it doesn't even know which function might be used! All communication between the function body and application must happen entirely through the type boundary.
