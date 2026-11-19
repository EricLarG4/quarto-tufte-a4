// Tufte format for Quarto, wrapping the toffee-tufte Typst package
// (https://typst.app/universe/package/toffee-tufte).
//
// This file imports the package's `template` function, which typst-show.typ
// applies with the Pandoc metadata mapped to its arguments.
#import "@preview/toffee-tufte:0.1.1": *

// Quarto's biblio.typ emits the bibliography with an auto-generated
// "Bibliography" heading; report.qmd already has a "## References"
// heading in markdown, so suppress the typst one.
#set bibliography(title: none)
