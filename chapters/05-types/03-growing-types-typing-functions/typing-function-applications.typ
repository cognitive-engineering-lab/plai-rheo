#import "/prelude.typ": *

== Typing Function Applications

A function application expression has two parts: the function and the arguments. For simplicity, we're going to assume that we're working with single-argument functions.

#callout("Exercise:")[Extend the rules below to deal with functions of arbitrary number of parameters (formally called _arity_).]

Because functions are first-class values, the function position is itself an expression. We have to check each sub-expression before we can type the whole expression. Therefore, function applications are conditional rules with two terms in the antecedent:

```
|- F : ???    |- A : ???
------------------------
|- (F A) : ???
```

First, let's notice that functions are different kinds of values than other values: a function is not itself a number, or string, or Boolean---it may _produce_ one of those, but it is not _itself_ one of those (an important distinction). Therefore, we need a different type for functions, which reflects what functions consume and what they produce. A natural idea is to assume functions have some "function" type, here called `Fun`:

```
|- F : Fun    |- A : ???
------------------------
|- (F A) : ???
```

What do we know about the argument expression (the actual parameter)? It had better match the type demanded by the formal parameter. But how do we check that here? We've collapsed _all_ functions in the world into a single type, `Fun`. That's far too coarse.

Instead, following convention, we'll use the "arrow" syntax for functions:

```
|- F : (??? -> ???)    |- A : ???
---------------------------------
|- (F A) : ???
```

(Technically, the arrow is a _constructor_ of function types. It's a two-place constructor, for reasons we will see below.)

With this, we can now say that the function's formal parameter's type had better match up with the type of the actual argument. Which type, exactly? Functions could consume numbers, strings, even other functions…all we know is that these should be _consistent_. Notice that this is very similar to the consistency we expected of the branches of a conditional. We can again encode this by using the same placeholder in both places:

```
|- F : (T -> ???)    |- A : T
-----------------------------
|- (F A) : ???
```

Now, what about what the function returns? Again, it could return values of any type. Whatever that type is, that is what the entire application produces. Again, we use a common placeholder to reflect this:

```
|- F : (T -> U)    |- A : T
---------------------------
|- (F A) : U
```

So here's how we read this:

- Type-check the `F` position. Make sure it's a function type (`->`). Assuming it is, call the formal parameter's type `T` and the return type `U`.
- Type-check the actual parameter (the argument). Make sure it has the same type as what the function is expecting in its formal parameter.
- If both of those hold, then the function's return type is the type of the entire application.

This list of steps is what a conventional type-checker would implement. Observe that again, a type error is the result of a failure to construct a judgment. If, for instance, the actual argument's type doesn't match that of the formal parameter, then _the conditional rule above doesn't apply_ (it applies only when we can write the same type for the `T` placeholder), which is how we learn that the program has a type error.

#callout("Exercise:")[Construct an example to illustrate the above type-error case.]

#aside[
  We intentionally don't use a _numbered_ list because formally, the semantics of judgments doesn't say that these steps have to occur in this order! For instance, the argument can be type-checked before the function; if so, that determines what the placeholder `T` stands for, and the checking of `F` confirms that `F`'s type matches that.
]

Even more perversely, you can imagine checking the application, determining---from the context---what its type _needs_ to be (e.g., if it's in an addition, it had better produce a number), and using that to drive the checking of `F`. In fact, all of these things can happen if instead of a _checker_, we implement type-_inference_---as we will soon see.
