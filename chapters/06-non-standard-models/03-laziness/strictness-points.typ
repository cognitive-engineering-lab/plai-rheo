#import "/prelude.typ": *

== Strictness Points

Coming back to our example from earlier: when we run such a program in a language with lazy evaluation, when, if ever, does all this arithmetic resolve and print a value?

Before we answer that question, let us also observe that sometimes programs can't really defer decisions indefinitely. For instance, consider this program:

```
(deffun (f x)
  (if (even? x)
      7
      11))

(f (+ 2 3))
```

What happens when we try to evaluate it? Presumably substitution reduces this to

```
(if (even? (+ 2 3))
    7
    11)
```

and now what? Presumably that could be considered "the answer", but that doesn't seem very useful; and in real programs, these terms would just grow larger and larger. Furthermore, suppose the program were

```
(deffun (fact n)
  (if (zero? n)
      1
      (* n (fact (- n 1)))))

(fact 5)
```

We can certainly produce as an answer

```
  (if (zero? 5)
      1
      (* 5 (fact (- 5 1)))))
```

but…then what? And for that matter, what is `fact` in this response? This does not seem like a very useful programming language.

Instead, lazy programming languages define certain points in the language as _strictness_ points, which are points where expressions are forced to compute and produce an answer. Different choices of strictness points will result in languages that behave slightly differently. Conventionally, the following are considered _useful_ strictness points:

+ The conditional portion of a conditional expression. This enables the language to determine which branch to take and which branch to ignore.
+ Arithmetic. This avoids long chains of computations building up.
+ The printer in an interactive environment. This makes the environment useful.

All three of these are _pragmatic_ choices. Notice that our first example above concerned the top-level printer, while the second example has to do with conditionals.

Because of these strictness points, a typical lazy language will in fact compute the programs we have seen above very similarly to an eager language. To get to something that really differentiates eagerness from laziness, we need to get to richer programs.
