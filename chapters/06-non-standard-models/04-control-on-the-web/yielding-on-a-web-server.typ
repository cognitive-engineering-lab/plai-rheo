#import "/prelude.typ": *

== Yielding on a Web Server

The Racket Web server has a special primitive that does just this for the Web. We'll build it up in stages. First, we'll use a special Racket language, designed to make it easier to write server-side Web programs:

```
#lang web-server/insta
```

Programs in this language must have a "main" function, called `start`, which is given an initial request (whatever information is provided when we first run the computation). This function is then written assuming a convenient fiction: the existence of a function `get-number` that will print a prompt, send out a Web page, _wait for its response_, extract the value entered, and return it as a number:

#code(```
(define (start req)
  (let ([result @1|(+ (get-number "first") (get-number "second"))|])
    (response/xexpr
     `(html (body (p "The result is " ,(number->string result)))))))
```)

If we can make this fiction reality, then we can write a program like the above: it calls `get-number` in a "deep" context, twice, adds the results, and then converts the result into a string to embed it into a Web page.

The question, of course, is how such a function can exist. First, we have to discuss some Web mechanics. When we create a Web form, it needs a field called the `action`, which holds a URL. When the user submits the form, the browser bundles up the information entered into the fields of the form and sends them---effectively, as a set of key-value pairs---_to the URL_, i.e., to the server, requesting it to run the program at that URL and provide the key-value pairs to that program.

Therefore, we can see that we've turned the problem of suspending the program's execution into one of being able to fill in this URL with something meaningful. If the URL can somehow correspond to the stack, then perhaps the stack (and hence the computation) can be restored, and can be provided with these key-value pairs, from which the program can extract the required information.

The "secret sauce" that the Racket Web server provides is a primitive called `send/suspend`. It does the following:

- It takes a _single-argument function_ as a parameter. 
- It records the current stack as a value.
- It stores this stack in a hash-table, associated with a unique, unguessable string.
- It turns this string into a URL.
- It then _calls_ the given function with this URL string.

The resulting function can then use this URL string as the `action` field of the form.

#aside[
  This is not the only way to use it. The URL could also, for instance, be sent in an email message. This is a handy way to validate email addresses. Because the URL is unique and unguessable, the only way for someone to resume the computation would be to receive that URL, i.e., to have access to the email address. Thus, resuming the computation can be thought of as having validated the email address (assuming, of course, that an intruder is not reading emails and clicking on validation links that the email's owner would not have clicked on).
]

So here is an actual working implementation of get-number:

#code(```
(define (get-number which)
  (define title (format "What is the ~a number?" which))
  (define req
    (send/suspend
     (lambda (k-url)
       @2|(response/xexpr|
        @3|`(html (head (title ,title))|
@3|               (body|
@3|                (form ([action ,|k-url@3|])|
@3|                      ,title ": "|
@3|                      (input ([name "number"]))|
@3|                      (input ([type "submit"]))))|@2|)|))))
  (string->number
    @2|(extract-binding/single 'number|
@2|      (request-bindings req))|))
```)

Observe that most of this function is just #hl(3)[HTML] and #hl(2)[API] bookkeeping. We have to construct the Web page with the relevant components. When (if) the computation resumes, it returns with the key-value pairs sent from the form. These are bound to `req`. From there, it's a simple matter of extracting the right value using the APIs.

And that's it! That gives us a full, working program.
