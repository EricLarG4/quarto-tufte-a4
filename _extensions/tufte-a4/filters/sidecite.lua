-- Place the full references of bracketed citations ([@key], [@a; @b]) in the
-- right margin, next to the paragraph that cites them.
--
-- YAML option `sidecite` (document meta):
--   merge (default): one margin note per paragraph listing the full reference
--                    of every key cited in it; inline numbered citations stay.
--   off:             no margin notes; plain numbered citations only.
--                    Also set `suppress-bibliography: false` to list references.
--
-- NOTE: this filter is registered FORMAT-SCOPED (under tufte-typst in the
-- doc yaml), so it only runs for tufte-typst renders — plain `--to typst`
-- keeps pandoc citations and cannot hit "unknown variable: sidenote".
-- Written as a Pandoc-level walk because quarto's filter pipeline does not
-- always provide PANDOC_DOCUMENT.
local function cited_keys(el)
  local keys, seen = {}, {}
  el:walk {
    Cite = function(c)
      for _, cit in ipairs(c.citations) do
        if cit.mode == "NormalCitation" and not seen[cit.id] then
          seen[cit.id] = true
          keys[#keys + 1] = cit.id
        end
      end
    end,
  }
  return keys
end

local function merge_note(el)
  local keys = cited_keys(el)
  if #keys == 0 then
    return nil
  end
  local refs = {}
  for _, k in ipairs(keys) do
    refs[#refs + 1] = '#cite(<' .. k .. '>, form: "full")'
  end
  local raw = '#sidenote(numbered: false)[' .. table.concat(refs, '#linebreak()') .. ']'
  table.insert(el.content, 1, pandoc.RawInline("typst", raw))
  return el
end

function Pandoc(doc)
  if FORMAT ~= "typst" then
    return doc
  end
  local mode = doc.meta.sidecite and pandoc.utils.stringify(doc.meta.sidecite) or "merge"
  if mode == "off" then
    return doc
  end
  return doc:walk {
    Para = merge_note,
    Plain = merge_note,
  }
end
