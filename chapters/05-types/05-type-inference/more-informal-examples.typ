#import "/prelude.typ": *

== More Informal Examples

With that important detail out of the way, let's return to our process of _inferring_ or _reconstructing_ the types of variables from the way they're used in a program. Here's another example with a two-parameter function:

```
(lambda ((x : ___) (y : ___))
  (if x
      (+ y 1)
      (+ y 2)))
```

Once again, we can't just calculate its type with our type-checker; instead, we must reconstruct the type from the function body. Let's do that. What can we tell? Let's again refer to the conditional rule:

```
Γ |- C : Bool    Γ |- T : U    Γ |- E : U
-----------------------------------------
Γ |- (if C T E) : U
```

This tells us that what's in the `C` position---here, `x`---must be a `Bool`. Furthermore, both branches `(+ y 1)` and `(+ y 2)` must have the same type. That's all we can learn from the rule for `if`! But now we can (and must) recur into the sub-expressions. Each one is an addition, and the addition rule tells us that both arguments must be `Num`s. Both of these indicate that the type of `y` must be `Num`. Furthermore, both indicate that the overall addition returns a `Num`. From that we can tell that the entire expression must have the type

```
(Bool Num -> Num)
```

By this process, we can figure out what types to put in the missing annotations. More subtly, notice that by running through this process, we have effectively applied all the typing rules; therefore, if we have successfully reconstructed the type annotations, we need not bother type-checking the program with those annotations: it will have to type-check.

Now let's consider a slight variation on the above program:

```
(lambda (x : ___)
  (if x
      (+ x 1)
      (+ x 2)))
```

Now let's figure out everything we can learn about `x` from the function's body:

- `x` is used in the conditional position of an `if`. Therefore, it must have type `Bool`.
- `x` is used as a parameter to `+`. Therefore, it must have type `Num`.
- `x` is again used as a parameter to `+`. Therefore, it must have type `Num`.

Notice that each of these conclusions is perfectly fine on its own. However, when we _put them together_ (which is what we meant by "additional information" above), there's a problem: `x` cannot be both of those. That is, we are unable to find a single type for `x`. This inability to find a type for `x` means that the program has a _type error_. And indeed, there _is_ no type we could have given that would have enabled this program to execute safely.

Observe something subtle. While we can report that the program clearly has a type error, our error message must necessarily be much more ambiguous. Previously, when we had a type annotation on `x`, we could pinpoint where the error occurred. Now, all we can say is that the program is not type-_consistent_, but cannot blame one spot or the other without potentially misleading the programmer. Instead, we must report all these locations and let the programmer decide where the error is based on their _unstated intent_ (in the form of a type annotation).
