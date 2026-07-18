#import "/prelude.typ": *

== Generated Bindings

Now the question is, how do we type code that uses such a definition? First, let's take an inventory of all the definitions that this might create. It at least creates two _constructors_:

```
(mt : ( -> BT))
(node : (Number BT BT -> BT))
```

We have been starting our interpretation and type-checking with the empty environment, but there is no reason we need to, nor do we do so in practice: the primordial environment can contain all kinds of pre-defined values and their types. Thus, we can imagine the `define-type` above adding the above two definitions to the initial type environment, enabling uses of `mt` and `node` to be type-checked.

This much is standard across various languages. But less commonly, in plait you get two more families of functions: _predicates_ for distinguishing between the variants:

```
(mt? : (BT -> Boolean))
(node? : (BT -> Boolean))
```

and _accessors_ for getting the values out of fields:

```
(node-v : (BT -> Number))
(node-l : (BT -> BT))
(node-r : (BT -> BT))
```