#import "/prelude.typ": *

== You Get a Type! And You Get a Type! And You Get a Type!

Let's return #iconlink(<chapters:05-types:06-algebraic-datatypes>) to our non-statically-type-safe accessors in plait: e.g.,

```
(node-v : (BT -> Number))
```

In a way, it's not fair to blame the accessor: the fault is really with the constructor, because

```
(node : (Number BT BT -> BT))
```

Once the `node` constructor creates a `BT`, the information about `node`-ness is lost, and there's not much that the accessors can do. So perhaps the alternative is to _not_ create a `BT`, but instead create a value of the `node` type.

So let's start over. This time, we'll use a different typed language, Typed Racket:

```
#lang typed/racket
```

In Typed Racket, we can create products, called structures, which define a new type:

```
(struct mt ())
```

This creates a constructor with the type we'd expect:

```
> mt
- : (-> mt)
#<procedure:mt>
```

It also creates a predicate, whose type is a bit different; previously we had a function that could only take a `BT`, because it didn't make sense to apply `mt?` to any other type. Now, however, there isn't even a concept of a `BT` (yet), so `mt?` will take values of any type:

```
> mt?
- : (-> Any Boolean : mt)
#<procedure:mt?>
```

(The additional text, `: mt`, is telling us when the Boolean is true; ignore this for now.)

Now let's try to define nodes. Here we run into a problem:

```
(struct node ([v : Number] [l : 
```
