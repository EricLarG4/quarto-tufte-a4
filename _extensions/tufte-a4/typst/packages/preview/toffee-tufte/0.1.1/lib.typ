// PATCHED (2026-11-10) vs upstream toffee-tufte 0.1.1: body text 10pt
// (typst default 11pt), title 13pt, headings 12/11/10pt, right margin
// 2.6in (was 3in) for more body width; font stack pruned to installed
// families (Noto Sans, Atkinson Hyperlegible, Segoe UI, Arial) so typst stops
// warning about missing IBM Plex Sans/Helvetica/Geneva/generic sans-serif;
// citations in IEEE style (abbreviated journals); toc-depth parameter
// (upstream hardcodes outline depth 2). Everything else unchanged.
#import "@preview/drafting:0.2.2": *

#let sans-fonts = (
  "Noto Sans",
  "Atkinson Hyperlegible",
  "Segoe UI",
  "Arial",
)

#let fullwidth = state("fullwidth", false)

#let template(
  title: none,
  authors: none,
  date: datetime.today().display("[day] [month repr:long] [year]"),
  abstract: none,
  toc: false,
  toc-depth: 2,
  full: false,
  header: true,
  footer: true,
  header-content: none,
  footer-content: none,
  bib: none,
  doc,
) = {
  // Full width or with right margin
  let right-margin = {
    if full { 0.7in } else { 2.6in }
  }
  let left-margin = 0.7in
  let margin-diff = right-margin - left-margin
  let wideblock(content) = block(width: 100% + margin-diff, content)

  // Update full width state used by note and notecite functions
  fullwidth.update(full)

  // Functions
  let titleblock(title, authors, date, abstract) = {
    wideblock([
      #set align(center)
      #if title != none { [#text(13pt, [*#title*]) \ \ ] }
      #if authors != none {
        if type(authors) == array and authors.len() == 2 {
          [#authors.join(", ", last: " and ") \ ]
        } else if type(authors) == array {
          [#authors.join(", ", last: ", and ") \ ]
        } else if type(authors) == str {
          [#authors \ ]
        }
      }
      #if date != none { [#date \ ] }
      #if abstract != none { [\ #abstract \ ] }
      #if toc { [\ #outline(indent: 1em, title: none, depth: toc-depth) ] }
    ])
  }

  let headerblock(title, authors, date, header-content) = if header and header-content != none {
    header-content
  } else if header {
    set text(size: 8pt)
    wideblock({
      if counter(page).get().first() > 1 [
        #emph[#title]
        #h(1fr)
        #emph[#date]
      ]
    })
  } else { none }

  let footerblock(footer-content) = if footer and footer-content != none {
    footer-content
  } else if footer {
    set text(size: 8pt)
    wideblock({
      set align(right)
      emph(counter(page).display("1/1", both: true))
    })
  } else { none }

  // Metadata
  if authors != none {
    set document(title: title, author: if type(authors) == str { authors } else { () })
  } else {
    set document(title: title)
  }

  set text(font: sans-fonts, size: 10pt, fill: luma(15%))
  show ref: set text(blue)
  show link: set text(blue)

  set par(justify: true, spacing: 1.5em)

  set cite(style: "chem-authors.csl")
  show bibliography: set par(spacing: 1em)

  set enum(indent: 1em)
  set list(indent: 1em)
  show enum: set par(spacing: 1.25em)
  show list: set par(spacing: 1.25em)

  set math.equation(numbering: "(1)", supplement: none, number-align: bottom)

  show raw.where(block: false): box.with(
    fill: luma(95%),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )
  show raw.where(block: true): block.with(
    fill: luma(95%),
    inset: 5pt,
    radius: 4pt,
    width: 100%,
  )

  // Equation reference to (1)
  show ref: it => {
    if it.element != none and it.element.func() == math.equation {
      link(it.target)[(#it)]
    } else {
      it
    }
  }

  // Figure reference without supplement
  show ref.where(
    form: "normal",
  ): set ref(supplement: it => {
    if it.func() == figure { none }
  })

  // Section headings
  set heading(numbering: "1.1.1.", supplement: none)
  show heading.where(level: 1): it => {
    v(1.2em, weak: true)
    text(size: 12pt, weight: "bold", it)
    v(1em, weak: true)
  }
  show heading.where(level: 2): it => {
    v(1.2em, weak: true)
    text(size: 11pt, weight: "bold", it)
    v(1em, weak: true)
  }
  show heading.where(level: 3): it => {
    v(1.2em, weak: true)
    text(size: 10pt, weight: "bold", it)
    v(1em, weak: true)
  }

  set page(
    paper: "a4",
    margin: (
      left: left-margin,
      right: right-margin,
      top: 1in,
      bottom: 0.75in,
    ),
    header: context { headerblock(title, authors, date, header-content) },
    footer: context { footerblock(footer-content) },
    footer-descent: 55%,
  )

  // Title block
  titleblock(title, authors, date, abstract)
  v(1.5em)

  // Using drafting package
  set-page-properties(
    margin-right: right-margin - left-margin,
    margin-left: left-margin * 1.2,
  )
  set-margin-note-defaults(
    stroke: none,
    side: right,
  )

  doc

  if bib != none { wideblock(bib) }
}

#let notecounter = counter("notecounter")
/// A sidenote.
///
/// Places a sidenote at the right margin.
/// If `full` template option is set to `true`, becomes a footnote instead.
///
/// - `dy: auto | length = auto` Vertical offset.
/// - `numbered: bool = true` Insert a superscript number.
/// - `body: content` Required. The content of the sidenote.
#let sidenote(dy: auto, numbered: true, body) = context {
  if fullwidth.get() and not numbered {
    footnote(body, numbering: _ => [])
    counter(footnote).update(n => n - 1)
  } else if fullwidth.get() {
    footnote(body)
  } else {
    if numbered {
      notecounter.step()
      context super(notecounter.display())
    }
    text(size: 8pt, margin-note(
      if numbered {
        text(size: 11pt, {
          context super(notecounter.display())
        })
        body
      } else {
        body
      },
      dy: dy,
    ))
  }
}

/// A sidenote citation.
///
/// Places a sidenote at the right margin.
/// If `full` template option is set to `true`, becomes a footnote instead.
/// Only display when `bibliography` is defined.
///
/// - `dy: auto | length = auto` Vertical offset.
/// - `form: none | str = "normal"` Form of in-text citation.
/// - `style: [csl] | auto | bytes | str = auto` Citation style.
/// - `supplement: content | none = none` Citation supplement.
/// - `key: cite-label` Required. The citation key.
#let sidecite(dy: auto, form: "normal", style: auto, supplement: none, key) = context {
  show cite: it => {
    show regex("\[\d\]"): set text(blue)
    it
  }
  let elems = query(bibliography)
  if type(key) == array {
    // PATCHED (extension): original accepts a single label only; flatten
    // multiple labels and emit one citation per key, full form in the sidenote
    if elems.len() > 0 {
      for k in key { cite(k, form: form, style: style, supplement: supplement) }
      sidenote(key.map(k => cite(k, form: "full")).join(), dy: dy, numbered: false)
    }
  } else if elems.len() > 0 {
    cite(key, form: form, style: style, supplement: supplement)
    sidenote(
      cite(key, form: "full"),
      dy: dy,
      numbered: false,
    )
  }
}

/// Wideblock
///
/// Wrapped content will span the full width of the page.
///
/// - `content: content | none` Required. The content to span the full width.
#let wideblock(content) = context {
  if fullwidth.get() {
    block(width: 100%, content)
  } else {
    block(width: 100% + 2.3in, content)
  }
}
