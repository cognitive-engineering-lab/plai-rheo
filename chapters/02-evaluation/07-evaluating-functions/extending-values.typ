#import "/prelude.typ": *

== Extending Values

What happens when evaluating a function? Both Racket and Python seem to suggest that we return a function.

We could have no additional information about the function:

```
(define-type Value
  [numV (the-number : Number)]
  [boolV (the-boolean : Boolean)]
  [funV])
```

(That syntax means `funV` is a constructor of no parameters. It conveys no information at all other than the fact that it's a `funV`; because we can't mix types, it says, in particular, that a value is not numeric or a Boolean---and nothing more.) But now think about a program like this (assuming `x` is bound):

```
{{if0 x
      {lam x {+ x 1}}
      {lam x {- x 2}}}
 5}
```

In both cases we're going to get a `funV` value with no additional information, so when we try to perform the application, we…can't.

Instead, it's clear that the function value needs to tell us about the function. We need to know the body, because that's what we need to evaluate; but the body can (and very likely does) reference the name of the formal parameter, so we need that too. Therefore, what we really need is

```
(define-type Value
  [numV (the-number : Number)]
  [boolV (the-boolean : Boolean)]
  [funV (var : Symbol) (body : Exp)])
```

At this point, it seems like we've gone to a lot of trouble for nothing. We take numeric and Boolean values and simply re-wrap them in new constructors, and now we're doing the same thing for functions. A certain Shakespeareian play's title comes to mind.

Patience.

With what we have, we can already have a functioning interpreter. The lam case is obviously very simple:

```
    [(lamE v b) (funV v b)]
```

The application case is a bit more detailed. We need to:

+ Evaluate the function position, to figure out what kind of value it is.
+ Evaluate the argument position, since we've agreed that's what happens in SMoL.
+ Check that the function position really does evaluate to a function. If it does not, raise an error.
+ Evaluate the body of the function. But because the body can refer to the formal parameter…
+ …first make sure the formal is bound to the actual value of the argument.

Codifying this, in stages:

#code(```
    [(appE f a) @1|(let ([fv (interp f nv)]|
@1|                      [av (interp a nv)])|
@1|                  …)|]

    [(appE f a) (let ([fv (interp f nv)]
                      [av (interp a nv)])
                  @1|(type-case Value fv|
@1|                    [(funV v b) …]|
@1|                    [else (error 'app "didn't get a function")]|))]

    [(appE f a) (let ([fv (interp f nv)]
                      [av (interp a nv)])
                  (type-case Value fv
                    [(funV v b)
                     @1|(interp b …)|]
                    [else (error 'app "didn't get a function")]))]

    [(appE f a) (let ([fv (interp f nv)]
                      [av (interp a nv)])
                  (type-case Value fv
                    [(funV v b)
                     (interp b @1|(extend nv v av)|)]
                    [else (error 'app "didn't get a function")]))]
```)
