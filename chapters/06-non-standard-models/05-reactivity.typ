#import "/prelude.typ": *
#show: book-style
#set document(title: [Reactivity])

= Reactivity

We learned early on that SMoL languages evaluate formal arguments at a function call. We then saw laziness as a contrast to this: an argument is evaluated _zero_ times at the call, and is maybe only evaluated later. (Of course, if the result is not cached, it may be evaluated many times.)

Now we will see another contrast to SMoL, focusing this time on the function call itself: where what syntactically looks like a single function call can actually be numerous, even an unbounded number.

#include "05-reactivity/guis-through-callbacks.typ"
#include "05-reactivity/reactivity.typ"
#include "05-reactivity/how-evaluation-works.typ"
#include "05-reactivity/other-time-varying-values.typ"
#include "05-reactivity/even-more-time-varying-values.typ"
#include "05-reactivity/returning-to-our-timer.typ"
