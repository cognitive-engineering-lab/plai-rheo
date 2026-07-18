#import "/prelude.typ": *

== Back to Typing Function Definitions

Now we're in a position to fill in the holes. When we check the body of the function, we should do it in an _extended_ environment:

#code(```
Γ@1|[V <- ???]| |- B : ???
-----------------------
Γ |- (lambda V B) : ???
```)

where `Γ[V <- _] `is how we write "`Γ` is extended with `V` bound to \_": this is the same environment-extension function that we've written before, for type environments instead of value environments, but operationally the same.

Okay, but two questions: extend _which_ environment, and extend it with _what_?

Which is easy: it's the environment of the function definition (static scope!). The repetition of `Γ` in both the consequent and antecedent accomplishes that.

In terms of what:  We need to provide a type for the variable so that, when we try to look up its type, the environment can return something. But we don't know what to extend it with! The type-checker needs the _programmer to tell it_ what type the function is expecting. This is one of the reasons why programming languages expect annotations in function and method definitions. (Another---equally good---reason is because it better documents the function for people who have to use it and maintain it.)

Therefore, we have to extend the syntax of functions to include a type annotation:

```
(lambda V : T B)
```

which says that `V` is expecting to be bound to a value of type `T` in body `B`. Once we accept this modification, we can make progress on the conditional rule:

#code(```
Γ[V <- @1|T|] |- B : ???
---------------------------
Γ |- (lambda V : @1|T| B) : ???
```)

What type are we expecting for the function definition? Clearly it must be a function type:

#code(```
Γ[V <- T] |- B : ???
------------------------------------
Γ |- (lambda V : T B) : @1|(??? -> ???)|
```)

Furthermore, we know that the type expected by the function must be `T`:

#code(```
Γ[V <- T] |- B : ???
----------------------------------
Γ |- (lambda V : T B) : (@1|T| -> ???)
```)

Given a value of type `T`, the function will return whatever the body produces:

#code(```
Γ[V <- T] |- B : @1|U|
--------------------------------
Γ |- (lambda V : T B) : (T -> @1|U|)
```)

And that gives us our final rule for function definitions.
