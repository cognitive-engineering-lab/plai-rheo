#import "/prelude.typ": *

== Dynamic Dispatch

Finally, we should make sure our objects can handle a characteristic attribute of object systems, which is the ability to invoke a method without the caller having to know or decide which object will handle the invocation.

Suppose we have a binary tree data structure, where a tree consists of either empty nodes or leaves that hold a value. In traditional functions, we are forced to implement some form of conditional---such as a `type-case`---that exhaustively lists and selects between the different kinds of trees. If the definition of a tree grows to include new kinds of trees, each of these code fragments must be modified.

Dynamic dispatch solves this problem by making that conditional branch disappear from the user's program and instead be handled by the method selection code built into the language. The key feature that this provides is an extensible conditional. This is one dimension of the extensibility that objects provide.

Let's first define our two kinds of tree objects:

```
(define (mt)
  (let ([self 'dummy])
    (begin
      (set! self
            (lambda (m)
              (case m
                [(sum) (lambda () 0)])))
      self)))

(define (node v l r)
  (let ([self 'dummy])
    (begin
      (set! self
            (lambda (m)
              (case m
                [(sum) (lambda () (+ v
                                     (msg l 'sum)
                                     (msg r 'sum)))])))
      self)))
```

With these, we can make a concrete tree:

```
(define a-tree
  (node 10
        (node 5 (mt) (mt))
        (node 15 (node 6 (mt) (mt)) (mt))))
```

And finally, test it:

```
(test (msg a-tree 'sum) (+ 10 5 15 6))
```

Observe that both in the test case and in the `sum` method of `node`, there is a reference to `'sum` without checking whether the recipient is a `mt` or `node`. Instead, the _language's run-time system_ extracts the recipient's `sum` method and invokes it. This conditional missing from the user's program, and handled automatically by the language, is the essence of dynamic dispatch.

It's worth noting that we didn't have to change our pattern to add dynamic dispatch; _it simply followed as a result of the rest of the design_.

#aside[This property---which appears to make systems more black-box extensible because one part of the system can grow without the other part needing to be modified to accommodate those changes---is often hailed as a key benefit of object-orientation. While this is indeed an advantage objects have over functions, there is a dual advantage that functions have over objects, and indeed many object programmers end up contorting their code---using the Visitor pattern---to make it look more like a function-based organization. Read #link("http://www.cs.brown.edu/~sk/Publications/Papers/Published/kff-synth-fp-oo/")[Synthesizing Object-Oriented and Functional Design to Promote Re-Use] for a running example that will lay out the problem in its full glory. Try to solve it in your favorite language, and see the #link("http://www.cs.utah.edu/plt/publications/icfp98-ff/paper.shtml")[Racket solution].]
