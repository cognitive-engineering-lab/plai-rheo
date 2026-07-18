#import "/prelude.typ": *

== Representing Programs

Well, what _does_ an evaluator consume? It consumes *programs*. So we need to figure out how to _represent programs_.

Of course, computers represent programs all the time. When we're writing code, our text editor holds the program source. Every executable on disk and in memory is a representation of a program. When we visit a Web page, it sends down a JavaScript program. These are all programs represented in the computer. But all these are a bit inconvenient for our needs, and we'll come up with a better representation in a moment.

Before thinking about represent#emph[ations], let's think about what we're represent#emph[ing]. Here are some example (arithmetic) programs:

```
1
0
-1
2.3
1 + 2
3 + 4
```

Already we have a question. How should we _write_ our program? You can see where this is going: should we be writing the sum of 1 and 2 as

```
1 + 2
```

or as

```
(+ 1 2)
+ 1 2
1 2 +
```

and so on. (For that matter, we can even ask what numeral system to use for basic numbers: e..g, should we write `3` or `III`? You can #link("https://github.com/shriram/roman-numerals")[program with the latter] if you'd really like to.)

These are questions of what _surface syntax_ to use. And they are very important! And interesting! And important! People get really attached to some surface syntaxes over the other (you may already be having some feelings about Racket's parenthetical syntax…I certainly do). You can even write that expression as

#image("/images/image11.png", width: 158pt)

in Scratch and Snap!, and this syntax has been invaluable in getting young children to learn how to program without all the vagaries of textual syntax.

Thus, these are great human-factors considerations. But for now these are a distraction in terms of getting to understand the _models_ underlying languages. Therefore, we need a way to represent all these different programs in a way that ignores these distinctions.
