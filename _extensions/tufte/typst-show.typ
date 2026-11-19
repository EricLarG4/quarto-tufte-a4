// Apply the toffee-tufte template (imported in typst-template.typ),
// mapping Pandoc metadata to the template's arguments. Unlisted options
// keep the package defaults (a4, 2.6in right margin for sidenotes,
// header/footer on, sidenote-capable Tufte layout).
//
// NOTE on the TOC: toffee's `toc: true` option renders the outline in the
// title BLOCK (full width). The upstream demo instead puts it in the side
// margin with `#sidenote(numbered: false)[#outline(depth: 2)]` — that is
// what we do below whenever `toc` is set, so the template itself never
// receives `toc`.
#show: doc => template(
$if(title)$
  title: [$title$],
$endif$
$if(by-author)$
  authors: (
$for(by-author)$
    [$it.name.literal$],
$endfor$
  ),
$endif$
$if(date)$
  date: [$date$],
$else$
  date: none,
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
  toc: false,
  doc,
)
$if(toc)$
#sidenote(numbered: false)[#outline(title: none, depth: $if(toc-depth)$$toc-depth$$else$2$endif$)]
$endif$
