#import "/prelude.typ": *

== Mapping between Web and Programming Language Features

Interestingly, there is a deep connection between features of Web programs and ideas from programming languages. On the Web, we have

#table(
  columns: 3,
  [], [*Server-side*], [*Client-side*],
  [*Mutable*], [Database (page-independent)], [Cookie (page-independent)],
  [*Immutable*], [], [Hidden field (page-specific)],
)

Observe that when we have a single mutable entry, the net result will be that all pages that share it will end up seeing the effects of each other. Therefore, the bad travel Web site pattern is inherent in this style of programming. Unfortunately, Web APIs make cookies very easy to use, leading to programs following this bad pattern. In contrast, when we have immutable data that is specific to the page (the field is on the page…it's just hidden), then each page keeps its own information separate from all the other pages. Notice also that hidden fields are key-value mappings. Therefore, a collection of hidden fields is an _environment_. Since a page also has a reference to code to run, a page with hidden fields is effectively a _closure_! In contrast, a page with shared mutable state is using the _store_ (or _heap_). The Racket Web server simply makes these implicit ideas explicit.
