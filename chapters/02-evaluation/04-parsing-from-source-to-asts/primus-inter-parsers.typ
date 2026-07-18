#import "/prelude.typ": *

== Primus Inter Parsers

#callout("Do Now:")[Think about what type we want for our parser.]

What does our parser need to produce? Whatever the calculator consumes, i.e., `Exp`. What does it consume? Program source expressions written in a "convenient" syntax, i.e., `S-Exp`. Hence, its type must be

```
(parse : (S-Exp -> Exp))
```

That is, it converts the human-friendly(ier) syntax into the computer's internal representation.

Writing this requires a certain degree of pedantry. First, we need a conditional to check what kind of s-exp we were given:

```
(define (parse s)
  (cond
    [(s-exp-number? s) …]
    [(s-exp-list? s) …]))
```

If it's a numeric s-exp, then we need to extract the number and pass it to the `num` constructor:

```
(num (s-exp->number s))
```

Otherwise, we need to extract the list and check whether the first thing in the list is an addition symbol. If it is not, we signal an error:

```
     (let ([l (s-exp->list s)])
       (if (symbol=? '+
                     (s-exp->symbol (first l)))
           …
           (error 'parse "list not an addition")))
```

Otherwise, we create a plus term by recurring on the two sub-pieces.

```
            (plus (parse (second l))
                  (parse (third l)))
```

Putting it all together:

```
(define (parse s)
  (cond
    [(s-exp-number? s)
     (num (s-exp->number s))]
    [(s-exp-list? s)
     (let ([l (s-exp->list s)])
       (if (symbol=? '+
                     (s-exp->symbol (first l)))
           (plus (parse (second l))
                 (parse (third l)))
           (error 'parse "list not an addition")))]))
```

It's all a bit much, but fortunately this is about as hard as parsing will get in this book! Everything you see from now on will basically be this same sort of pattern, which you can freely copy.

We should, of course, make sure we've got good tests for our parser. For instance:

```
(test (parse `1) (num 1))
(test (parse `2.3) (num 2.3))
(test (parse `{+ 1 2}) (plus (num 1) (num 2)))
(test (parse `{+ 1
                 {+ {+ 2 3}
                    4}})
      (plus (num 1)
            (plus (plus (num 2)
                        (num 3))
                  (num 4))))
```

#callout("Do Now:")[Are there other kinds of tests we should have written?]

We have only written _positive_ tests. We can also write _negative_ tests for situations where we expect errors:

```
(test/exn (parse `{1 + 2}) "")
```

`test/exn` takes a string that must be a substring of the error message. You might be surprised that the test above uses the empty string rather than, say, `"addition"`. Try out this example to investigate why. How can you improve your parser to address this?

Other situations we should check for include there being too few or too many sub-parts. Addition, for instance, is defined to take exactly two sub-expressions. What if a source program contains none, one, three, four, …? This is the kind of pedantry that parsing calls for.

Once we have considered these situations, we're in a happy place, because `parse` produces output that `calc` can consume. We can therefore compose the two functions! Better still, we can write a helper function that does it for us:

```
(run : (S-Exp -> Number))

(define (run s)
  (calc (parse s)))
```

So we can now rewrite our old evaluator tests in a much more convenient way:

```
(test (run `1) 1)
(test (run `2.3) 2.3)
(test (run `{+ 1 2}) 3)
(test (run `{+ {+ 1 2} 3})
      6)
(test (run `{+ 1 {+ 2 3}})
      6)
(test (run `{+ 1 {+ {+ 2 3} 4}})
      10)
```

Compare this against the `calc` tests we had earlier!
