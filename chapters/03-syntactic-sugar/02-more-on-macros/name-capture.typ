#import "/prelude.typ": *

== Name Capture

But now, what if we use the above code in this kind of context:

```
(let ([not (λ (v) v)])
  (unless false
    (println 1)
    (println 2)))
```

This seems problematic: it seems to expand into

```
(let ([not (λ (v) v)])
  (if (not false)
      (begin
        (println 1)
        (println 2))
      (void)))
```

which is pretty much the opposite of what we want. That's because the `not` outside the macro seems to have captured the `not` inside the macro. This is roughly analogous to dynamic scope: any use context can modify what happens inside the abstraction. If this were true, it would be terrifying to be a macro writer!

#callout("Do Now:")[Run both versions. Do they produce the same answer?]

But running the macro version makes clear that the name `not` is _not_ being captured. Most of all, use the Macro Stepper to see how the expansion works. The important thing is that variables are more than just _names_; they record binding information, which keeps names introduced in different settings separate. They may print the same way, but internally Racket keeps them separate (and shows this separation in the Macro Stepper using colors). That is, it's as if we start with this program:

```
(let ([not (λ (v) v)])
  (unless false
    (println 1)
    (println 2)))
```

which, after expansion, turns into this program (which uses different colors):

```
(let ([not (λ (v) v)])
  (if (not false)
      (begin
        (println 1)
        (println 2))
      (void)))
```

So now we can easily keep the identifiers apart: the red `not` is different from the blue `not`. The actual internal representation is an efficient analog to colors. If necessary, the macro expander can also use distinct _fresh_ (i.e., previously unused) names---`not1`, `not2`, etc.---to represent the different variables of the same name.

This property, which recovers an analog of static scoping for macros, and is called _hygiene_. Hygiene is a critical feature for macros (and, notably, is one _not_ given by the C pre-processor). It lets programmers use whatever name they want in the macro definition without worrying about what names will be bound in the use context; and similarly, lets users use whatever variable names they want without worrying about the macro's code.

That said, you may wonder whether hygiene is just for built-in functions like `not`. We'll see that it's … not. But to get there, we'll work through some other idiomatic examples.
