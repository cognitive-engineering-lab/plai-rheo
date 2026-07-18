#import "/prelude.typ": *

== Abstract Syntax

This leads us to the first part of SImPl (the Standard Implementation Plan): the creation of what is called _abstract syntax_. In abstract syntax, we represent the essence of the input, ignoring the superficial syntactic details. Thus, in abstract syntax, all of the above programs will have the exact same representation.

An abstract syntax is an in-computer representation of programs. There are many kinds of data we can use as a representation, so let's think about the kinds of programs we might want to represent. For simplicity, we'll assume that our language has only numbers and addition; once we can handle that, it'll be easy to handle additional operations. Here are some sample (surface syntax) programs:

```
1
2.3
1 + 2
1 + 2 + 3
1 + 2 + 3 + 4
```

In conventional arithmetic notation, of course, we have to worry about the order of operations and what operations take precedence over what others. In abstract syntax, that's another detail we want to ignore; we'll instead assume that we are working internally with the equivalent of fully-parenthesized expressions, where all these issues have been resolved. Thus, it's as if the last two expressions above were written as

`(1 + 2) + 3` or `1 + (2 + 3)`

```
1 + ((2 + 3) + 4)
```

Observe, then, that each side of the addition operation can be a full-blown expression in its own right. This gives us a strong hint as to what kind of representation to use internally: a _tree_. Indeed, it's so common to use _abstract syntax trees_ that the abbreviation, AST, is routinely used without explanation; you can expect to see it in books, papers, blog posts, etc. on this topic.

You have quite possibly seen this idea before: it's called _sentence diagramming_ (read more on #link("https://en.wikipedia.org/wiki/Sentence_diagram")[Wikipedia]). Here, for instance, is a diagram of the sentence "He studies linguistics at the university":

#centered(image("/images/image1.png", width: 243pt))

#centered[#emph[By Xbarst1.jpg: Russky1802 derivative work: Maxdamantus - This file was derived from: Xbarst1.jpg:, Public Domain, https://commons.wikimedia.org/w/index.php?curid=21979041]]

An NP is a Noun Phrase, V is a Verb, and so on. Observe how the sentence diagram takes a _linear_ sentence and turns it into a _tree-shaped_ representation of the grammatical structure. We want to do the same for programs.
