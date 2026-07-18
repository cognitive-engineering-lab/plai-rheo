#import "/prelude.typ": *

== Web Interactions

In conventional, desktop software, concurrency is an artifact of the _program_. If the program is not concurrent, we can't really force it to behave concurrently.

Not so on the Web. There, we can copy URLs, duplicate them, and replay them. Therefore, the same program state can be invoked multiple times, returned to, and so on.

Consider the following sequence of interactions on the Web:

+ A user visits a travel Web site.
+ They enter a city and search for hotels.
+ They are given a list of hotels, L.
+ They click on one of the hotels, say L1.
+ This takes them to a page for L1.
+ They click the reservation link.

They obtain a reservation at L1. All this seems perfectly normal.

Now suppose instead they do the following:

+ A user visits a travel Web site.
+ They enter a city and search for hotels.
+ They are given a list of hotels, L.
+ They click on one of the hotels, say L1, in a _new_ tab.
+ They click on another of the hotels, say L2, in _another_ new tab.
+ They go back to L1's tab.
+ They click the reservation link.

Think about these two questions:

+ At which hotel would you _like_ the reservation to be made: L1 or L2?
+ Where do you _expect_ the site to make the reservation: L1 or L2?

Naturally, we would _expect_ the reservation at L1, because we clicked on the reservation link from L1's page. But on many Web sites, you used to get a reservation at L#emph[2], not L#emph[1]. This suggests that there is some interaction between the two tabs: specifically, there seems to be mutable state, the "current hotel", that is shared between the two tabs. Opening a hotel's page sets this. Thus, this is initially set to L1; the new tab for L2 sets it to L2; when we return to L1's tab and make a reservation, this act reads the mutable state, which makes the reservation at the "current hotel", namely L2.
