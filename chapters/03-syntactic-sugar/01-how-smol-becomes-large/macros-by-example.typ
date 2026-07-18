#import "/prelude.typ": *

== Macros By Example

Racket is one of the few languages to have a macro system, and in fact has a very powerful one. Its rarity means ideas we learn using macros will take some effort to port to other languages; but its power means we can write quite sophisticated systems by leveraging the full power of Racket, and we will do so. In essence, Racket macros compile an extended version of Racket---call it Racket++, if you like---down to Racket, where we can then exploit the full power of the existing Racket framework.

We will introduce the Racket macro system through a series of examples. In what follows, please switch to using

```
#lang racket
```

because the restrictions and types of `plait`, while very useful for writing interpreters, can get in the way of some of what we'll write.
