#import "/prelude.typ": *

== Recursion and Infinite Loops

We alluded, earlier, to how we can desugar more interesting features into functions and application. Let's take a look at a very specific feature: an infinite loop. Let's first confirm that we can write an infinite loop. Here's a program that does it:

```
fun f():
  f()

f()
```

But this assumes we already have recursion. Can we write it without recursion? Actually we can! We'll use historical names (`ω` is the lower-case Greek omega):

```
(let ([ω (lambda (x) (x x))])
  (ω ω))
```

Run this in Racket and confirm that it runs forever!

#callout("Do Now:")[Write a conditional type rule for `let`.]

Now let's see what happens when we try to type this. We have to provide a type annotation:

```
(let ([ω (lambda (x : ???) (x x))])
  (ω ω))
```

Historically, the overall term is called `Ω` (the capital Greek omega).

Okay, so what is the annotation? To determine a type for `x`, we have to see how it's used. It's used twice. One use is in a function application position, so we know that the type must be of the form `(T -> U)`; now we have to determine what `T` and `U` are. Let's focus on the parameter type, `T`. But what are we passing in? We're passing in `x`, whose type is `(T -> U)`. So we need a solution to the equation

`T` = `(T -> U)`

with one coming from the application position and the other from the argument position. Of course, there is no finite type that can fit this equation! Therefore, it appears that this program cannot be typed!

Of course, this is not a proof. However, there is a formal property associated with this programming language, which is called the Simply Typed Lambda Calculus (STLC): the property is called _strong normalization_, and it means that _all programs in this language terminate_.

#aside[
  If you have heard about the Halting Problem, how does that square with what you just read?
]

It may seem rather useless to have a language in which all programs terminate---you can't write an operating system, or Web server, or many other programs in such a language. However, that misses two things.

First, there are many cases where we _want_ programs to always terminate. You don't want a network packet filter or a device driver or a compiler or a type-checker or … to run forever. Of course we also want them to run quickly, but it would be nice if we had a guarantee that no matter what we did, we _cannot_ create an infinite loop. The STLC is very useful in some of these settings. Another example of a place where we want guaranteed termination is in program linking, and the module language of Standard ML is therefore built atop the STLC: it lets you even write higher-order programs, but the type language guarantees that all module compositions (linkages) will terminate.

Second, many long-running programs are actually a composition of an infinite loop and a short-running program. Think about an operating system with device drivers, a Web server with a Web application, a GUI with callbacks, etc. In each case, there is a "spine" of an infinite loop that simply keeps the program reactive, and "ribs" of short computations that do a little specific work and terminate. In fact, on the Web these programs _must_ terminate quickly, otherwise the Web browser thinks the server has hung and offers to kill the window! These kinds of _reactive systems_ are therefore a composition of a very generic infinite loop calling out to specific programs for which a termination guarantee will often be very useful.

Finally, observe that we've learned something profound. Until now, we have probably thought of types as just a convenience or as a way of eliminating basic errors. However, we have just now seen that adding a type system can _change the expressive power of a language_. That is, these types are "semantic".
