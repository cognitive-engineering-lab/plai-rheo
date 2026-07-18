#import "/prelude.typ": *

== Typing Conditionals

Now we're ready to add a rule for `if`. As we have seen, different languages have different rules for what can go in the conditional clause. Since the goal of a type-checker is to catch type errors, it is common for languages with type-checkers to demand that the conditional be a Boolean (without a truthy/falsy set of Boolean values). Our goal here is not to make a value judgment but rather to illustrate how we would add a type rule for it.

By now, we can see that we will need a conditional rule (because we want to type-check more than just constants); following SImPl, and we will need the antecedent to say something about the sub-expressions. Clearly, we need at least:

```
|- C : Bool    …
------------------
|- (if C T E) : …
```

Okay, what now? What is the type of the entire conditional expression? Technically, it should be whatever type is returned by the branch that was executed. However, a type-checker can't know which branch will be executed; over time, both might. So we have to somehow capture the _uncertainty_ in this situation. There are two common solutions:

+ Introduce a new kind of type that stands for "this type _or_ that type" (a _union_). This is easy to introduce but creates a burden for every piece of code that will consume such a value.
+ Just rule that both branches should have the same type.

The latter is a very elegant solution, because it eliminates the uncertainty entirely.

Okay, so we need to do the following things:

- Compute the type of T.
- Compute the type of E.
- Make sure T and E have the same type.
- Make this (same) type the result of the conditional.

That seems like a lot: how will we express all that? Very easily, actually:

```
|- C : Bool    |- T : U    |- E : U
-----------------------------------
|- (if C T E) : U
```

Here, `U` is a placeholder: it isn't a concrete type but rather _stands for_ whatever type might go in that place. The repeated use of `U` accomplishes all of our goals above. Read this as: "if `C `has type `Bool` and `T` has type `U` and `E` has \[_the_ _same_\] type `U`, then `(if C T E)` has \[the same\] type `U`".

Let's see this in action on the following program:

```
(if true 1 2)
```

We get:

#code(```
@1|\|- true : Bool|    |- 1 : U    |- 2 : U
--------------------------------------
|- (if true 1 2) : U
```)

Either of the axioms for the other two antecedents tells us what U must be, which lets us fill in the result of U everywhere:

#code(```
@1|\|- true : Bool|    |- 1 : Num    |- 2 : Num
------------------------------------------
|- (if true 1 2) : Num
```)

Fortunately, the other two antecedents are also axioms:

#code(```
@1|\|- true : Bool|    @1|\|- 1 : Num|   @1| \|- 2 : Num|
------------------------------------------
|- (if true 1 2) : Num
```)

This lets us conclude that the overall term is well-typed, and that it has type `Num`.

Now let's look at:

```
(if 4 1 2)
```

Applying the conditional rule gives us:

```
|- 4 : Bool    |- 1 : U    |- 2 : U
-----------------------------------
|- (if 4 1 2) : U
```

However, we do not have any axiom or conditional rule that lets us conclude that `4` has type `Bool` (because, in fact, it does not). Therefore, we cannot complete the judgment:

#code(```
@2|\|- 4 : Bool |   |- 1 : U    |- 2 : U
-----------------------------------
|- (if 4 1 2) : U
```)

and the program is (rightly) judged to have a type error.

One last example:

```
(if true 1 "hi")
```

Again, applying the conditional rule and checking off the first antecedent:

#code(```
@1|\|- true : Bool|    |- 1 : U    |- "hi" : U
-----------------------------------------
|- (if true 1 "hi") : U
```)

But now we have a problem. If we apply the axiom for numbers, we replace all instances of `U` with `Num` to get:

#code(```
@1|\|- true : Bool |   @1|\|- 1 : Num |   @2|\|- "hi" : Num|
---------------------------------------------
|- (if true 1 "hi") : Num
```)

Maybe we just tried the wrong axiom? We do have one more option! However, it ends up with the same net effect:

#code(```
@1|\|- true : Bool|    @2|\|- 1 : Str|    @1|\|- "hi" : Str|
---------------------------------------------
|- (if true 1 "hi") : Str
```)

Because there is _no_ way to construct a judgment for this program, it too has a type error.

#callout("Exercise:")[Let's now add functions. We need two new constructs: one to introduce them (`lambda`) and one to use them (function application). Write down judgments for each. *Hint:* You may need to revisit the set of types, too.]

Observe that because `let` desugars into `lambda`, once we have this, in principle we also have a conditional rule for `let`. (For more sophisticated language constructs this is not so straightforward; #link("https://cs.brown.edu/~sk/Publications/Papers/Published/pk-resuarging-types/")[this paper] works out some of the details.)

#callout("Exercise:")[Add desugaring to the type-checker.]
