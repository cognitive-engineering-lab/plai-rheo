#import "/prelude.typ": *

== A Standard Model of Types

Types can be thought of as abstractions of run-time values. That is, whereas at run-time we can have a very large number of numbers and strings and images (and two Booleans), we will collapse the distinctions _within_ these and preserve only the distinctions _between_ them. Therefore, it is instructive to start with a basic interpreter and try to build a type checker from there:

```
(define-type BinOp
  [plus])

(define-type Exp
  [binE (operator : BinOp)
        (left  : Exp)
        (right : Exp)]
  [numE (value : Number)])

(calc : (Exp -> Number))

(define (calc e)
  (type-case Exp e
    [(binE o l r)
     (type-case BinOp o
       [(plus) (+ (calc l) (calc r))])]
    [(numE v) v]))

(test (calc (binE (plus) (numE 5) (numE 6))) 11)
```

Now let's see what needs to happen with a type-checker. The label on the tin says "checker": that is, the job of a type-checker is to _pass judgment_ on programs, i.e., to determine whether or not they are type-correct. Thus, a natural type (for the type checker) would be

#code(```
(tc : (Exp -> @1|Boolean|))
```)

(In practice, of course, we would want more information in case the program is not type-correct, i.e., we'd like an error diagnostic. But we're ignoring human factors considerations here.) With this type, we can now rewrite the relevant parts of the interpreter above:

#code(```
(define (@1|tc| e)
  (type-case Exp e
    [(binE o l r)
     (type-case BinOp o
       [(plus) (@1|and| (@1|tc| l) (@1|tc| r))])]
    [(numE v) @1|#true|]))

(test (@1|tc| (binE (plus) (numE 5) (numE 6))) @1|#true|)
```)

Actually, let's peer at this for a moment. Given a number, the type-checker returns `#true`. In the recursive cases, it computes the `and` of type-checking the pieces. And that's it. Since there is no way to return `#false`, the entire type-checker must always only return `#true`. That is, every program is type-correct.

The problem is because we have only one type, numbers, and only one operation, also on numbers, so what could possibly go wrong? We need to extend the types and operations so that there are meaningful possibilities for errors. Therefore, suppose we add a `++` operation that concatenates strings.

#code(```
(define-type BinOp
  [plus] @1|[++]|)

(define-type Exp
  [binE (operator : BinOp)
        (left  : Exp)
        (right : Exp)]
  [numE (value : Number)]
  @1|[strE (value : String)]|)
```)

Various things break, and need to be fixed. How about this?

#code(```
(define (tc e)
  (type-case Exp e
    [(binE o l r)
     (type-case BinOp o
       [(plus) (and (tc l) (tc r))]
       @1|[(++)   (and (tc l) (tc r))]|)]
    [(numE v) #true]
    @1|[(strE v) #true]|))

@1|(test (tc (binE (++) (strE "hello") (strE "world"))) #true)|
```)

So this looks pretty good, right?

#callout("Do Now:")[This is not at all what we want! Write a test case that demonstrates that.]

Here are two tests that demonstrate _desirable_ behavior:

```
(test (tc (binE (++) (numE 5) (numE 6))) #false)
(test (tc (binE (plus) (strE "hello") (strE "world"))) #false)
```

The first string-concatenates two numbers, the second adds two strings. Therefore, both should be rejected by the type-checker. Yet both of them pass (i.e., the tests above fail).

What is the core problem here? It's that, given an expression, we only know _whether_ its sub-expressions typed correctly, but not _what_ their types are. That is insufficient to determine whether the current expression is type-correct. For instance, the `++` operator needs to check not only whether its two sub-expressions are well-typed, but also whether they produced strings; if they did not, then the concatenation is erroneous.

What this shows is that we need the type-checker to have a richer type: it must instead be

#code(```
(tc : (Exp -> @1|Type|))
```)

That is, the type "checker" must actually be a type _calculator_, i.e., it even more closely parallels the evaluator, just over the universe of abstracted values (types) rather than concrete ones. Following convention, however, we'll continue to call it a checker, because it _also_ checks in the process of calculating types.

In the type declaration above, `Type` is a new (`plait` type) definition that records the possible types:

```
(define-type Type [numT] [strT])
```

With this, we can rewrite our type-"checker":

```
(define (tc e)
  (type-case Exp e
    [(binE o l r)
     (type-case BinOp o
       [(plus) (if (and (numT? (tc l)) (numT? (tc r)))
                   (numT)
                   (error 'tc "not both numbers"))]
       [(++)   (if (and (strT? (tc l)) (strT? (tc r)))
                   (strT)
                   (error 'tc "not both strings"))])]
    [(numE v) (numT)]
    [(strE v) (strT)]))

(test (tc (binE (plus) (numE 5) (numE 6))) (numT))
(test (tc (binE (++) (strE "hello") (strE "world"))) (strT))

(test/exn (tc (binE (++) (numE 5) (numE 6))) "strings")
(test/exn (tc (binE (plus) (strE "hello") (strE "world"))) "numbers")
```

There are three take-aways from this:

+ The type-checker follows the same implementation schema as the interpreter: an algebraic datatype to represent the AST, and structural recursion to process it. This is the schema we're calling SImPl.
+ A type-checker, unlike an interpreter, operates with "weak" values: note, for instance, how the `numE` case ignores the actual numeric values. Both the strengths and weaknesses of traditional type-checking arise from this ignorance.
+ In mathematical terms, the upgrade we performed in going from a type-checker to a type-calculator was a process of strengthening the inductive hypothesis: instead of returning only a `Boolean`, we had to return the actual type of each expression. This may not seem like a literal strengthening; but it is inasmuch as the former `#true` has been replaced by a `Type` and the `#false` by an error.

#callout("Exercise:")[Add division to the language and type-check it.]
