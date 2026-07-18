#import "/prelude.typ": *
#show: book-style
#set document(title: [Programming Languages: Application and Interpretation])

#v(1.5em)
#text(size: 1.9em, weight: "bold")[
  Programming Languages: \
  Application and Interpretation
]

#v(1.2em)
#centered[#image("/images/image14.jpg", width: 468pt)]

#v(1em)
#aligned("right")[
  #text(size: 1.2em)[Shriram Krishnamurthi] \
  #emph[Brown University]
]

#v(1.5em)
Version 3.2.5, 2025-07-14, © Shriram Krishnamurthi, #link("https://creativecommons.org/licenses/by-nc-sa/4.0/")[CC-BY-NC-SA 4.0].

#v(0.3em)
#centered[#image("/images/image18.png", width: 66pt)]

#v(1em)
#centered[If you make a derivative version, please follow the license rules.]
#centered[This book is provided *free of cost*. Please report any violations.]
#centered[For up-to-date information about this book, please visit #link("https://plai.org")[plai.org].]
#centered[Please also go there for information on how to report errors.]

#context { if target() not in ("html", "epub") { pagebreak() } }
