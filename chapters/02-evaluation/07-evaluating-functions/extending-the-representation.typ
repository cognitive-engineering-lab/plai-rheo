#import "/prelude.typ": *

== Extending the Representation

Therefore, let's think about what it takes to evaluate functions-as-values to SMoL. We don't need functions to inherently have a name, because naming can be done by `let1`. We'll assume, for simplicity, that all functions take only one argument; extending this to multiple arguments is left as an exercise.

#callout("Exercise:")[What issues might we have to deal with when we extend functions from having one argument only to having multiple arguments?]

First, we need to extend our abstract syntax.

#callout("Do Now:")[How many new constructs do we need to add to the abstract syntax?]

When we added `let1`, you may recall that it didn't suffice to add one construct; we needed two: one for variable _binding_ and one for variable _use_. You'll often see this pattern when adding values to the language. For any new kind of value, you can expect to see one or more ways to _make_ it and one or more ways to _use_ it. (Even arithmetic: numeric constants were a way to make them, arithmetic operations consumed them---but also made them.)

Likewise with functions, we need a way to represent both

```
lam(x): x * x
```

for defining new functions, and

```
sq(3)
```

to use them.

#callout("Terminology:")[In more advanced texts, you will sometimes see the (formally correct, but perhaps slightly confusing) terms _introduction_ and _elimination_: introduction brings the new concept in, elimination uses them. Thus, the `lam` introduces new functions, and an application eliminates them.]

We therefore add

```
  [lamE (var : Symbol) (body : Exp)]
  [appE (fun : Exp) (arg : Exp)]
```

to our AST.

Let's assume we've already extended our parser, so that programs like the following are legal:

```
{let1 {f {lam x {+ x x}}}
      {f 3}}

{let1 {x 3}
      {let1 {f {lam y {+ x y}}}
            {f 3}}}
```

These parse, respectively, into

```
(let1E 'f (lamE 'x (plusE (varE 'x) (varE 'x))) 
       (appE (varE 'f) (numE 3)))

(let1E 'x (numE 3) 
       (let1E 'f (lamE 'y (plusE (varE 'x) (varE 'y))) 
              (appE (varE 'f) (numE 3))))
```

and should both evaluate to `6`.
