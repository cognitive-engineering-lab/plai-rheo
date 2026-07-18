#import "/prelude.typ": *
#show: book-style
#set document(title: [Teach Yourself SMoL])

= Teach Yourself SMoL

This work is centered around your understanding of SMoL. However, to avoid a passive reading experience, #link("https://lukuangchen.github.io/")[Kuang-Chen Lu] has implemented a series of self-paced tutors to teach you SMoL. The tutors both give you conceptual knowledge and teach you important terminology.

Importantly, they also have short, quick test questions to make sure you're on the right track. These questions serve two ends. First, they force you to pay attention to the tutor: you can't just scroll through passively. Second, they are based on _known misconceptions_ with this material. Other learners made these mistakes, so you might too. Pay attention!

Because the tutorials currently do not support stopping, saving your work, and resuming, we have broken the material down into a set of small (!) tutors, each covering one concept (and sometimes even less). That way, you can do a tutor or three, take a break, and pick up later.

The tutors are all available from here:

#centered[#link("https://smol-tutor.xyz/tutor/")[https://smol-tutor.xyz/tutor/]]

*Before you go on in this book, you should do the tutors!*

The important thing to understand about SMoL is that its semantics is embedded into almost all our thinking about programming. Most notably, our algorithm analysis foundations---think Big-O for space and time---have an underlying, often implicit, cost model. That cost model assumes, for instance, that arguments are evaluated when a function call occurs, and that passing large data does not copy them. This is exactly what SMoL says should happen, too.
