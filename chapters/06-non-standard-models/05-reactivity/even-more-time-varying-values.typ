#import "/prelude.typ": *

== Even More Time-Varying Values

We have actually seen only one kind of time-varying value, called a _behavior_. There are actually two kinds of time-varying values, which is easy to see if we consider a few different kinds of stimuli from the world:

- Current mouse position
- Sequence of keystrokes
- Current user location
- Sequence of network responses
- Current status of mode keys
- Sequence of mouse-clicks
- Current time

Notice that several of those are "current…" and others are "sequence of…". The former have the property that they always have a value, and the value may change at any time. The latter have the property that at any given moment they may not have a value---for instance, there may not be a "current keystroke"---and we don't know when (or if) the next one will come, and there may be an infinite number of them. The latter are, of course, just _streams_, often called _event streams_.

If we go back to our original counter example, we had both present. The elapsed time was a behavior (always has a value, which changes either when a second finishes or when a button is clicked). The sequence of button presses is, conversely, an event stream: at any given moment there may not be a press, we don't know when or even if the next one will come, and there may be an unbounded number of them (from a very bored user). To learn more, see the papers about the design and implementation of #link("https://cs.brown.edu/~sk/Publications/Papers/Published/ck-frtime/")[FrTime], and a similar language for JavaScript called #link("https://cs.brown.edu/~sk/Publications/Papers/Published/mgbcgbk-flapjax/")[Flapjax].
