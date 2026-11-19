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
bibliography: references.bib
```

## YAML options

Set these in the document YAML, under the `tufte-typst` format or at the top level:

| Option | Default | What it does |
|--------|---------|--------------|
| `fig-cap-location` | unset | `margin` puts figure captions in the margin. Set it in the document YAML, not the extension. |
| `tbl-cap-location` | unset | `margin` puts table captions in the margin. |
| `toc` | `false` | Shows the table of contents in the margin, not the title block. |
| `toc-depth` | `2` | Number of heading levels in the table of contents. |
| `section-numbering` | `"1.1.1"` | Heading numbering scheme (Quarto option). |
| `bibliographystyle` | unset | CSL file for citations. Not shipped as a document-level file. See Citations. |
| `suppress-bibliography` | `true` | `true` hides the end-of-document reference list but keeps citations working. |
| `sidecite` | `merge` | Filter option. `merge` gives one margin note per paragraph with its references. `off` gives numbered citations only. |

| `title`, `author`, `date`, `abstract` | none | Quarto metadata, shown on the title block. |
| `papersize` | `a4` | Page size (Quarto option). |
| `dpi` | `300` | Resolution for pixel images (Quarto option). |
| `columns` | `1` | Number of text columns (Quarto option). |

The `papersize`, `dpi`, `columns` and `section-numbering` options are Quarto's
built-in settings and are not handled by the extension's own template code.
Their effect has not been tested.

## Citations

- Inline citations are compact numbers in square brackets, such as `[1]`.
- Margin notes (`sidecite: merge`) list the full reference for every key cited
  in that paragraph.
- The end-of-document list (`suppress-bibliography: false`) uses full
  references.
- The same CSL file controls both the compact and full forms. The margin notes
  use `form: "full"` and the inline marks use the default compact form.
- The package applies a default CSL style. Whether setting `bibliographystyle`
  to another CSL file overrides it is untested.

## Patches to upstream toffee-tufte

- A4 page layout (`paper: "a4"`).
- Body text 10 pt, title 13 pt, headings 12/11/10 pt, right margin 2.6 in.
- A default citation style is set by the package.
- Multi-key sidecite and a `toc-depth` template parameter.
- Sans fonts limited to those usually installed (Noto Sans, Atkinson
  Hyperlegible, Segoe UI, Arial). Typst warns for each unknown family.
- PDF author metadata is set only for string authors. Quarto passes an array
  of content, which Typst rejects for `set document(author:)`.
- The running header omits the author line.

The original `LICENSE` is kept.
