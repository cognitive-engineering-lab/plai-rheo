#import "/prelude.typ": *

== Terminology

It is common, on the Web, to read people speak of "interpreted languages" and "compiled languages". These terms are *nonsense*. That isn't just a judgment; that's a literal statement: they do not make sense. Interpretation and compilation are techniques one uses to evaluate programs. A _language_ (almost) never specifies how it should be evaluated. As a result, each implementer is free to choose whatever strategy they want.

Just as an example, C is often chosen as a canonically "compiled language", while Scheme is often presented as an "interpreted language". However, there have been (a handful of) interpreters for C; indeed, I used one when I first learned C. Likewise, there are numerous compilers for Scheme; I used one when I first learned Scheme. Python has several interpreters and compilers.

Furthermore, this seemingly hard distinction is frequently broken down in practice. Many languages now have a "JIT", which stands for _just-in-time_ compilation. That is, the evaluator starts out as an interpreter. If it finds itself interpreting the same code over and over, it compiles it and uses the compiled code instead. When and how to do this is a complex and fascinating topic, but it makes clear that the distinction is not a bright line.

Some people are confused by the _interface_ that an implementation presents. Many languages provide a _read-eval-print loop_ (REPL), i.e., an interactive interface. It is often easier for an interpreter to do this. However, many systems with such an interface accept code at a prompt, compile it, run it, and present the answer back to the user; they mask all these steps. Therefore, the interface is not an indicator of what kind of implementation you are seeing. It is perhaps meaningful to refer to an _implementation_ as "interactive" or "non-interactive", but that is not a reflection of the underlying language.

In short, please remember:

- (Most) Languages do not dictate implementations. Different platforms and other considerations dictate what implementation to use. 
- Implementations usually use one of two major strategies---interpretation and compilation---but many are also hybrids of these.
- A specific implementation may offer an interactive or non-interactive interface. However, this does _not_ automatically reveal the underlying implementation strategy.
- Therefore, the terms "interpreted language" and "compiled language" are nonsensical.
