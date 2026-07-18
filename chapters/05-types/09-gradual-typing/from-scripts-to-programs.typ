#import "/prelude.typ": *

== From Scripts to Programs

As dynamic language programs grow, they become increasingly hard to maintain. Programmers use types to define interfaces, communicate expectations of behavior, document, and so on, and in their absence, we need several ad hoc tools. Put differently, we want "scripts" to grow up and become "programs".

Thus, one of the most visible trends in programming languages over the past ten years is dynamic languages adding a static counterpart. In principle, this is as simple as adding a type-system to an existing language. As we've already seen when discussing retrofitted types #iconlink(<chapters:05-types:07-union-types-and-retrofitted-types>), however, such a type system needs to take into account the idiomatic style of programming in the language; otherwise it would report as erroneous too many programs that are actually type-correct, and this high false-positive rate would make people not use the type system at all. Therefore, we discussed some patterns of code that need to be supported.

Another major obstacle to adoption is that people often have a large amount of code lying around, and it is simply impractical to convert all of it to a typed language in one go. In fact, some of it may not even be typeable by most reasonable type systems: e.g., the `eval` construct, which takes a _dynamic_ string (e.g., one that may be constructed on-the-fly during program execution) and runs it. By definition, we statically do not know what this string is; without knowing it, we can't possibly type it statically.

In short, there are two reasons why we cannot expect the whole program to make an instant transition from untyped to typed:

- The program is too large, and programmers have other things to do with their time.
- Some parts of the program may not even be typeable.

(You don't need `eval` to make things hard to type. Many dynamic constructs that look at program behavior and modify it have the same flavor. They enter the language because it's dynamic and doesn't have to worry about a static type discipline, and then create an obstacle for later typing.)

Despite this, type systems have been built for many real-world dynamic languages. These type systems exhibit a property called _gradual typing_: as the name suggests, you add types "gradually" to the program, hopefully making it more-and-more typed. What started out as an academic idea in the Scheme community (two papers in 2006 introduced gradual typing for Scheme) is now #link("https://en.wikipedia.org/wiki/Gradual_typing")[widely used in industry].
