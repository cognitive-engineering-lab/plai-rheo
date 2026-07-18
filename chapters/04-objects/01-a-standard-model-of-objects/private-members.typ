#import "/prelude.typ": *

== Private Members

In our object pattern, anything in the case can be accessed by passing its member name to the object. However, it is common for object languages to want to have some members be _private_, i.e., visible only inside the object, not outside it. In languages like Java, for instance, the keyword private is often used to designate them (both fields and methods). These kinds of members are used to control data that should not be accessed by the outside world (e.g., a private cryptographic key that is used to sign content).

#aside[Except that, in Java, other instances of classes of the same type are privy to "private" members. Otherwise, you would simply never be able to implement an Abstract Data Type. Note that classes are not Abstract Data Types!]

#aside[If you think about this a bit, you may realize that private members are not enough. Consider the cryptographic key. We may have a private member refer to it. However, that doesn't mean there aren't _other_ references to it---that is, aliases!---that are _not_ private, and hence may leak it! Thus, private members must often be used in conjunction with reasoning about aliasing.]

Private members may seem like an additional feature we need to implement, but we already have the necessary mechanism in the form of locally-scoped, lexically-bound variables. To avoid diving into the details of domains like cryptography, we will illustrate this with a simple example of a counter object that provides methods to increment, decrement, and show the count:

```
(define (mk-o-state/priv init)
  (let ([count init])
    (lambda (m)
      (case m
        [(inc) (lambda () (set! count (+ count 1)))]
        [(dec) (lambda () (set! count (- count 1)))]
        [(get) (lambda () count)]))))
```

The code above uses lexical scoping to ensure that `count` remains hidden to the world. Trying to access count directly from the outside will fail; the only members visible are those that case handles.

#callout("Exercise:")[If we were to directly desugar to the code above, public members can clearly refer to private ones (as they refer to count, above); but can private members refer to public ones? If so, give an example that shows this working. If not, fix the desugaring pattern!]
