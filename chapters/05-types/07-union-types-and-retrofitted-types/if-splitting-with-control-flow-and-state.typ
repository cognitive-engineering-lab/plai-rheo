#import "/prelude.typ": *

== If-Splitting with Control Flow and State

Here's another program, taken from the Python 2.5.2 standard library:

```
def insort_right(a, x, lo=0, hi=None):
    if hi is None:
        hi = len(a)
    while lo < hi:
        mid = (lo+hi)//2
        if x < a[mid]: hi = mid
        else: lo = mid+1
    a.insert(lo, x)
```

This function inserts an element (`x`) into an already-sorted list (`a`). It also takes a low search interval index (`lo`), which defaults to `0`, and a high interval (`hi`), which defaults to `None`. It inserts the element into the right place in the array.

Now let's ask whether this is actually type-correct. Observe that `lo` and `hi` are used in several arithmetic operations. These are the ones we're most interested in.

If it helps, here's the code with type annotations in #link("https://github.com/facebookincubator/cinder")[Static Python]:

```
from typing import Optional

def insort_right(a, x, lo: int = 0, hi: Optional[int] = None):
    if hi is None:
        hi = len(a)
    while lo < hi:
        mid = (lo+hi)//2
        if x < a[mid]:
            hi = mid
        else:
            lo = mid+1
    a.insert(lo, x)
```

(In Static Python, `Optional[T]` is an abbreviation for `(T U None)`. So the annotation on `hi` above allows the user to pass in either an `int` or `None`. What makes the last two arguments optional is (perhaps confusingly) not the type `Optional` but rather the fact that they have default values in the function header.)

It's easier to see what's happening with `lo`: it's allowed to be optional; if the optional argument is provided, it must be an `int`; and if it's not provided, it has value `0`, which also has type `int`. So its type is effectively `(int U int)`, which is just `int`, so all uses of `lo` as an `int` are fine.

But now consider the type of `hi`. It is also optional. If it is provided, it has to be an `int`, which would be fine. But if it's _not_ provided, its value is `None`, which cannot be used in arithmetic. However, right at the top, the function checks whether it is `None` and, if so, _changes_ it to the result of `len(a)`---which is an `int`. Therefore, once the if is done, no matter which path the program takes, `hi` is an `int`. Thus, the program is actually type-safe.

That's all well and good for us to reason about by hand. However, our job is to build a type-checker that will neither reject programs needlessly nor approve type-incorrect programs. This balance is very hard to maintain.

This represents the challenge retrofitted type system designers face: they must either reject idiomatic programs or add complexity to the type system to handle them. If we reject the program, we reject many other programs like it, which are idiomatically found in many "scripting" languages. The result would be a very safe, but also very useless---indeed, safe _because_ it would be very useless---type-checker (a type-checker that rejects every program would be extremely safe…). Instead, we need an even more complicated solution than what we have seen until now.

#aside[
  See #link("https://cs.brown.edu/people/sk/Publications/Papers/Published/gsk-flow-typing-theory/")[this paper] for how to type such programs.
]
