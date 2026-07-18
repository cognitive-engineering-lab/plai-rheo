#import "/prelude.typ": *

== Return to Static Scope

#callout("Exercise:")[Run the following programs in the Stacker.]

So how do we fix this? The examples above actually give us a clue, but there is another source of inspiration as well. Do you remember that we started with _substitution_? We'll walk through these examples in Racket, so that you can run each of them directly and check that they produce the same answer. Consider again this program:

```
(let ([x 1])
  (let ([f (lambda (y) x)])
    (let ([x 2])
      (f 10))))
```

Substituting `1` for `x` produces:

```
  (let ([f (lambda (y) 1)])
    (let ([x 2])
      (f 10)))
```

Substituting `f` produces:

```
    (let ([x 2])
      ((lambda (y) 1) 10))
```

Finally, substituting `x` with `2` produces (note that there are no `x`s left in the program!):

```
      ((lambda (y) 1) 10)
```

When you see it this way, it's clear _why_ the later binding of `x` should have no impact: it's a different `x`, and the earlier `x` has effectively already been substituted. Since we have agreed that substitution is how we want our programs to work, our job now is to make sure that the environment actually implements that _correctly_.

The way to do it is to recognize that the environment represents the substitutions waiting to happen, and just _remember_ them. That is, our representation of a function needs to also keep track of the environment at the moment of function creation:

#code(```
(define-type Value
  [numV (the-number : Number)]
  [boolV (the-boolean : Boolean)]
  [funV (var : Symbol) (body : Exp) @1|(nv : Env)|])
```)

This new and richer kind of `funV` value has a special name: it's called a _closure_. That's because the expression is "closed" over the environment in which it was defined.

#callout("Terminology:")[A _closed_ term is one that has no unbound variables. The body of a function may have unbound variables---like `x` above---but the closure makes sure that they aren't _really_ unbound, because they can get their values from the stored environment.]

#callout("Quote:")["Save the environment! Create a closure today!" ---#link("https://users.soe.ucsc.edu/~cormac/")[Cormac Flanagan]]

#callout("Quote:")["Lambdas are relegated to relative obscurity until Java makes them popular by not having them." *---*James Iry, #link("http://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html")[A Brief, Incomplete, and Mostly Wrong History of Programming Languages]]

That means, when we create a closure, we have to record the environment at the time of its creation:

#code(```
    [(lamE v b) (funV v b @1|nv|)]
```)

Finally, when we use a function (represented by a closure), we have to make sure we use the _stored_ environment, not the one present at the point of calling the function, which is the _dynamic_ one:

#code(```
    [(appE f a) (let ([fv (interp f nv)]
                      [av (interp a nv)])
                  (type-case Value fv
                    [(funV v b @1|nv|)
                     (interp b (extend nv v av))]
                    [else (error 'app "didn't get a function")]))]
```)

Just to be clear: in the code above, the `nv` in the `funV` case _intentionally shadows_ the `nv` bound at the top of the interpreter. Thus, the call to `extend` extends the environment _from the closure_, rather than the one present at the point of the call.

#callout("Exercise:")[Notice that the function and argument expressions (`f` and `a`, respectively) are evaluated in the environment given to the interpreter, not the one inside the closure. Is this correct? Or should they be using the closure's environment?]

You can do two things: argue from first principles or argue with examples. In the latter case, you would modify the interpreter to make the other choice. You would then use a sample input that produces different answers depending on which environment is used, indicate which one is correct (showing what the equivalent Racket program would produce can be a good argument), and use that to justify the chosen environment. *Hint:* One of these you will need to argue from first principles, the other you should be able to argue using a program.
