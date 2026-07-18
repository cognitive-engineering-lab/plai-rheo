#import "/prelude.typ": *

== Redundancy in Languages

Where might we find such redundancy? There are several examples in real languages. For instance, many languages have both `for` and `while` loops. Consider a typical `for` loop in C:

```
for(x = 0; x < 10; x++) {
  sum += x;
}
```

This is _exactly_ the same as

```
x = 0;
while (x < 10) {
  sum += x;
  x++;
}
```

There is, in fact, a general pattern:

```
for(INITIAL; CONDITIONAL; UPDATE) {
  sum += x;
}
```

is the same (with some syntactic liberties) as

```
INITIAL;
while (CONDITIONAL) {
  sum += x;
  UPDATE;
}
```

Now imagine you're writing an interpreter for this. Clearly, the `while` loop's implementation has to make several recursive calls, iterate, check, and perhaps perform some other bookkeeping (and maybe even manage temporary scope extensions). _All_ of that work has to be _duplicated_ for `for`! Wouldn't it be much simpler to instead implement it just once, and translate the `for` body into a `while` body?

Why have both constructs at all? Because each one is convenient for different purposes. In particular, there's a certain stylistic use of `while` that would be harder to spot from a mass of `while` code that is automatically classified for us with `for`. It adds to our vocabulary as programmers. It just happens to also add to our pain as implementors. We'd like the convenience and richer vocabulary without the pain.
