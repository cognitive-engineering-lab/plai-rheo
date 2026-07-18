#import "/prelude.typ": *

== Typing Function Definitions

Now we're ready to type `lambda`. Here, we have to be careful about how many sub-expressions there are. Given `(lambda V B)`, it is tempting to think that there are two: `V` (the formal parameter) and `B` (the body). This is wrong! The formal parameter is a literal name, _not_ an expression: we can't replace that name with some larger expression, which is what it would mean for it to be an expression. Furthermore, we can't evaluate it: it would (most likely) produce an unbound variable error, because its whole job is to _bind_ that variable, so it can't assume it has already been bound. Therefore, there is only _one_ sub-expression, the body.

Therefore, we expect to end up with a conditional rule that looks like this:

```
|- B : ???
---------------------
|- (lambda V B) : ???
```

If we think about this for a moment, we can see that there's going to be a problem.  We just said that the `lambda` introduces a binding for the variable in the `V` position. This is precisely so that the body, `B`, can make use of that variable. So let's imagine the simplest function:

```
|- x : ???
---------------------
|- (lambda x x) : ???
```

But we don't have any typing rule that covers variables! Furthermore, we have no way of knowing what the type of any old variable will be. So we have a problem.
