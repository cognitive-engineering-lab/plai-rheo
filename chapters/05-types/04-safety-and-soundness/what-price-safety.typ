#import "/prelude.typ": *

== What Price Safety?

Our safe evaluator has, however, come at a price relative to the unsafe evaluator. In terms of running *time*, we are now clearly paying for the overhead of safety checks. In terms of *space*, we are paying for the tags. Thus, we have had to get worse space _and_ time.

Nevertheless, the price of unsafe languages is so high---e.g., in the form of security problems---and the cost of safety is often so low, that programmers gladly pay this price (or do so without even particularly noticing it).

Still, it would be nice if we didn't have to pay the price at all. And there is a way to accomplish that: _types_.

Look at our "bad" programs. These are programs that can _statically_ be rejected by a type-checker. If we could reject all such programs, then---since no "bad" programs would be left---we can then run the program on the _unsafe_ evaluator without worrying about negative consequences. This, in effect, is what most typed languages, like Java and OCaml, do. Thus we find another use for types: to improve program performance. But this requires care.

#callout("Exercise:")[Usually, in computer science, we talk about a space-time _tradeoff_. Yet here we seem to have a situation where we've improved (i.e., reduced the use of) both the space _and_ the time! How is that possible?]
