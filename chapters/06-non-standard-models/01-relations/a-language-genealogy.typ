#import "/prelude.typ": *

== A Language Genealogy

Suppose we want to record a genealogy of programming languages and determine which languages obtained ideas from which ones. We start by recording which languages directly borrowed ideas from which ones: e.g., Java directly borrowed from C++, and C++ directly borrowed from C. From that, we can also trace the descendants down a chain of borrowing.

We will write some of these in the following, maybe peculiar, syntax:

```
borrows(A, B)
```

means that the language `A` borrows from the language `B` (i.e., `A` is newer, `B` is older). For another peculiar reason, we will write constants not as quotes but as alphanumeric strings with a _lower-case initial_. Given that, here are some facts (with `cpp` standing for C++):

```
borrows(java, cpp).
borrows(cpp, c).
borrows(c, bcpl).
borrows(pascal, algol).
```

Now we can express the notion of being a descendant: there are two ways that `A` can be a descendant of `B`. One is if `A` borrows directly from `B`. The other is if it borrows from some language `Z` that is itself a descendant of `B`. We express these two rules using this syntax:

```
descends(A, B) :- borrows(A, B).
descends(A, B) :- borrows(A, Z), descends(Z, B).
```

Congratulations, you've just written your first *Prolog* program. To see this run, you can use #link("https://swish.swi-prolog.org/")[SWI Prolog online]. But what does it mean to "run" this? Prolog answers questions: we can ask several questions like:

_Does_ `cpp` _borrow from_ `c`#emph[?]

```
borrows(cpp, c).
```

→ true

_Does_ `cpp` _borrow from_ `bcpl`#emph[?]

```
borrows(cpp, bcpl).
```

→ false

That is, we can see that Prolog is acting like a basic database. But we can do more:

_Does_ `cpp` _descend from_ `bcpl`#emph[?]

```
descends(cpp, bcpl).
```

→ true

_Does_ `bcpl` _descend from_ `cpp`#emph[?]

```
descends(bcpl, cpp).
```

→ false

Aha: so Prolog will not only query basic facts, it will also process queries through rules.

But we can actually ask Prolog more sophisticated questions that look more like function applications. Consider:

_What does_ `cpp` _borrow from?_

borrows(cpp, X).

→

*X* = c

This seems to treat borrows like a rather funny function, calling it with a _variable_ (a name that begins with a capital letter) and letting Prolog fill in the variable. Does that work only for basic definitions, or also for rules?

_What does_ `cpp` _descend from?_

descends(cpp, X).

→

*X* = c

*X* = bcpl

Oh, this is interesting! Prolog didn't return just one answer; it returned _all_ the answers. And this was done by using a _variable_ (a name that begins with a _capital letter_). This naturally suggests the question, what if we did it the other way around?

_What descends from_ `cpp`?

descends(X, cpp).

→

*X* = java

This is even stranger: it's like passing a variable as an argument and asking what inputs will produce a particular result from the function!

In fact, a function is just the wrong way to think about any of this. What is happening in Prolog is that we're defining _relations_. So borrows and descends are actually relations, where one (borrows) is defined by concrete examples and the other (descends) by abstract rules.

Once we understand these are relations, we no longer need to limit ourselves to just one source of borrowing, to better reflect reality. That is, let's say this is our set of facts:

```
borrows(java, cpp).
borrows(cpp, c).
borrows(cpp, simula).
borrows(smalltalk, simula).
borrows(self, smalltalk).
borrows(c, bcpl).
borrows(pascal, algol).
borrows(scheme, algol).
borrows(scheme, lisp).
borrows(javascript, self).
borrows(javascript, scheme).
```

Now we can ask what all languages contributed to JavaScript:

```
descends(javascript, X).
```

From this set of facts, we learn:

*X* = self

*X* = scheme

*X* = smalltalk

*X* = simula

*X* = algol

*X* = lisp

Similarly, we can ask how widely Lisp's influence spread:

```
descends(X, lisp).
```

And we learn that for this very limited set of languages:

*X* = scheme

*X* = javascript
