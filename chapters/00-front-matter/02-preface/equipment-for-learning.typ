#import "/prelude.typ": *

== Equipment for Learning

While over time all the material might be incorporated into this book, for now, the book is part of a broader learning ecosystem, which is the course CSCI 1730 at Brown University. All the materials are available from the following site (look for the latest year):

#centered[#link("https://cs.brown.edu/courses/csci1730/2022/")[https://cs.brown.edu/courses/csci1730/]]

The course's work is divided into several "threads":

- SMoL uses an automated #link("https://smol-tutor.xyz/tutor/")[tutor] to teach students SMoL.
- ML makes students work through mystery languages.
- Stacker makes students reflect on program evaluation using a novel tool, the #link("https://smol-tutor.xyz/stacker/")[Stacker], which provides a notional machine. Readers will find it extremely useful to run SMoL programs in the Stacker and study how they behave.
- The Implementation thread has student build working implementations.
- The Analysis thread asks students to relate material they are learning in the class to real-world language contexts. I especially encourage educators to make use of the Analysis thread assignments in their classes.

This book makes heavy use of #link("https://racket-lang.org/")[Racket]. However, that is too simplistic. Racket's power comes from its ability to define new languages: #link("https://cs.brown.edu/~sk/Publications/Papers/Published/fffkbmt-programmable-prog-lang/")[this article] and #link("https://youtu.be/R_1TnfCuxK8")[this brief video] discuss that in more detail. Indeed, some programs in this book are written in the Racket programming language (`#lang racket`), but many are in a language ideally designed for this book (`#lang plait`). In addition, other parts define their own languages: there are multiple SMoL languages and well over a dozen mystery languages. Thus, while the learner must demonstrate some forbearance for parenthetical syntax, in return they will be richly rewarded with learning experiences.

The existence of `#lang`, in some ways, drove this book's redesign. I had some hand in that feature's #link("https://cs.brown.edu/~sk/Publications/Papers/Published/cffk-macros-to-dsls/")[design], which made me acutely self-conscious: materials intended to be for a broad audience shouldn't be about work too close to my heart. That was one of the reasons that, while the first edition used a predecessor of Racket, the second edition did not. In the process, however, I realized that I was depriving my students of numerous learning opportunities: after all, what better medium for the study of languages than a language designed for designing languages? For instance, the first version of the mystery languages were ad hoc and confusing; reimplementing them as a collection of Racket `#lang`s made them far simpler and clearer (and also open them up to be an object of direct study themselves). Thus, this edition doubles down (and then some) on the use of Racket. Getting it right can be tricky (e.g., avoiding mode confusion) and may take a few iterations, but it's well worth the effort.
