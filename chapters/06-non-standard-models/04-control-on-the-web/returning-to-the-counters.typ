#import "/prelude.typ": *

== Returning to the Counters

Now let's return to the two counters, armed with the ideas from the interactions above.

Run the stateful counter program and submit, say, 3 times. After that, the page will list the count as 3, and the URL will look something like

http://localhost:51264/servlets/standalone.rkt;((%22k%22%20.%20%22(1%203%2097639995)%22))?

Now copy this URL, create a _new_ tab, paste it, and enter. This runs the computation associated with this URL. Perhaps surprisingly, this shows the count as 4. Now go back to the previous tab and submit the form. That tab now shows a count not of 4 but of 5. Return to the second tab and submit; it now shows 6. The stacks help us see why: every return mutates the _same_ `counter` variable.

Now repeat the same process with the functional counter. After 3 submissions, we get a URL like

http://localhost:51379/servlets/standalone.rkt;((%22k%22%20.%20%22(1%203%2028533532)%22))?

which seems very similar. Now copy _this_ URL into a new tab, and repeat the interactions above.

What we see is very different. Each tab has its own local "memory", much as we expected of the pages on the travel Web site. The continuation does not mutate a single shared variable, but rather makes a new _call_ to loop, which creates a new binding that is distinct from previous bindings. Each time we submit we make another call, which makes another stack frame and its corresponding environment frame, which are distinct.

This distinction between creating a single, shared, mutable variable and creating distinct variables that each have their own immutable value should be familiar: it's the exact same problem that we saw in the Loops assignment \[#link("https://cs.brown.edu/courses/cs173/2022/loops.html")[https://cs.brown.edu/courses/cs173/2022/loops.html]\].
