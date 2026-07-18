#import "/prelude.typ": *

== A Concise Notation

As we extend our type system, it is increasingly unwieldy to write everything out as code. Instead, we will adopt a notation commonly used in the world of types (though it can also be used for interpreters and other SImPl programs). We will write terms of the form

```
|- e : T
```

where the `e` are expressions, `T` are types, and `:` is pronounced as "has type": i.e., the notation above says "`e` has type `T`". For now we won't pronounce `|-` as anything at all; later, we will see that it should be read as "proves".

First, we can very concisely say that all numeric expressions have numeric type and all string expressions have string type:

```
|- n : Num
|- s : Str
```

where `n` stands for all the syntactic terms with the syntax of numbers, and `s` likewise for strings. (We can think of this as an infinite number of rules, one for each number and each string. We're in the realm of mathematics, so what's an infinite number of rules between friends?) The former is exactly equivalent to writing

```
    [(numC n) (numT)]
```

but much more concisely.

When we get to Booleans, we have a choice: we can either write

```
|- b : Bool
```

where `b` stands for all the syntactic terms with the syntax of Booleans, or---because there are only two of them---just enumerate them explicitly:

```
|- true : Bool
|- false : Bool
```

Okay, so these correspond to the base cases of the type-checker. These are called _axioms_. Now let's get to the _conditional_ cases, which are called _(typing) rules_. Remember our code for typing addition:

```
       [(plus) (if (and (numT? (tc l)) (numT? (tc r)))
                   (numT)
                   (error 'tc "not both numbers"))]
```

We can write it in this notation very concisely as follows:

```
|- e1 : Num    |- e2 : Num
--------------------------
|- (+ e1 e2) : Num
```

We read the line as "if (what's above) then (what's below)", and the space as "and". So this says: "if `e1` has type `Num` and `e2` has type `Num`, then `(+ e1 e2)` has type `Num`". This is of course the exact same thing the code says, but with rather less noise.

#callout("Terminology:")[The part above is called the _antecedent_ (that which goes before) and the part below is called the _consequent_ (that which comes after). Don't call these the numerator and denominator!]
