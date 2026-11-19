# quarto-tufte-a4

A Quarto Typst format (`tufte-typst`) with a Tufte-style layout: margin figures,
margin notes, and ACS-style chemistry citations. It is a patched copy of the
Typst package `toffee-tufte` 0.1.1, bundled as a Quarto extension.

## Use in a project

```bash
quarto add EricLarG4/quarto-tufte-a4
```

Then set the format in the YAML:

```yaml
format: tufte-typst
bibliographystyle: chem-authors.csl
bibliography: references.bib
```

`chem-authors.csl` must sit in the document root: Typst rejects bibliography
paths that contain underscores or escape the package root.

## Patches to upstream toffee-tufte

- A4 page layout (`paper: "a4"`).
- Body text 10 pt, title 13 pt, headings 12/11/10 pt, right margin 2.6 in.
- `cite(style: "chem-authors.csl")` set by default.
- Multi-key sidecite and a `toc-depth` template parameter.
- Sans fonts limited to those usually installed (Noto Sans, Atkinson
  Hyperlegible, Segoe UI, Arial). Typst warns for each unknown family.
- PDF author metadata is set only for string authors. Quarto passes an array
  of content, which Typst rejects for `set document(author:)`.
- The running header omits the author line.

The original `LICENSE` is kept.
