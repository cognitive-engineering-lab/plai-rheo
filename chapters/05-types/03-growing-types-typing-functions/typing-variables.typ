#import "/prelude.typ": *

== Typing Variables

Remember how we addressed this problem in our interpreter: we had an _environment_ for recording the value bound to each variable. We will use this same idea again: we'll have a _type environment_ for recording the _type_ of each variable. That is, just as our interpreter had the type

```
(interp : (Exp Env -> Value))
```

our type-checker will have the type

```
(tc : (Exp TEnv -> Type))
```

In our type-checker notation, we will use a slightly different way of writing it, which will finally make make `|-` stop being silent and take its proper pronunciation, "proves": all type rules will have the form

```
Γ |- e : T
```

where `Γ`, the capital Greek letter gamma, is conventionally used for the environment. We read this as "the environment `Γ` proves that `e` has type `T`". So in fact there's been an environment hiding in all our judgments, but we didn't have to worry about it when we didn't have variables; but now we do, so from now on we have to make it explicit. Fortunately, in most cases the environment is unchanged, and just passes recursively to the sub-terms, as you would expect from writing the interpreter.

With this, we can write a type for variables. What is the type of a variable? It's whatever the environment says it is! We'll treat the environment as a function, so we can just write the following axiom (where `v` stands for all the syntactically valid variable names):

```
Γ |- v : Γ(v)
```
