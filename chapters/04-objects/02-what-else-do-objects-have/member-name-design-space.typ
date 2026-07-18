#import "/prelude.typ": *

== Member Name Design Space

Now we will focus on the names of members (a term we use to not distinguish between fields and methods). Also, let's set aside the distinction between classes and objects for a moment: whether through classes or not, we eventually end up with objects, which programs use. So the two questions are:

- Is the set of member names statically fixed, or can it be changed dynamically?
- Is the member being accessed at a point statically fixed, or can it be computed dynamically?

This gives us a 2x2 table, and it's worthwhile to ask whether each cell makes sense (and whether we've seen it in any real languages). We get:

#table(
  columns: 3,
  [], [*Name is Static*], [*Name is Computed*],
  [*Fixed Set of Members*], [As in base Java.], [As in Java with reflection to compute the name.],
  [*Variable Set of Members*], [Difficult to envision (what use would it be?).], [Most "scripting" languages.],
)

Only one case does not quite make sense: if the member being accessed must be fixed in the source program, then the set of names is pre-decided, so it doesn't seem to make sense to be able to dynamically change the set of members (new members would not be accessible, while deleted members would cause some existing accesses to fail). All other points in this design space have, however, been explored by languages.

The lower-right quadrant corresponds closely with languages that use hash-tables to represent objects. Then the name is simply the index into the hash-table. Some languages carry this to an extreme and use the same representation even for numeric indices, thereby (for instance) conflating objects with dictionaries and even arrays. Even when the object only handles "member names", this style of object creates significant difficulty for type-checking and is hence not automatically desirable.

Therefore, in the rest of this section, we will stick with "traditional" objects that have a fixed set of names and even static member name references (the top-left quadrant). Even then, we will find there is much, much more to study.
