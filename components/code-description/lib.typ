// code-desc.typ — syntax-highlighted listings with in-snippet annotations,
// working in BOTH the PDF and HTML/EPUB backends.
//
// Write annotations *inside* the code with `@N|...|`. Each one becomes a
// colored highlight over exactly the marked span. The code keeps its normal
// syntax coloring (provided by Typst's own `raw` highlighter, in every target)
// and the highlight tracks the text as you edit it.
//
//   #import "code-desc.typ": code
//
//   #code(```rust
//   fn main() {
//       let x = @1|compute(40, 2)|;
//       println!("{}", @2|x|);
//   }
//   ```)
//
// Grammar:
//   @<digits>|...|   a marker; <digits> is the style index, ... is the span
//   \|               a literal pipe inside a span
//   single line      a span may not cross a newline
//   fail-soft        an unclosed `@N|`, or `@` not followed by digits+`|`,
//                    is emitted verbatim (so mistakes are visible, not swallowed)
//
// How it works: each line is split at span boundaries into inline `raw(...)`
// segments. Typst highlights each segment; marked segments are wrapped in a
// colored box (PDF) or a styled `<span>` (HTML/EPUB). No external packages.

// ---------------------------------------------------------------------------
// Styling: index -> highlight color. Override via `code`'s `style:` argument.
// ---------------------------------------------------------------------------

#let default-palette = (
  rgb("#ffe082"), // amber
  rgb("#90caf9"), // blue
  rgb("#a5d6a7"), // green
  rgb("#ffab91"), // orange
  rgb("#ce93d8"), // purple
)

#let default-style(index) = default-palette.at(calc.rem(index, default-palette.len()))

// ---------------------------------------------------------------------------
// Parser
// ---------------------------------------------------------------------------

#let _is-digit(c) = "0123456789".contains(c)

// Try to read a complete marker starting at clusters[i].
// Returns (index: int, body: str, next: int) on success, else none.
// `next` is the index of the first cluster after the closing `|`.
#let _try-marker(clusters, i) = {
  let n = clusters.len()
  if clusters.at(i) != "@" { return none }

  // digits
  let j = i + 1
  while j < n and _is-digit(clusters.at(j)) { j += 1 }
  if j == i + 1 { return none } // no digits after `@`
  if j >= n or clusters.at(j) != "|" { return none } // no opening pipe

  let index = int(clusters.slice(i + 1, j).join())

  // body, up to the next unescaped `|`
  let k = j + 1
  let body = ()
  while k < n {
    let c = clusters.at(k)
    if c == "\\" and k + 1 < n and clusters.at(k + 1) == "|" {
      body.push("|")
      k += 2
    } else if c == "|" {
      // `().join()` is `none`, so guard the empty-span case.
      let text = if body.len() == 0 { "" } else { body.join() }
      return (index: index, body: text, next: k + 1)
    } else {
      body.push(c)
      k += 1
    }
  }
  return none // unclosed
}

// Scan one line. Returns (clean: str, spans: array). Columns are 1-based and
// end-inclusive, counted in UTF-8 *bytes* of the cleaned line, so they map
// directly onto `str.slice` (which is byte-indexed). A multibyte character
// like `Γ` advances the column by its byte width. An entry covers 1-based byte
// positions [start, end].
#let _scan-line(line, lnum) = {
  let clusters = line.clusters()
  let n = clusters.len()
  let i = 0
  let clean = "" // accumulate as a string so `.len()` gives byte offsets
  let spans = ()
  while i < n {
    let m = _try-marker(clusters, i)
    if m != none {
      let start = clean.len() + 1
      clean += m.body
      let end = clean.len()
      if end >= start {
        spans.push((line: lnum, start: start, end: end, index: m.index))
      }
      i = m.next
    } else {
      clean += clusters.at(i)
      i += 1
    }
  }
  return (clean: clean, spans: spans)
}

// Parse a source string into per-line records: (clean: str, spans: array).
#let parse-lines(source) = {
  source.split("\n").enumerate().map(((idx, line)) => _scan-line(line, idx + 1))
}

// Parse a source string. Returns (text: str, spans: array) where `text` is the
// source with all markers removed and `spans` is the flat list of
// (line, start, end, index) annotations. (Kept for testing/introspection.)
#let parse-marks(source) = {
  let lines = parse-lines(source)
  (
    text: lines.map(l => l.clean).join("\n"),
    spans: lines.map(l => l.spans).join(),
  )
}

// ---------------------------------------------------------------------------
// Rendering
// ---------------------------------------------------------------------------

// Split a clean line into ordered segments: (text: str, index: int | none).
// `index` is the highlight style index, or none for unmarked text. Slicing is
// byte-based, matching the 1-based/end-inclusive span columns.
#let _segments(clean, spans) = {
  let segs = ()
  let cursor = 0 // 0-based byte offset
  for s in spans.sorted(key: x => x.start) {
    let a = s.start - 1 // 0-based, inclusive
    let b = s.end //       0-based, exclusive (== 1-based inclusive end)
    if a > cursor { segs.push((text: clean.slice(cursor, a), index: none)) }
    segs.push((text: clean.slice(a, b), index: s.index))
    cursor = b
  }
  if cursor < clean.len() { segs.push((text: clean.slice(cursor), index: none)) }
  if segs.len() == 0 { segs.push((text: clean, index: none)) } // empty line
  segs
}

// Wrap highlighted body in a colored container, branching on the backend.
#let hl-box(fill, body) = context {
  if target() == "html" or target() == "epub" {
    html.elem(
      "span",
      attrs: (
        class: "code-hl",
        style: "background-color: " + fill.to-hex(),
      ),
      body,
    )
  } else {
    box(fill: fill, outset: (y: 3pt), inset: (x: 1pt), radius: 2pt, body)
  }
}

#let hl(index, body) = hl-box(default-style(index), body)

// Render one segment as inline, syntax-highlighted code.
#let _render-seg(seg, lang, style) = {
  let r = raw(seg.text, lang: lang, block: false)
  if seg.index == none { r } else { hl-box(style(seg.index), r) }
}

// Render a full listing whose `@N|...|` markers become highlights. `snippet` is
// a raw block (```lang ... ```). `style` maps a marker's index to a color.
#let code(snippet, style: default-style) = context {
  let html-mode = target() == "html" or target() == "epub"
  let lang = snippet.fields().at("lang", default: none)
  let lines = parse-lines(snippet.text)

  let render-line(l) = _segments(l.clean, l.spans)
    .map(s => _render-seg(s, lang, style))
    .join()

  if html-mode {
    // Each segment is already its own inline `<code data-lang>` (or a wrapping
    // <span>), so they go directly inside <pre> — wrapping them in another
    // <code> would nest <code> inside <code>, which is invalid. <pre>
    // preserves the literal newlines between lines.
    html.elem(
      "pre",
      attrs: (class: "code-desc"),
      lines.map(render-line).join("\n"),
    )
  } else {
    block(
      fill: luma(247),
      inset: (x: 10pt, y: 8pt),
      radius: 4pt,
      width: 100%,
      {
        set par(leading: 0.6em, justify: false)
        lines.map(render-line).join(linebreak())
      },
    )
  }
}
