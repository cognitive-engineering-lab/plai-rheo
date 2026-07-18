#import "/prelude.typ": *

== A Truthy/Falsy Idiom

Unrelated to macros, here's something we often see in truthy/falsy languages. Consider a two-arm `or`, which we can define as a macro:

```
(define-syntax or-2
  (syntax-rules ()
    [(_ e1 e2)
     (if e1
         true
         e2)]))
```

This works well enough for

```
(or-2 true false)
(or-2 false false)
(or-2 false true)
```

However, consider a function like `member`:

```
(member 'y '(x y z))
```

When it succeeds, it doesn't just return `true`, it returns the entire rest of the list (which is a truthy value). But if we combine this with `or-2`:

```
(or-2 (member 'y '(x y z)) "not found")
```

This is clearly not the result we want: we've lost the useful return value. Instead, here's a different macro that returns rather than suppressing that result:

```
(define-syntax or-2
  (syntax-rules ()
    [(_ e1 e2)
     (if e1
         e1
         e2)]))
```

This makes

```
(or-2 (member 'y '(x y z)) "not found")
```

work as expected.
