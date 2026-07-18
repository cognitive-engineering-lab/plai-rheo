#import "/prelude.typ": *

== The Design Space of Conditionals

Even the simplest conditional exposes us to many variations in language design. The intent is that test-expression is evaluated first; if it results in a true value then (only) the then-expression is evaluated, else (only) the else-expression is evaluated. (We usually refer to these two parts as _branches_, since the program's control must take one or the other.) However, even this simple construct results in at least three different, mostly independent design decisions:

1. What kind of values can the test-expression be? In some languages they must be Boolean values (two values, one representing truth and the other falsehood). In other languages this expression can evaluate to just about any value, with some set---colloquially called _truthy_---representing truth (i.e., they result in execution of the then-expression) while the remaining ones are _falsy_, meaning they cause the else-expression to run.

  Initially, it may seem attractive to design a language with several truthy and falsy values: after all, this appears to give the programmer more convenience, permitting non-Boolean-valued functions and expressions to be used in conditionals. However, this can lead to bewildering inconsistencies across languages:

  #table(
    columns: 6,
    [*Value*], [*JavaScript*], [*Perl*], [*PHP*], [*Python*], [*Ruby*],
    [`-1`], [truthy], [truthy], [truthy], [truthy], [truthy],
    [`0`], [falsy], [falsy], [falsy], [falsy], [truthy],
    [`""`], [falsy], [falsy], [falsy], [falsy], [truthy],
    [`"0"`], [truthy], [falsy], [falsy], [truthy], [truthy],
    [`NaN`], [falsy], [truthy], [truthy], [truthy], [truthy],
    [`nil`, `null`, `None`, undefined], [falsy], [falsy], [falsy], [falsy], [falsy],
    [`[]`], [truthy], [truthy], [falsy], [falsy], [truthy],
    [empty map or object], [truthy], [falsy], [falsy], [falsy], [truthy],
  )

  Of course, it need not be so complex. Scheme, for instance, has only one value that is falsy: false itself (written as `#false`). _Every_ other value is truthy. For those who value allowing non-Boolean values in conditionals, this represents an elegant trade-off: it means a function need not worry that a type-consistent value resulting from a computation might cause a conditional to reverse itself. (For instance, if a function returns strings, it need not worry that the empty string might be treated differently from every other string.) Note that Ruby, which is inspired in part by Scheme, adopted this simple model. Lua, another Scheme-inspired language, is also spartan in its falsy values.

2. What kind of terms are the branches? Some languages make a distinction between _statements_ and _expressions_; in such languages, designers need to decide which of these are permitted. In some languages, there are even two syntactic forms of conditional to reflect these two choices: e.g., in C, `if` uses statements (and does not return any value) while the "ternary operator" (`(...?...:...)`) permits expressions and returns a value.

3. If the branches are expressions and hence allowed to evaluate to values, how do the values relate? Many (but not all) languages with static type systems expect the two branches to have the same type #iconlink(<chapters:05-types:02-growing-types-division-conditionals>). Languages without static type systems usually place no restrictions.

#aside[
  While writing an earlier version of this very chapter, I stumbled on a strange bug in the Pyret programming language: all numeric s-expressions parsed as `s-num` values except `0`, which parsed as a `s-sym`. Eventually Justin Pombrio reported: "It's a silly bug with an `if` in JavaScript that's getting `0` and thinking it's false." Seems fitting.
]
