#import "/prelude.typ": *

== Another Perspective on Types

We have already seen how we can think of types as abstractions of values, and type-checking as running a program over these abstract values. As we'll soon see, the analogy will break down a bit.

Another perspective is to think of types as a _static discipline_: a way of statically making judgments about programs. In a way, we have already been doing just this: it's called _parsing_. A parser statically (i.e., before the program runs) passes judgment (i.e., decides that some programs are good and others are bad). Types can be viewed as an extension of this idea.

#aside[
  In computability theory terms, parsers are usually _context-free_, whereas types usually reflect _context-sensitive_ constraints. Computability theory then helps us understand why we might separate these checks into two separate phases, and in particular why we might do one before the other. Essentially, the type-checker only needs to deal with programs that have already passed the parsing, i.e., context-free check, so it has much less complexity than if it had to do everything. We already saw this: our previous checker only consumed `Expr`s, which are produced by the parser.
]
