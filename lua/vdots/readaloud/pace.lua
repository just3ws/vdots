-- vdots.readaloud.pace — well-paced delivery: a slower rate plus brief,
-- natural silences at paragraph and section boundaries so you can follow along
-- without it dragging.
--
-- The silences use `say`'s inline `[[slnc N]]` command (N milliseconds).

local M = {}

-- preset -> { rate (say -r wpm), para (ms between paragraphs / list items),
--             section (ms before a heading), after_heading (ms after it) }
M.presets = {
  follow = { rate = 160, para = 400, section = 750, after_heading = 250 },
  relaxed = { rate = 185, para = 300, section = 550, after_heading = 200 },
  natural = { rate = 210, para = 170, section = 350, after_heading = 120 },
}

---@param cfg table resolved vdots.readaloud config
---@return { rate: integer, para: integer, section: integer, after_heading: integer }
function M.settings(cfg)
  local p = M.presets[cfg.pace] or M.presets.follow
  return {
    rate = tonumber(cfg.rate) or p.rate,
    para = p.para,
    section = p.section,
    after_heading = p.after_heading,
  }
end

---Silence (ms) to place BEFORE `kind`, given the previous block's kind.
---@param prev string?
---@param kind string
---@param s table result of M.settings
---@return integer
function M.lead(prev, kind, s)
  if not prev then
    return 0
  end
  if kind == "heading" then
    return s.section
  end
  if prev == "heading" or prev == "title" then
    return s.after_heading
  end
  if kind == "list" and prev == "list" then
    return math.floor(s.para * 0.55) -- keep lists moving
  end
  return s.para
end

---`say` inline silence marker, or "" for a zero gap.
---@param ms integer
---@return string
function M.marker(ms)
  return ms > 0 and ("[[slnc %d]] "):format(ms) or ""
end

---Join parsed blocks into one spoken script with paced silences between them.
---@param blocks { speak: string, kind: string }[]
---@param cfg table
---@return string
function M.script(blocks, cfg)
  local s = M.settings(cfg)
  local out = {}
  local prev
  for _, b in ipairs(blocks) do
    out[#out + 1] = M.marker(M.lead(prev, b.kind, s)) .. b.speak
    prev = b.kind
  end
  return table.concat(out, "\n")
end

return M
