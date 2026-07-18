#import "@preview/code-description:0.1.0": code, hl

// Generic labeled callout for PLAI's bold-label prompts: "Do Now:", "Exercise:",
// "Terminology:", "Note:", "Quote:", "Pro Tip:", "Notation:", "Alert:", "Aside:".
// The literal label (source text) is preserved so text-verification stays exact.
#let callout(label, body) = context {
  let inner = [*#label* #body]
  if target() == "html" or target() == "epub" {
    html.elem("div", attrs: (class: "callout"), inner)
  } else {
    block(
      width: 100%,
      fill: rgb("#f2f5f9"),
      inset: 10pt,
      radius: 4pt,
      stroke: (left: 3pt + rgb("#5b8fb9")),
      inner,
    )
  }
}

// "Aside:" uses the same callout styling as the other labeled prompts.
#let aside(children) = callout("Aside:", children)

// Part-divider title page. In the source these are an h1 rendered as
// "••••• Title •••••"; we keep the clean title text (for navigation and
// text-verification) and render the bullets as ornament.
#let part(title) = context {
  if target() == "html" or target() == "epub" {
    html.elem("div", attrs: (class: "part-divider"), heading(level: 1, title))
  } else {
    let dots = text(fill: luma(160))[#sym.bullet#sym.bullet#sym.bullet#sym.bullet#sym.bullet]
    v(3em)
    align(center, dots)
    v(0.7em)
    // A real (outlined) heading so parts show up in #outline(); the scoped show
    // rule just styles/centers it (the ornaments sit outside it).
    {
      show heading.where(level: 1): it => align(center)[
        #text(size: 1.7em, weight: "bold", tracking: 0.15em)[#it.body]
      ]
      heading(level: 1, title)
    }
    v(0.7em)
    align(center, dots)
    v(2em)
  }
}

// Align a block ("center"/"right"/"left"). `#align` is a paged-layout function
// that Typst's HTML export drops, so branch on target and use CSS for HTML.
#let aligned(how, body) = context {
  if target() == "html" or target() == "epub" {
    html.elem("div", attrs: (style: "text-align: " + how), body)
  } else {
    align((center: center, right: right, left: left).at(how), body)
  }
}
#let centered = aligned.with("center")

// The recurring "[👉]" cross-reference device: literal brackets around a
// pointing-hand link to another chapter. Usage: `#iconlink(<handle>)`.
#let iconlink(target) = { "["; link(target)[👉]; "]" }

// Book-wide styling applied per vertebra (`#show: book-style`): color hyperlinks.
#let book-style(doc) = {
  show link: it => text(fill: rgb("#1a56db"), it)
  doc
}
