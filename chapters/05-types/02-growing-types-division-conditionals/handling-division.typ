#import "/prelude.typ": *

== Handling Division

Addition, multiplication, and subtraction are _total_ functions over numbers: they consume two numbers and produce one. In contrast, division is a _partial_ function: it isn't defined when the denominator is zero. Therefore, we need a strategy for handling it. There are several available strategies:

+ We can declare that division doesn't _return_ a number but instead something else that captures its partiality, such as `(Optionof Number)`. This can work just fine. However, it means every single use of division will need to check whether it obtained a proper number or not. This can get quite onerous.
+ We can declare that division only _consumes_ non-zero numbers in its second argument. This is a major change to our type system, because until now we had lumped all numbers together into a single numeric type. This now affects all callers of division, who must now prove that they are not calling it on zero as the second argument. This is onerous in a different way. Observe that the type checker cannot automatically prove that a value is non-zero without error, because this is not decidable (see #link("https://en.wikipedia.org/wiki/Rice%27s_theorem")[Rice's Theorem]).
+ We give it the same type as other binary numeric operations, and declare that the exceptional case will be handled by an exception or error. This implicitly puts the burden on the rest of the program, which must be aware of this possibility and handle it.

For more about general strategies for handling partial functions, see

#link("https://dcic-world.org/2025-02-09/partial-domains.html")[https://dcic-world.org/2025-02-09/partial-domains.html]

Most programming languages have taken the third option above, which seems the most pragmatic. However, a growing number of languages are exploring the first two options. They get around Rice's Theorem in the second case by trying to prove non-zero-ness and, when they cannot, putting the burden on the programmer. While this creates more effort for the programmer, it increases the program's robustness.
