#import "/prelude.typ": *

== Tracing Laziness

Another way to understand laziness is to study the encoding of streams in the Stacker. Here is the code:

```
#lang stacker/smol/hof

(deffun (lz-first s) (left s))
(deffun (lz-rest s) ((right s)))
(deffun (take n s)
  (if (equal? n 0)
      empty
      (cons (lz-first s) (take (- n 1) (lz-rest s)))))

(defvar ones (mpair 1 (λ () ones)))

(deffun (nats-from n)
  (mpair n (λ () (nats-from (+ n 1)))))
(defvar nats (nats-from 0))
```

Now run each of

```
(take 3 ones)
(take 3 nats)
```

and study _when_ evaluation happens and _what is being held on to by the closures_. (You may find it helpful to view just one of these at a time: the definition and use of `ones`, and separately of `nats` and `nats-from`.)
