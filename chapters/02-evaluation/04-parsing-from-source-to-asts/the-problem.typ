#import "/prelude.typ": *

== The Problem

Earlier we went through the basic steps of the SImPl, but we left open a big question: how do we get programs _into_ the AST representation? Of course, the simplest way is what we already did: to write the AST constructors directly, e.g.,

```
(num 1)

(plus (num 1) (num 2))

(plus (num 1)
      (plus (num 2) (num 3)))
```

which, as we noted, has the virtue of also ignoring exactly how the program source was written.

However, this can get very tedious. We don't want to have to write `(num …)` every time we want to write a number, for instance! In particular, the more tedious it is the less likely we are to write many or complex tests, and that would be especially unfortunate. Therefore, we'd like a more convenient surface syntax, along with a _program_ to translate that into ASTs.

As we have already seen, there is a large number of surface syntaxes we can use, and we aren't even limited to textual syntax: it could be graphical; spoken; gestural (imagine you're in a virtual reality environment); and so on. As we have noted, this wide range of modalities is important---especially so if the programmer has physical constraints---but it's outside the range of our current study. Even with textual syntax, we have to deal with issues like ambiguity (e.g., order of operations in arithmetic).

In general, the process of converting the input syntax into ASTs is called _parsing_. We could write a whole booklet just on parsing…so we won't. Instead, we're going to pick one syntax that strikes a reasonable balance between convenience and simplicity, which is the parenthetical syntax of Racket, and has special support in plait. That is, we will write the above examples as

```
1
(+ 1 2)
(+ 1 (+ 2 3))
```

and see how Racket can help us make these convenient to work with. In fact, in this book we will follow a convention (that Racket doesn't care about, because it treats `()`, `[]`, and `{}` interchangeably): we'll write programs to be represented using `{}` instead of `()`. Thus, the above three programs become

```
1
{+ 1 2}
{+ 1 {+ 2 3}}
```
