#import "/prelude.typ": *

== Generalizing Macros

Finally, unlike the poor programmers stuck with their infix syntaxes and binary operators, parenthetical syntax programmers can generalize constructs to arbitrary arity. We've seen `…` already; let's put it to work here to create an _n_-ary `or`. A natural first definition is

```
(define-syntax orN
  (syntax-rules ()
    [(_ e1 e2 ...)
     (let ([v e1])
       (if v v (orN e2 ...)))]))
```

#callout("Do Now:")[However,  see what happens when we try:]

```
(let ([v true])
  (orN false v))
```

Okay, so that doesn't work. It's important to pay attention to the error message:

orN: bad syntax in: (orN)

This highlights the need for a base case. The problem is our definition above requires one or more sub-expressions: `e1` is the first, and `e2 …` means _zero or more_ from the second position onward. But nothing covers the case of no sub-terms. So we need

```
(define-syntax orN
  (syntax-rules ()
    [(_) false]
    [(_ e1 e2 ...)
     (let ([v e1])
       (if v v (orN e2 ...)))]))
```

and of course this works fine.

#callout("Exercise:")[The problem above appears to have been self-inflicted: why did we start with the pattern `(_ e1 e2 ...)`, which requires one-or-more (`e1` is the first, `e2 …` is zero or more)? We should have just written `(_ e...)` instead, which would be zero-or-more! Rewrite the `orN` macro using this pattern: can you make it work?]

#callout("Note:")[You can also read more examples and details from chapter 13, "Desugaring as a Language Feature", from the second edition of this book \[#link("http://www.cs.brown.edu/courses/cs173/2012/book/book.pdf")[PDF], #link("https://cs.brown.edu/courses/cs173/2012/book/Desugaring_as_a_Language_Feature.html")[HTML]\].]
