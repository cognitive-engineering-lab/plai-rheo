#import "/prelude.typ": *

== Testing the Evaluator

The examples above are fine, but we should write these in the syntax of _tests_, so that the computer checks them for us automatically:

```
(test (calc (num 1)) 1)
(test (calc (num 2.3)) 2.3)
(test (calc (plus (num 1) (num 2))) 3)
(test (calc (plus (plus (num 1) (num 2))
                  (num 3)))
      6)
(test (calc (plus (num 1)
                  (plus (num 2) (num 3))))
      6)
(test (calc (plus (num 1)
                  (plus (plus (num 2)
                              (num 3))
                        (num 4))))
      10)
```

Sure enough, when we run this, Racket confirms that all these tests pass.

#callout("Pro Tip:")[
  It can get annoying to scan through all this testing output to see whether any of the tests failed. Simply add

```
(print-only-errors #true)
```

  before your tests and Racket will suppress reporting on the passing tests, so you can focus on the ones that failed: in other words, no news is good news.
]

In general, test early, often, and extensively. Programming language evaluators translate our thoughts into computer actions. Therefore, it's critical that they do so precisely. This is why language implementations are some of the most tested software you can imagine (when's the last time you were stopped by a bug in your language implementation?), and people who will tolerate bugs in just about any other software are much less forgiving of bugs in implementations.
