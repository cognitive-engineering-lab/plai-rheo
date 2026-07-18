#import "/prelude.typ": *

== Typed Racket at Work

In what follows, it's critical to pay attention to the exact details of error messages!

First, let's write the following function in `#lang racket` and test it out:

```
(define (g s)
  (+ 1 (or (string->number s) 0)))
```

As we would expect,

```
> (g "5")
6
```

because the string represents a valid number,

```
> (g "hi")
1
```

because the string doesn't represent a valid number, and

```
> (g 5)
string->number: contract violation
  expected: string?
  given: 5
```

because `5` isn't a string at all.

Now let's define it in Typed Racket:

```
#lang typed/racket

(define (f [s : String]) : Number
  (+ 1 (or (string->number s) 0)))
```

The type-checker confirms that this program is well-typed.

#callout("Exercise:")[As a test, try]

```
(define (f [s : String]) : Number
  (+ 1 (string->number s)))
```

and see what happens.

Now suppose we export this function from Typed Racket:

```
(provide f)
```

and import it into the Racket module:

```
(require "typed.rkt") ;; or whatever filename you’ve chosen
```

Let's try the same three tests. Predictably, two of them work the same:

```
> (f "5")
6
> (f "hi")
1
```

The third still produces an error, but a rather different kind of error:

```
> (f 5)
f: contract violation
  expected: string?
  given: 5
  in: the 1st argument of
      (-> string? any)
  contract from: typed.rkt
  blaming: untyped.rkt
   (assuming the contract is correct)
  at: typed.rkt:5:9
```

Here's what is happening. When we export f from Typed Racket, we don't just export the function in its raw form. Rather, Typed Racket wraps the function in _contracts_ that "protect" it in a dynamic setting. Thus, it is as if the function that was exported was

```
(define (wrapped-f s)
  (if (string? s)
      (let ([b (+ 1 (or (string->number s) 0))])
        (if (number? b)
            b
            (error 'contract "returned value was not a Number")))
      (error 'contract "provided value was not a String")))
```

(with suitably different error messages). Notice that `wrapped-f` behaves exactly like our imported `f` does: the error when given `5` is from a contract check, rather than from an internal operation. Observe also that this wrapped version is quite easy to produce in a completely mechanical way, i.e., through desugaring:

#code(```
(define (f [@1|s| : @2|String|]) : @3|Number|
  @4|(+ 1 (or (string->number s) 0))|)
```)

became

#code(```
(define (wrapped-f @1|s|)
  (if (@2|string?| @1|s|)
      (let ([b @4|(+ 1 (or (string->number s) 0))|])
        (if (@3|number?| b)
            b
            (error 'contract "returned value was not a @3|Number|")))
      (error 'contract "provided value was not a @2|String|")))
```)

#callout("Exercise:")[Why do we bind `b` to the result of the body? Why not use the body expression directly?]

The point of this wrapping is to put the type annotations to work in a dynamic setting. Essentially, the programmer who has put the effort to add annotations and get the program through the type-checker gets assurance that their function will not be abused through checks that are early and more informative than an internal error (that may not even occur, depending on the inputs, leaving the error to lurk!).

Here is a more interesting example. We define the following typed function:

```
(define (h [i : (-> String Number)]) : Number
  (+ (i "5") 1))
```

Here is its Racket counterpart:

```
(define (j i)
  (+ (i "5") 1))
```

Now let's assume we are trying to use both of these from Racket. We first define a function that produces strings from strings, i.e., one that does _not_ match the function expected by either `h` or `j`:

```
(define (str-dbl s) (string-append s s))
```

Now watch what happens when we run `(j str-dbl)` and `(h str-dbl)`. Both produce a run-time error, but very different ones. The former (which is entirely in Racket) gives an error at `+`: the "doubled" string is produced and makes it as far as `+`, which reports a violation. In contrast, in the latter case, the doubled string is produced but, when it tries to return from `(i "5")`, the type `(-> String Number)` has been turned into a contract, which halts execution saying that there is a _contract_ violation!

#aside[To get a sense of Racket's contract system, see #link("https://docs.racket-lang.org/guide/contracts.html")[Contracts] in the Racket Guide.]

#callout("Exercise:")[Another interesting static-dynamic language combination is Racket with plait. plait does not try very much to accommodate Racket idioms, though it does to some extent: recall the predicates and accessors in algebraic datatypes #iconlink(<chapters:05-types:06-algebraic-datatypes>), though at the cost of static type safety. Largely, however, plait is trying to implement the Standard ML type language. Nevertheless, because plait lives in the context of Racket, its values can be exported and used from Racket. Try the above examples in plait!]
