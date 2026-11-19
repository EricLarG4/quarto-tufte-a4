-- Append the full reference list at the end of a tufte-a4-typst document,
-- only when `suppress-bibliography: false` is set explicitly.
-- Quarto's own list is always suppressed here so the two never both appear.
-- The extension defaults suppress-bibliography to true, so an absent flag hides the list.
-- `full-csl` (document meta) names the full-reference CSL, relative to the document.
-- `full: true` lists every entry in the bibliography file, not only the cited ones.
-- Run after sidecite.lua (filter order), so the merge margin notes register
-- the typst citations.
function Pandoc(doc)
  if FORMAT ~= "typst" then
    return doc
  end
  local suppress = doc.meta["suppress-bibliography"]
  if suppress ~= false and (suppress == nil or pandoc.utils.stringify(suppress) ~= "false") then
    return doc
  end
  local csl = doc.meta["full-csl"] and pandoc.utils.stringify(doc.meta["full-csl"]) or "chem-full.csl"
  local bib = pandoc.utils.stringify(doc.meta.bibliography)
  doc.meta["suppress-bibliography"] = true
  doc.blocks:insert(pandoc.RawBlock("typst",
    '#heading(numbering: none)[References]\n' ..
    '#bibliography("' .. bib .. '", style: "' .. csl .. '", title: none, full: true)'))
  return doc
end
