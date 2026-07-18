#import "/prelude.typ": *

== Interaction with State

Now let's think about how all this interacts with state. Let's write a simple Web program that simply counts how many times we submitted a form.

One natural way to write it is as follows. We'll have a mutable variable, `count`, that keeps the count. We'll have a page that shows the current count and provides the user a button. When they click it, computation resumes; the resumed computation increments the count, and loops:

```
#lang web-server/insta

(define count 0)

(define (show-count)
  (send/suspend
     (lambda (k-url)
       (response/xexpr
        `(html (head "Counter")
               (body
                (p () "The current count is " ,(number->string count))
                (form ([action ,k-url])
                      (input ([type "submit"])))))))))

(define (start req)
  (show-count)
  (set! count (add1 count))
  (start 'dummy))
```

We'll call it the _stateful counter_.

This works as you might expect.

But now let's think about a different way to write this same program. Instead of using a global mutable variable, we could instead keep the count as a local variable and functionally update it:

```
#lang web-server/insta

(define (show-count count)
  (send/suspend
     (lambda (k-url)
       (response/xexpr
        `(html (head "Counter")
               (body
                (p () "The current count is " ,(number->string count))
                (form ([action ,k-url])
                      (input ([type "submit"])))))))))

(define (loop count)
  (show-count count)
  (loop (add1 count)))

(define (start req)
  (loop 0))
```

We'll call this the _functional counter_.

This, too, works as you would expect. And it works the same as the previous program. And yet, somehow, these programs seem to be different. Are they in fact _exactly_ the same?

They're not!

#callout("Exercise:")[Map out the stacks, environments, and stores to simulate how these programs would run.]
