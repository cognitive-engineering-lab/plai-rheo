#import "/prelude.typ": *

== Making Memory Explicit (Unsafely)

Now we're going to do something fun: we're going to make the memory allocation of values explicit. As we go through this, remember what we've said before: a value in SMoL is just a memory address.

Let's do this in stages. First, we'll use a vector to represent memory:

```
(define MEMORY (make-vector 100 -1))
```

The value `-1` is useful for identifying parts of memory that have not yet been touched (assuming, of course, we don't write a program that produces `-1`---which we can avoid doing easily enough in this illustration).

#aside[To run the code below, you will need to import some Racket primitives into plait:]

```
(require (typed-in racket/base
                   [char->integer : (Char -> Number)]
                   [integer->char : (Number -> Char)]
                   [number->string : (Number -> String)]))
```

It will be useful to have a helper to use the next available bit of memory:

```
(define next-addr 0)
(define (write-and-bump v)
  (let ([n next-addr])
    (begin
      (vector-set! MEMORY n v)
      (set! next-addr (add1 next-addr))
      n)))
```

Now let's say we want to store a number in memory. We put it in the next available memory place, and return the _address_ of the place where the number was stored. Be careful here: the number we return is a memory address (which, here, is represented as an array index), which is not at all necessarily the same as the _numeric value_ being stored.

```
(define (store-num n)
  (write-and-bump n))
```

Correspondingly, when we want to read a number, we simply return what is at the address corresponding to the number.

```
(define (read-num a)
  (vector-ref MEMORY a))
```

We want the property that when we `read-num` from the address where we `store-num` a number, we get back that same number: for all `N`,

#centered[`(read-num (store-num N))` is `N`]

#aside[This is not quite exactly how numbers are stored in most languages. As we will see when we update the calculator below, this means every time we produce a particular number---`1730`, say---we store it afresh in memory. That would be extremely wasteful. Rather, language implementations use representation tricks to make sure there is only one copy of numbers and that they don't need to take up space on the heap at all, as we describe below #iconlink(<chapters:05-types:04-safety-and-soundness>). However, we will continue to work with this simple model because this optimization is not the focus of this chapter. In addition, _some_ numbers---that don't fit in a small amount of space---_do_ need to be stored on the heap.]

Now let's look at strings. We are going to convert the string into a sequence of character codes, and store those codes explicitly:

```
(define (store-str s)
  (let ([a0 (write-and-bump (string-length s))])
    (begin
      (map write-and-bump
           (map char->integer (string->list s)))
      a0)))
```

In particular, the value stored at the address representing the string is the _length_ of the string, followed by the individual characters. (Endless blood has been spent over whether strings should store their lengths at the front, or whether they should only be delimited by a special value, or both. The question is uninteresting here.) Thus, suppose with a fresh memory we run

```
(store-str "hello")
```

this would return the address `0`. The resulting value of `MEMORY` would be

```
'#(5
   104
   101
   108
   108
   111
   -1
   -1
   -1
   …)
```

That is, at address `0` we have the length of the string, followed by five character codes; these six memory entries together constitute the five-character string `"hello"`. The rest of the memory remains untouched. To read a string we have to reassemble it:

```
(define (read-str a)
  (letrec ([loop
            (lambda (count a)
              (if (zero? count)
                  empty
                  (cons (vector-ref MEMORY a)
                        (loop (sub1 count) (add1 a)))))])
    (list->string
     (map integer->char
          (loop (vector-ref MEMORY a) (add1 a))))))
```

Once again, we want the result of reading a written string to give us the same string.

Now let's update the calculator. First, we're in for a surprise: we no longer need (or _want_) a fancy Racket datatype to track values, because values are just addresses (i.e., array indices)! So:

```
(define-type-alias Value Number)
```

The _type_ of the calculator doesn't change; it still produces values. It's just that the representation of values has changed…dramatically. (Recall, again, that these `Number`s are addresses, not numeric values _in_ the interpreted language.)

The calculator remains the same. What has changed is in the helper functions. In the primitive value cases, we have to explicitly allocate them---which is what we were doing when we called the previous definitions of `numV` and `strV` (which store data on the heap), except it may not have been so evident. We will make it explicit as follows:

```
(define numV store-num)
(define strV store-str)
```

Okay, now to update the helper functions. Let's focus on `num+`. The core logic is currently

```
      [(numV rn) (numV (+ ln rn))]
```

Observe that now we're calling it on the result of calling `calc`, i.e., on `Value`s. That means `num+` is going to get two addresses as arguments, and it needs to look up the corresponding numbers in memory, and then produce the resulting number:

```
(define (num+ la ra)
  (numV (+ (read-num la) (read-num ra))))
```

#aside[In case you're wondering: yes, we're cheating a tiny bit. We're using Racket numbers rather than dealing with even lower-level representations. We'll give ourselves this little bit of leeway since this is not the point we're trying to illustrate.]

Analogously, we can define concatenation as well:

```
(define (str++ la ra)
  (strV (string-append (read-str la) (read-str ra))))
```

#aside[Yes, we're cheating again, and quite a bit. If we were less lazy, we'd write a big loop over `MEMORY` that copies all the values from the first and second strings into a new, third string, explicitly. But we're lazy.]

Finally, we have to update our tests as well. Because `calc` now returns _addresses_, all our answers appear to be incorrect. Instead, we have to obtain the corresponding numbers or strings at those addresses. Once we do so, `calc` passes the tests:

```
(test (read-num (calc (plus (num 1) (num 2)))) 3)
(test (read-num (calc (plus (num 1) (plus (num 2) (num 3))))) 6)
(test (read-str (calc (cat (str "hel") (str "lo")))) "hello")
(test (read-str (calc (cat (cat (str "hel") (str "l")) (str "o")))) "hello")
```

Except…does it? These two tests do not pass:

```
(test/exn (calc (cat (num 1) (str "hello"))) "left")
(test/exn (calc (plus (num 1) (str "hello"))) "right")
```

In fact, how _can_ they? In all the above code, there are no errors left! Rather, when we run

```
(calc (cat (num 1) (str "hello")))
```

we get an address back (maybe `69`; it depends on what you ran earlier and hence what is in `MEMORY`). In fact, we can decide how we want to treat this: As a number? As a string?

```
> (read-num 69)
- Number
6
> (read-str 69)
- String
"\u0005hello"
```

But how can something be both a number and a string? Well, actually, the situation is a bit more confusing than that: `69` above is just an address in memory from which we can read off whatever we want _however we want it_ (i.e., the content of that address is _interpreted_ by the function that reads from it), which can result in garbage. It can get even worse:

```
> (read-num (calc (plus (num 1) (str "hello"))))
- Number
6
> (read-str (calc (plus (num 1) (str "hello"))))
- String
. . integer->char: contract violation
  expected: valid-unicode-scalar-value?
  given: -1
```

That is, we've tried to read "off the end of memory". It was dumb luck that we had a `-1` as the initial value; the `-1` triggered an error when we tried to convert it to a character _because Racket's primitives are safe_, which halted the program. If `integer->char` did not have a safety check, we would have gotten some garbled string instead.

In short, what we have created is an _unsafe_ language. Data have no integrity. Any value can be treated as any kind of datum. This, in short, is the memory model of C, and it's largely proven to be a disaster for modern programming, which is why SMoL languages evolved.
