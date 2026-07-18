#import "/prelude.typ": *

== What (Goes In) Else?

Until now, our `case` expressions have not had an `else` clause. One reason to do so would be if we had a variable set of members in an object, though that is probably better handled through a different representation than a conditional: a hash-table, for instance, as we've discussed above. In contrast, if an object's set of members is fixed, desugaring to a conditional works well for the purpose of illustration (because it _emphasizes_ the fixed nature of the set of member names, which a hash table leaves open to interpretation---and also error). There is, however, another reason for an `else` clause, which is to "chain" control to another, parent, object. This is called _inheritance_.

Let's return to our model of desugared objects. To implement inheritance, the object must be given "something" to which it can delegate method invocations that it does not recognize. A great deal will depend on what that "something" is.

One answer could be that it is simply another object:

```
(case m
  ...
  [else (parent-object m)])
```

Due to our representation of objects, this application effectively searches for the member in the parent object (and, presumably, recursively in its parents). If a member matching the name is found, it returns through this chain to the original call in `msg` that sought the member. If none is found, the final object presumably signals a "message not found" error.

#callout("Exercise:")[If you know what an l-value is, then you might notice that the application `(parent-object m)` is like "half a `msg`", just like an l-value was "half a value lookup". Is there any connection?]

Let's try this by extending our trees to implement another method, `size`. We'll write an "extension" (you may be tempted to say "sub-class", but hold off for now!) for each `node` and `mt` to implement the `size` method. We intend these to extend the existing definitions of `node` and `mt`, so we'll use the extension pattern described above. In other words, if we previously had the rough equivalent of this Java code:

```
class Mt   { … Mt()          { … } sum() { … } }
class Node { … Node(v, l, r) { … } sum() { … } }
```

now we want to extend it:

```
class MtSize   extends Mt   { … size() { … } … }
class NodeSize extends Node { … size() { … } … }
```

#aside[
  We're not editing the existing definitions because that is supposed to be the whole point of object inheritance: to reuse code in a black-box fashion. This also means different parties, who do not know one another, can each extend the same base code. If they had to edit the base, first they have to find out about each other, and in addition, one might dislike the edits of the other. Inheritance is meant to sidestep these issues entirely.
]

#aside[
  Relatedly, read about the #link("https://en.wikipedia.org/wiki/Fragile_base_class")[fragile base class problem].
]
