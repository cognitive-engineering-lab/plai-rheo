#import "/prelude.typ": *

== Encoding Type Rules

You may have noticed that we're writing rules that are quite similar to the typing rules we've written. Let's see whether we can encode them directly.

First, we need to encode the rules for syntactic constants:

```
tc(numE, numT).
tc(strE, strT).
tc(boolE, boolT).
```

We will use the Prolog constant `numE` to stand for a syntactic numeric expression, and so on.

Now, using just what we already know, we can encode the conditional rules:

```
tc(plusE(L, R), numT) :-
    tc(L, numT),
    tc(R, numT).

tc(catE(L, R), strT) :-
    tc(L, strT),
    tc(R, strT).

tc(ifE(C, T, E), Ty) :-
    tc(C, boolT),
    tc(T, Ty),
    tc(E, Ty).
```

Note that this is literally just a syntactic transformation of the rules we wrote before!

With this, we can now use Prolog as a _checker_:

```
tc(ifE(boolE, plusE(numE, numE), numE), numT).
```

→ true

and as a _calculator_:

```
tc(ifE(boolE, plusE(numE, numE), numE), Y).
```

→

*Y* = numT

But we can do something much more intriguing: what if we leave variables in the _program_?

tc(ifE(boolE, plusE(numE, Y), numE), numT).

This is asking Prolog to _come up with programs_ that will make this program have numeric type. Prolog responds with:

*Y* *=* *numE*

*Y* *=* #emph[plusE]#strong[(]#strong[numE]#strong[,] #strong[numE]#strong[)]

*Y* *=* #emph[plusE]#strong[(]#strong[numE]#strong[,] #emph[plusE]#strong[(]#strong[numE]#strong[,] #strong[numE]#strong[))]

*Y* *=* #emph[plusE]#strong[(]#strong[numE]#strong[,] #emph[plusE]#strong[(]#strong[numE]#strong[,] #emph[plusE]#strong[(]#strong[numE]#strong[,] #strong[numE]#strong[)))]

(and many more; the structure of terms reveals something about how Prolog works). That is, Prolog is acting as a _program synthesizer_.

Now let's see how to extend this to include the type environment. For that, we have to enlarge our typing rules to include an environment as well. Recall that the environment doesn't matter for the axioms, while the other rules just pass the environment through:

```
tc(numE, _, numT).
tc(strE, _, strT).
tc(boolE, _, boolT).

tc(plusE(L, R), Env, numT) :-
    tc(L, Env, numT),
    tc(R, Env, numT).

tc(catE(L, R), Env, strT) :-
    tc(L, Env, strT),
    tc(R, Env, strT).

tc(ifE(C, T, E), Env, Ty) :-
    tc(C, Env, boolT),
    tc(T, Env, Ty),
    tc(E, Env, Ty).
```

Now let's add the three variable-oriented rules. We will use a list of `bind` relations to capture the environment. To look up a variable, we pattern-match on whether the variable is the first binding; if it is we can respond with the relevant type, otherwise we must search in the remaining bindings:

```
tc(varE(V), [bind(V, T) | _], T).

tc(varE(V), [bind(_, _) | RestTEnv], T) :-
   tc(varE(V), RestTEnv, T).
```

The Prolog notation `[ … | … ]` means to decompose a list into a first, or head, element to the left of the `|` and the rest, or tail, to the right of the `|`.

The other two rules look much more like the type rules we wrote earlier:

```
tc(lamE(V, B), TEnv, funT(A, R)) :-
    tc(B, [bind(V, A) | TEnv], R).
```

Observe that in the above rule, we have done away with the type annotation! This rule looks more like what we would write with type _inference_ than with type _checking_. Finally:

```
tc(appE(F, A), TEnv, U) :-
    tc(F, TEnv, funT(T, U)),
    tc(A, TEnv, T).
```

We can now use these definitions with the example we used for type _inference_. Let's translate this program (we have only single-argument functions) from before:

```
(lambda (v)
  (lambda (w)
    (if v
        (+ w 1)
        (+ w 2))))
```

We pass this to the `tc` relation, encoded as follows, with the type environment and result type left variable:

```
tc(lamE(v, 
     lamE(w, 
       ifE(varE(v), 
           plusE(varE(w), numE),
           plusE(varE(w), numE)))), TEnv, T)
```

Prolog produces the following output:

*T* = _funT_(boolT, _funT_(numT, numT))

In other words, it has effectively inferred the type of the function: `v` has Boolean type, `w` has numeric type, and the result of the whole expression is a number.

In other words, it has _inferred_ the types of the parameters. Now let's consider some type-erroneous programs:

```
tc(lamE(v, ifE(boolE, strE, numE)), _, _)
```

→ false

Here, Prolog tells us it can't find any variable name that would satisfy this shape of program. But if instead we give it a program with holes to fill in for expressions:

```
tc(lamE(w, ifE(A, strE, numE)), _, _)
```

Prolog tries to build bigger and bigger terms that might work, and goes into an infinite loop trying to find a program that is typeable! In general, this is a problem for synthesis systems: if the problem they are given has a solution they can often find one quickly, but if it does not have a solution, they have to spend a long time trying to find one---either very long, if it's a large but finite space to search, or infinitely long, if the space is infinite. Often, synthesizers will use heuristics to truncate this search.
