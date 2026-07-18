#import "/prelude.typ": *
#show: book-style
#set document(title: [More on Macros])

= More on Macros

#callout("Note:")[All the examples from this chapter you can find in a video on YouTube, so if you prefer, you can watch that instead: #link("https://youtu.be/2FK6jpAcX9Q")[More on Macros]. Be sure to stop and reflect after each example, and try each of them out for yourself!]

Now let's start to look at various idiomatic aspects of using Racket macros. We'll want this understanding under our belt because we'll make use of several of these features. Here are five concrete things we'll see:

- A convenience in definitions
- A major and critical macro feature
- An important idiom in truthy/falsy languages
- A hazard in macro definitions
- A push to generalize definitions

#include "02-more-on-macros/a-definitional-convenience.typ"
#include "02-more-on-macros/name-capture.typ"
#include "02-more-on-macros/a-truthy-falsy-idiom.typ"
#include "02-more-on-macros/a-macro-definition-hazard.typ"
#include "02-more-on-macros/back-to-hygiene.typ"
#include "02-more-on-macros/generalizing-macros.typ"
