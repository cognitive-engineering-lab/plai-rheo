#import "/prelude.typ": *

== Static Type Safety

We should be troubled by the types of these accessors. They seem to indiscriminately try to pull out field values, _whether the variant has them or not_. For instance, we can write and type-check this program, which is appealing:

```
(size-correct : (BT -> Number))

(define (size-correct (t : BT))
  (if (mt? t)
      0
      (+ 1 (+ (size-correct (node-l t)) (size-correct (node-r t))))))

(test (size-correct (mt)) 0)
```

However, we can just as well type-check _this_ program:

```
(define (size-wrong (t : BT))
  (+ 1 (+ (size-wrong (node-l t)) (size-wrong (node-r t)))))
```

This should not type-check because it has a clear type-error. The type of `size-wrong` is

```
(size-wrong : (BT -> Number))
```

so it is perfectly type-correct to write:

```
(size-wrong (mt))
```

But running this, of course, results in a run-time error, the very kind of error we might have hoped the type-checker would catch.
