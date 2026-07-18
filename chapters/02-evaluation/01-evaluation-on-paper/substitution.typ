#import "/prelude.typ": *

== Substitution

By the way, observe that you didn't need to know any computer programming to answer these questions. You did something similar in middle- and high-school algebra classes. You probably learned the phrase _substitution_ for "replaced with". That's the same process we're following here. And indeed, we can think of programming as a natural outgrowth of algebra, except with much more interesting datatypes: not only numbers but also strings, images, lists, tables, vector fields, videos, and more.

Okay, so this gives us a way to implement an evaluator:

- Find a way to represent program source (e.g., a string or a tree).
- Look for the next expression to evaluate.
- Perform substitution (textually) to obtain a new program.
- Continue evaluating until there's nothing left but a value.

However, as you might have guessed, that's not how most programming languages _actually_ work: in general it would be painfully slow. So we'll have to find a better way!
