#import "/prelude.typ": *

== Evaluators

We're trying to implement a programming language: that is, to write an _evaluator_ (i.e., something that "reduces programs to values"). It helps if we can first understand how evaluation works on paper, before we start dealing with computer complexities.

Before we get into the details, it's worth knowing that there are broadly speaking two kinds of evaluators (as well as many combinations of them). They follow very different strategies:

- An _interpreter_ consumes a program and _simulates its execution_. That is, the interpreter does what we would expect "running the program" should do.
- A _compiler_ consumes a program and _produces another program_. That output program must then be further evaluated.

That is, an interpreter maps programs in some language _L_ to values:

#centered[interpreter :: Program#sub[L] → Value]

We leave open exactly what a _value_ is for now, informally understanding it to be an answer the user would want to see---put differently, something that either cannot or does not need to be further e-valu-ated. In contrast,

#centered[compiler :: Program#sub[L] → Program#sub[T]]

That is, a compiler from _L_ to _T_ (we use _T_ for "target") consumes programs in _L_ and produces programs in _T_. We aren't saying about how this _T_ program must be evaluated. It may be interpreted directly, or it may be further compiled. For instance, one can compile a Scheme program to C. The C program may be interpreted directly, but it may very well be compiled to assembly. However, we can't keep compiling ad infinitum: at the bottom, there must be some kind of interpreter (e.g., in the computer's hardware) to provide answers.

Note that interpreters and compilers are themselves programs written in some language and must themselves run. Naturally, this can lead to interesting ideas and problems.

In our study, we will focus primarily on interpreters, but also see a very lightweight form of compilers. Interpreters are useful because:

+ A simple interpreter is often much easier to write than a compiler.
+ Debugging an interpreter can sometimes be much easier than debugging a compiler.

Therefore, they provide a useful "baseline" implementation technology that everyone can reach for. Compilers can often take an entire course of study.
