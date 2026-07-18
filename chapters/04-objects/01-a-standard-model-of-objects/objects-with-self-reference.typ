#import "/prelude.typ": *

== Objects with Self Reference

Until now, our objects have simply been packages of named functions: functions with multiple named entry-points, if you will. We've seen that many of the features considered important in object systems are actually simple patterns over functions and scope, and have indeed been used---without names assigned to them---for decades by programmers armed with lambdas.

What this means is that the different members are actually independent of each other: they can't, for instance, directly reference one another. This is too limiting for a true object system, where a method has a way of referencing the object it is part of so that it can use other members of that object. To enable this, many object systems automatically equip each object with a reference to itself, often called `self` or `this`. Can we implement this?

*Aside*: I prefer this slightly dry way of putting it to the anthropomorphic "knows about itself" terminology often adopted by object advocates. Indeed, note that we have gotten this far into object system properties without ever needing to resort to anthropomorphism.

Self-Reference Using Mutation

Yes, we can! This relies on a pattern that sets up the name for the recursive reference, then uses that to create the body that will employ the recursion, and finally uses mutation to make the name refer to the defined body. For simplicity, we will go back to the #emph[object] pattern, ignoring the class-related features:

```
(define o-self!
  (let ([self 'dummy])
    (begin
      (set! self
            (lambda (m)
              (case m
                [(first) (lambda (x) (msg self 'second (+ x 1)))]
                [(second) (lambda (x) (+ x 1))])))
      self)))
```

We can test it by having `first` invoke `second`. Sure enough, this produces the expected answer:

```
(test (msg o-self! 'first 5) 7)
```

Here is the above program translated into the simpler smol/fun language. Once translated, we can run it in the Stacker:

```
#lang stacker/smol/hof

(defvar o-self!
  (let ([self 0])
    (begin
      (set! self
            (lambda (m)
              (if (equal? m "first")
                  (lambda (x) ((self "second") (+ x 1)))
                  (if (equal? m "second")
                      (lambda (x) (+ x 1))
                      (error "no such member")))))
      self)))

((o-self! "first") 5)
```

Run it for yourself! What do you learn from it? Do you see how `self` works?

#aside[This pattern---of binding a variable to a dummy value (so that it is visible), then mutating it to have its true (recursive) definition---is at the heart of letrec or other recursive let constructs.]

#callout("Exercise:")[This change to the object pattern is essentially _independent_ of the class pattern. Extend the class pattern to include self-reference.]

Self-Reference Without Mutation

There's another pattern we can use that avoids mutation, which is to send the object itself as a parameter:

```
(define o-self-no!
  (lambda (m)
    (case m
      [(first) (lambda (self x) (msg/self self 'second (+ x 1)))]
      [(second) (lambda (self x) (+ x 1))])))
```

Each method now takes `self` as an argument. That means method invocation must be modified to follow this new pattern:

```
(define (msg/self o m . a)
  (apply (o m) o a))
```

That is, when invoking a method on `o`, we must pass `o` as a parameter to the method. Notice that we did not do any such thing when invoking a function! This distinguishes functions and methods.

Obviously, this approach is dangerous because we can potentially pass a different object as the "self". Exposing this to the developer is therefore probably a bad idea; if this implementation technique is used, it should only be done in desugaring. (Unfortunately, Python exposes exactly this in its surface syntax.) Sure enough:

```
(test (msg/self o-self-no! 'first 5) 7)
```
