-- vdots.readaloud.frontmatter — detect and parse an "enhanced read-aloud"
-- YAML frontmatter block. Pure; a minimal YAML subset (the only shapes the
-- contract uses): top-level `key: value` scalars, one nested map under
-- `pronunciation:`, one list under `sections:`, `#` comments.
--
-- A file is enhanced if it opens with `---` … `---` and the block has a
-- `format:` containing "read-aloud", OR carries `pronunciation:` + `sections:`
-- + `spoken_minutes:` together. The block is never spoken — it drives publish.

local M = {}

local function unquote(s)
  s = vim.trim(s)
  local q = s:match "^['\"](.*)['\"]$"
  return q or s
end

---@param lines string[]
---@return { enhanced: boolean, present: boolean, fm: table, body_start: integer }
function M.parse(lines)
  local fm = {
    title = nil,
    lang = "en-US",
    pronunciation = {},
    sections = {},
    spoken_minutes = nil,
    source = nil,
    generated_at = nil,
    format = nil,
    kind = nil,
  }
  if lines[1] ~= "---" then
    return { enhanced = false, present = false, fm = fm, body_start = 1 }
  end
  local close
  for j = 2, #lines do
    if lines[j] == "---" or lines[j] == "..." then
      close = j
      break
    end
  end
  if not close then
    return { enhanced = false, present = false, fm = fm, body_start = 1 }
  end

  local section = nil -- "pronunciation" | "sections" while inside a nested block
  for j = 2, close - 1 do
    local line = lines[j]
    if line:match "^%s*#" or line:match "^%s*$" then -- comment / blank
      goto continue
    end
    if line:match "^%s+%-%s+" or line:match "^%-%s+" then
      -- list item (indented or flush, YAML allows both under a key)
      if section == "sections" then
        fm.sections[#fm.sections + 1] = unquote(line:match "%-%s+(.+)$" or "")
      end
    elseif line:match "^%s+%S" and section == "pronunciation" then
      -- nested map entry:  <term>: <hint>
      local term, hint = line:match "^%s+(.-):%s*(.*)$"
      if term and term ~= "" then
        fm.pronunciation[vim.trim(term)] = unquote(hint)
      end
    else
      local key, val = line:match "^([%w_%-]+):%s*(.*)$"
      if key then
        key = key:lower()
        val = vim.trim(val)
        if val == "" and (key == "pronunciation" or key == "sections") then
          section = key
        else
          section = nil
          if key == "title" then
            fm.title = unquote(val)
          elseif key == "lang" then
            fm.lang = unquote(val)
          elseif key == "source" then
            fm.source = unquote(val)
          elseif key == "generated_at" then
            fm.generated_at = unquote(val)
          elseif key == "format" then
            fm.format = unquote(val)
          elseif key == "kind" then
            fm.kind = unquote(val)
          elseif key == "spoken_minutes" then
            fm.spoken_minutes = tonumber(unquote(val))
          end
        end
      end
    end
    ::continue::
  end

  local enhanced = (fm.format and fm.format:lower():find "read%-aloud") ~= nil
    or (next(fm.pronunciation) ~= nil and #fm.sections > 0 and fm.spoken_minutes ~= nil)

  return { enhanced = enhanced, present = true, fm = fm, body_start = close + 1 }
end

return M
