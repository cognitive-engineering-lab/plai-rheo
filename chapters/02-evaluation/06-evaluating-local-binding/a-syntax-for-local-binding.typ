#import "/prelude.typ": *

== A Syntax for Local Binding

Part of the problem is actually syntactic. When we write a program like the above, there's no clear beginning or ending of the scope of `y` (i.e., the region where `y` is bound). This is actually a great virtue of parenthetical syntax: it _suggests_ a clear region (between the parentheses). Of course, we have a responsibility to make sure that that's where the variable _is_ actually bound (though this is something that we'll find, in a little while, is not so trivial).

Following the syntax of Racket, we'll add a new construct to our language. At this point it's getting a bit tricky to keep track of the full syntax, so we'll use a notation called BNF (short for Backus-Naur Form). Let's start with our arithmetic language:

```
<expr> ::= <num>
         | {+ <expr> <expr>}
```

which reads as "define (`::=`) `expr` (short for expression) to be either a number or (`|`) the surface syntax consisting of an opening brace (`{`), a plus sign (`+`), an `expr`, another `expr`, and a closing brace". BNF gives us a convenient notation for the _grammar_ of a language through its concrete syntax, and our abstract syntax will usually correspond very directly to the BNF in a very natural manner. (Observe, however, that in the BNF, we simply say that each sub-expression is an `expr`, because that's all we need to know to properly form programs. However, in the AST, we give the parts different names to tell them apart.)

#callout("Notation:")[BNF is divided into _terminals_ and _non-terminals_. Non-terminals are placeholders like `expr` and `num` above: they stand for many more possibilities (an `expr` above can be replaced with one of two possibilities (for now), while there are many possible ways to write `num`s). They are given this name because the grammar doesn't "terminate" here: the name is a place-holder that can (and must) be further expanded.]

The convention is to write non-terminals inside `<`pointy brackets`>`. Terminals, in contrast, are concrete syntax, like `{`, `}`, and `+` above. They are so-called because they stand for themselves and can't be expanded further. They are sometimes also called _literals_, because they must be written literally as shown. For this reason, they are not surrounded by any decorative symbols. Everything is written literally unless it's a non-terminal, in which case it's replaced by something according to the definition of the non-terminal.

Now we can define an extended language:

```
<expr> ::= <num>
         | {+ <expr> <expr>}
         | {let1 {<var> <expr>} <expr>}
```

That is, we're adding a new language construct, `let1`, which has three parts: a variable (`var`) and two expressions (the two `expr`'s).
