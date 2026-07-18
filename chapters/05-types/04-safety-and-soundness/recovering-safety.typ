#import "/prelude.typ": *

== Recovering Safety

Fortunately, it does not take too much work to make the language safe again. What we've just written holds the key: every value needs to record what kind of value it is. And any use of that value needs to check that it's the right kind of value. This information is called a _tag_; it takes a fixed amount of space, and represents _metadata_ about the subsequent p. All subsequent values are interpreted in accordance with the tag.

We need two tags for the two kinds of values. Let's use

```
(define NUMBER-TAG 1337)
(define STRING-TAG 5712)
```

It's important that the two tags be different, so they are unambiguous. However, we don't need to worry about the tags themselves being confused with other data (e.g., numbers), because the tags will never be processed directly as program data (unless, of course, there is a bug in our implementation that accidentally does so…which is why language implementations need to be tested extensively).

Now, when we allocate a number, we write its _tag_ into the first address, followed by the actual numeric value:

#code(```
(define (store-num n)
  @1|(let ([a0 (write-and-bump NUMBER-TAG)])|
@1|    (begin|
      (write-and-bump n)
      @1|a0))|)
```)

And when we try to read a number, we _first_ check that it really _is_ a number, and only then obtain the actual numeric value:

#code(```
(define (safe-read-num a)
  @1|(if (= (vector-ref MEMORY a) NUMBER-TAG)|
      (vector-ref MEMORY @1|(add1 |a@1|)|)
      @1|(error 'number (number->string a)))|)
```)

Strings are analogous:

#code(```
(define (store-str s)
  (let ([a0 (write-and-bump @1|STRING-TAG|)])
    (begin
      @1|(write-and-bump (string-length s))|
      (map write-and-bump
           (map char->integer (string->list s)))
      a0)))

(define (safe-read-str a)
  @1|(if (= (vector-ref MEMORY a) STRING-TAG)|
      (letrec ([loop
                (lambda (count a)
                  (if (zero? count)
                      empty
                      (cons (vector-ref MEMORY a)
                            (loop (sub1 count) (add1 a)))))])
        (list->string
         (map integer->char
              (loop (vector-ref MEMORY @1|(add1 |a@1|)|) (+ a @1|2|)))))
      @1|(error 'string (number->string a)))|)
```)

So now, starting from a fresh memory, running

```
(store-str "hello")
```

still produces `0`, but the content of `MEMORY` looks a bit different:

#code(```
'#(@1|5712|
   5
   104
   101
   108
   108
   111
   -1
   -1
   -1
   …)
```)

That is, at address `0` we first encounter the tag for strings. Only then do we get the string's length, followed by its contents. Observe that now, storing the length up front makes even more sense: the first two locations contain the tag and the length, both of which are _metadata_ that help us interpret what comes later, with the second (the length) _refining_ the first (the tag).

With this change, the interpreter stays unchanged, and effectively so do the helpers, other than using the new names we've chosen:

#code(```
(define (num+ la ra)
  (store-num (+ (@1|safe-|read-num la) (@1|safe-|read-num ra))))

(define (str++ la ra)
  (store-str (string-append (@1|safe-|read-str la) (@1|safe-|read-str ra))))
```)

All our "good" tests still pass, but importantly, our "bad" tests now fail as desired:

```
(test/exn (calc (cat (num 1) (str "hello"))) "string")
(test/exn (calc (plus (num 1) (str "hello"))) "number")
```

#callout("Exercise:")[You may notice the error message strings above have changed slightly. Why?]
