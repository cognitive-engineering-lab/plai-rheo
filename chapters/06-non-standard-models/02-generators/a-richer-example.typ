#import "/prelude.typ": *

== A Richer Example

Using what we have learned, let us consider another Python example:

```
def nats():
  n = 0
  while True:
    yield n
    n += 1

def odds():
  ns = nats()
  while True:
    n = next(ns)
    if n % 2:
      yield n

g = odds()

next(g) + next(g) + next(g)
```

This program has two distinct generator creators: the one we've already seen for natural numbers, and one more that filters the natural numbers to produce only odd numbers.

We can now think of control proceeding as follows. First, we make an instance of `odds` and bind it to `g`. This immediately creates an instance of `nats` and binds it (within the instance of `odds`) to `ns`. Now all our generators are set up and ready to compute.

We now begin the infinite loop in `odds`. This calls the natural number generator. At this point, the odd number generator's local stack looks like

```
while True:
  n = •
  if n % 2:
    yield n
```

in an environment where `ns` is bound to a generator and `n` is uninitialized

Because we have called a generator, not a function, computation now runs in that generator's own stack. This is the natural number generator, which we have already studied. It binds `n` to `0` and then `yield`s, storing its local stack---

```
while True:
  •
  n += 1
```

in an environment where `n` is bound to `0`

---and returning `0` to the odd number generator.

This resumes the odd generator's stack. This binds n to 0 and performs the comparison. It fails, continuing the loop body:

```
    n = next(ns)
    if n % 2:
      yield n
```

Now we are again ready to invoke the natural number generator. The odd number generator's _local_ stack is unchanged from before (same context, same environment, except this time the environment does have a binding for `n`, to `0`). Meanwhile, the natural's generator resumes from

```
while True:
  •
  n += 1
```

in an environment where `n` is bound to `0`

This increments `n` and resumes the loop body:

```
    yield n
    n += 1
```

This immediately causes it to yield `1`, leaving the stack

```
while True:
  •
  n += 1
```

in an environment where `n` is bound to `1`

This resumes the odd generator's stack. This binds `n` to `1`, so the conditional succeeds. Therefore, the stack at the point of yielding becomes

```
  while True:
    n = next(ns)
    if n % 2:
      •
```

in an environment where `ns` is bound to a generator and `n` is bound to `1`

This completes the first call to `next(g)`, enabling the top-level stack frame to have the context

```
1 + • + next(g)
```

From this, we can see the next two computations will produce `3` and `5`, and hence the total of `9`.
