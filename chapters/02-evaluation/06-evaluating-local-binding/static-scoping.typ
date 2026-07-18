#import "/prelude.typ": *

== Static Scoping

The program

```
{let1 {x 1}
  {+ {let1 {x 2} x}
     x}}
```

introduces us to a very important concept: indeed, one of the central ideas behind SMoL. This is that a variable's binding is determined by _its position in the source program_, and *not* by _the order of the program's execution_. That is, the `x` on the last line is bound by the same place---and hence obtains the same value---irrespective of other bindings that took place before it was evaluated. To understand this better, let's see a progression of programs:

```
{let1 {x 1}
  {+ {let1 {x 2} x}
     x}}
```

You might think it's okay whether it produces `3` or `4`. How about this?

```
{let1 {x 1}
  {+ {if true
         {let1 {x 2} x}
         4}
      x}}
```

You should expect the same out of this: the conditional is always true, so clearly we are always going to evaluate the inner binding, so its answer should be the same as for the previous program. But how about this?

#code(```
{let1 {x 1}
  {+ {if true
         4
         @1|{let1 {x 2} x}|}
      x}}
```)

Now you might not be so sure. Since the conditional is never taken, you probably don't want the inner binding to have an influence. That is, you are willing to _let the program's control flow influence the bindings_. On its face that sounds reasonable, but now how about this program?

#code(```
{let1 {x 1}
  {+ {if @1|{random}|
         4
         {let1 {x 2} x}}
      x}}
```)

or

#code(```
{let1 {x 1}
  {+ {if @1|{moon-is-currently-full}|
         4
         {let1 {x 2} x}}
      x}}
```)

Are you okay with the binding structure changing every two weeks? What about this version:

#code(```
{let1 {x 1}
  {+ {if {moon-is-currently-full}
         4
         {let1 {@1|y| 2} x}}
      @1|y|}}
```)

Then, depending on the phase of the moon, the program either produces an answer or results in an unbound-variable error.

There are a few different concepts caught up in the above sequence of code. Some of these---letting the control flow determine binding---are variants of _dynamic scope_. Dynamic scope is one of the *unambiguously wrong* design decisions in programming languages. It has a long and sordid history: the original Lisp had it, and it was not until over a decade later that Scheme fixed it. (Unfortunately, those who don't know history are doomed to repeat it: early versions of Python and JavaScript also had forms of dynamic scope. Taking it back out has been a herculean effort.) In the programs above, we can't be sure about the binding structure of our programs just by looking at them.

However, we aren't the only entities that "look" at programs: so do our programming tools! For instance, a program refactoring tool needs to know binding structure: even a simple "variable renaming" tool needs to know which variables to rename. In DrRacket, there is no ambiguity, so variable renaming works correctly. This is not true in other languages: see, for instance, Appendix 2 of #link("https://cs.brown.edu/~sk/Publications/Papers/Published/pmmwplck-python-full-monty/")[this paper] on the semantics of Python.

In contrast, what we want is a system where we can determine the binding by following the structure of the AST: what is called _static scope_. Then we don't need to know how a program will run---which may involve references to random numbers or phases of the moon---to understand the scoping structure. This enables, for instance, an IDE to draw arrows between bound and binding instances, and to rename them. _Static scope is a defining characteristic of SMoL._

Early languages had dynamic scope because it was easy to obtain in the implementation: it was the default behavior. We have to work a bit harder to implement static scope, as we will see.
