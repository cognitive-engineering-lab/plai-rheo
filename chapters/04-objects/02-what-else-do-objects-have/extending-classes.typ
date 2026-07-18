#import "/prelude.typ": *

== Extending Classes

Now we have to port all this code over to our world of desugaring. Is this the constructor pattern?

```
(define (node/size parent-object v l r)
  ...)
```

That suggests that the parent is at the "same level" as the object's constructor fields. That seems reasonable, in that once all these parameters are given, the object is "fully defined". However, we also still have

```
(define (node v l r)
  ...)
```

The crucial issue here is that we need to make _two_ objects: one of `node/size` and one more of `node`. We could imagine a protocol where the user of `node/size` constructs a `node` object and passes it to `node/size`, but in doing so, they could make any number of mistakes. Alternatively, we can leave it to `node/size` to invoke node, and keep track of the object constructed through this process. That is, `node/size`'s parent parameter should not be the parent _object_ but rather the parent object's _maker_.

```
(define (node/size parent-maker v l r)
  (let ([parent-object (parent-maker v l r)]
        [self 'dummy])
    (begin
      (set! self
            (lambda (m)
              (case m
                [(size) (lambda () (+ 1
                                     (msg l 'size)
                                     (msg r 'size)))]
                [else (parent-object m)])))
      self)))

(define (mt/size parent-maker)
  (let ([parent-object (parent-maker)]
        [self 'dummy])
    (begin
      (set! self
            (lambda (m)
              (case m
                [(size) (lambda () 0)]
                [else (parent-object m)])))
      self)))
```

Then the object constructor must remember to pass the parent-object maker on every invocation:

```
(define a-tree/size
  (node/size node
             10
             (node/size node 5 (mt/size mt) (mt/size mt))
             (node/size node 15
                        (node/size node 6 (mt/size mt) (mt/size mt))
                        (mt/size mt))))
```

#aside[
  Note the repeated pattern of invoking the "super" class: e.g., `(mt/size mt)`. We would instead want to do this just once. Essentially, this binding of `mt/size` to `mt` is precisely what the `extends` clause of Java does. We could simulate that here, but later in this chapter we'll see a much more elegant way of achieving this end while also making programming with classes much more flexible.
]

We can confirm that both the old and new tests still work:

```
(test (msg a-tree/size 'sum) (+ 10 5 15 6))
(test (msg a-tree/size 'size) 4)
```

#callout("Exercise:")[Rewrite this block of code using self-application instead of mutation.]

What we have done is capture the essence of a class. Each function parameterized over a parent is...well, it's a bit tricky, really. Let's call it a _class extension_---we'll soon see why. A class extension corresponds to what a Java programmer defines when they write:

```
class NodeSize extends Node { ... }
```

#callout("Exercise:")[So why are we going out of the way to not call it a "class"?]

When a developer invokes a Java class's constructor, it in effect constructs objects all the way up the inheritance chain (in practice, a compiler might optimize this to require only one constructor invocation and one object allocation). These are effectively "personal" copies of the objects corresponding to the parent classes (personal, that is, up to the presence of static members). There is, however, a question of how much of these objects is visible. Java chooses that---unlike in our implementation above---only one method of a given name (and signature) remains, no matter how many there might have been on the inheritance chain, whereas every field remains in the result, and can be accessed by casting. The latter makes some sense because each field presumably has invariants governing it, so keeping them separate (and hence all present) is wise. In contrast, it is easy to imagine an implementation that also makes all the methods available, not only the ones lowest (i.e., most refined) in the inheritance hierarchy. Many scripting languages take the latter approach.

#callout("Exercise:")[The code above is not what we would _really_ want as programmers. The self-reference is to the same syntactic object, whereas it needs to refer to the most-refined object: this is known as open recursion. Modify the object representations so that self always refers to the most refined version of the object. *Hint:* You will find the self-application method (Self-Reference Without Mutation) of recursion handy.]

#aside[
  This demonstrates the other form of extensibility we get from traditional objects: _extensible recursion_.
]
