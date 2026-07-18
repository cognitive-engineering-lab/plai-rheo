#import "/prelude.typ": *
#show: book-style
#set document(title: [Evaluating Local Binding])

= Evaluating Local Binding

Most programming languages have some notion of _local binding_. There are two words there, which we'll tease apart:

- _Binding_ means to associate names with values. For instance, when we call a function, the act of calling associates ("binds") the formal parameters with the actual values.
- _Local_ means they are limited to some region of the program, and not available outside that region.

For instance, in many languages we can write something like

```
fun f(x):
  y = 2
  x + y
```

This seems clear enough. But here is a more subtle program:

```
fun f(x):
  for(y from 0 to 10):
    print(x + y)
  y
```

Is that legal? It depends on whether the `y` is still "alive" or "active" or "visible" or whatever other phrase you would like; formally, we would say, it depends on whether `y` is _in scope_. Specifically, we'd ask whether the last `y` is a _bound_ instance of the _binding_ that takes place in the `for`.

This is complicated! Many languages do rather odd, complicated, and certainly unintuitive things, as you will see from Mystery Languages. These odd things are not really part of SMoL; if anything, they are a violation of it.

#include "06-evaluating-local-binding/a-syntax-for-local-binding.typ"
#include "06-evaluating-local-binding/the-meaning-of-local-binding.typ"
#include "06-evaluating-local-binding/static-scoping.typ"
#include "06-evaluating-local-binding/an-evaluator-for-local-binding.typ"
#include "06-evaluating-local-binding/caching-substitution.typ"
