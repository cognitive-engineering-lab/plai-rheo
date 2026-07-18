#import "/prelude.typ": *

== The Representation of Numbers

In our implementation, every single number we compute is stored in `MEMORY` and, if we compute a certain number (say `3`) twice, each instance will be stored distinctly and hence take up separate space. However, this is not the space consumption model of real implementations.

On most modern architectures, values are stored at #link("https://en.wikipedia.org/wiki/Data_structure_alignment")["word" boundaries]: depending on the machine, starting at addresses that are multiples of 4 or 8. (The reasons for this are due to details of computer architecture that are outside the scope of this book.) For the purposes of illustration, let's say we have a 32-bit machine, with 4-byte alignment. That means every legal memory address, when viewed in binary, ends in …00. However, there are four legal values for those two bits, only one of which is being used. This creates an opportunity.

A common technique is to therefore use a pattern like …01 to be the tag for numbers. The actual number itself is stored in the remaining (say 30) bits of the "address". That means, "addresses" that end in 01 are not true addresses, and must not be looked up; they are actually just numbers.

Thus, in principle, the first thing to do with a value (that is, an address) is to test its 0'th bit. If this is 1, then shift the value right by 2 places. This drops the 01 tag, _leaving the number in place_. Similarly, when a number is constructed, provided it fits in 30 bits, it is shifted left by two places, and the last bit is made 1 (resulting in the 01 tag).

As a consequence, every number has a tag; but every number is also stored in registers and on the stack, not on the heap. All numbers with the same value have the same bit-pattern representation (the 30-bit numeric value followed by 01). Thus, there will be _zero_ instances of them on the heap, and they can be accurately compared for equality in constant time.

#aside[Notice that the above technique only works for numbers that can fit in 30 bits (or about 60 bits in a 64-bit machine). Larger numbers have to still be stored on the heap.]

As you might imagine, we have further room to play: we still have the patterns …10 and …11. Another good candidate for fitting entirely in the address is a Boolean, so the pattern …10 could be used for that. Very short strings might fit in a word. And so on. There are many architectural, instruction-set, and program considerations in designing these tags at the low level.
