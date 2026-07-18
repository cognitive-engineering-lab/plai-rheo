#import "/prelude.typ": *

== S-Expressions

There is a name for this syntax: these are called _s-expressions_ (the _s-_ is for historical reasons). In plait, we will write these expressions _preceded by a back-tick_ (#raw("`")). A back-tick followed by a Racket term is of type `S-Exp`. Here are examples of s-expressions:

```
`1
`2.3
`-40
```

These are all numeric s-expressions. We can also write

```
`{+ 1 2}
`{+ 1 {+ 2 3}}
```

It's not obvious, but these are actually _list_ s-expressions. We can tell by asking

```
> (s-exp-list? `1)
- Boolean
#f
> (s-exp-list? `{+ 1 2})
- Boolean
#t
> (s-exp-list? `{+ 1 {+ 2 3}})
- Boolean
#t
```

So the first is not but the second two are; similarly,

```
> (s-exp-number? `1)
- Boolean
#t
> (s-exp-number? `{+ 1 {+ 2 3}})
- Boolean
#f
```

The `S-Exp` type is a container around the actual number or list, which we can extract:

```
> (s-exp->number `1)
- Number
1
> (s-exp->list `{+ 1 2})
- (Listof S-Exp)
(list `+ `1 `2)
```

#callout("Do Now:")[What happens if you apply `s-exp->number` to a list s-exp or `s-exp->list` to a number s-expression? Or either to something that isn't an s-expression at all? Try it right now and find out! Do you get somewhat different results?]

Let's look at that last output above a bit more closely. The resulting list has three elements, two of which are numbers, but the third is something else:

```
`+
```

is a _symbol_ s-expression. Symbols are like strings but somewhat different in operations and performance. Whereas there are numerous string operations (like substrings), symbols are treated atomically; other than being converted to strings, the only other operation they support is equality. But in return, symbols can be checked for equality in _constant_ time.

Symbols have the same syntax as Racket variables, and hence are perfect for representing variable-like things. Thus

```
> (s-exp-symbol? `+)
- Boolean
#t
> (s-exp->symbol `+)
- Symbol
'+
```

This output shows how symbols are written in Racket: with a single-quote (`'`).

There are other kinds of s-expressions as well, but this is all we need for now! With this, we can write our first parser!
