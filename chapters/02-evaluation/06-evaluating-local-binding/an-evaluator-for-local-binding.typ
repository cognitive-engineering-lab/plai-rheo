#import "/prelude.typ": *

== An Evaluator for Local Binding

Now that we've seen what behavior we want, we should implement it. That is, we'll extend our calculator to handle local binding (a feature you may well have wished your calculator had). To reflect that our calculator is growing up, from now on we'll call it an _interpreter_, abbreviated in code to `interp`.

Let's start with the new AST. For simplicity, we'll ignore conditionals, which are anyway orthogonal to our goal of handling local binding. Recall that we added two new branches to the BNF, so we'll want two new corresponding branches to the AST:

```
(define-type Exp
  [numE (n : Number)]
  [plusE (left : Exp) (right : Exp)]
  [varE (name : Symbol)]
  [let1E (var : Symbol)
         (value : Exp)
         (body : Exp)])
```

We can also copy over our previous calculator, but we pretty quickly run into trouble:

```
(define (interp e)
  (type-case (Exp) e
    [(numE n) n]
    [(varE s) …]
    [(plusE l r) (+ (interp l) (interp r))]
    [(let1E var val body) …]))
```

What do we do when we encounter a `let1E`? For that matter, what do we do when we encounter a variable? In fact, these two should be intimately connected: the variable binding introduced by the former should substitute the variable use in the latter.
