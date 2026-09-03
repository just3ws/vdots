-- vdots.readaloud.pace — human read-aloud cadence. A measured rate, real
-- silence between every word, a beat at every clause mark, a longer rest at
-- sentence ends, and bigger gaps between paragraphs and before sections —
-- the space a person leaves when reading aloud, not a rushed TTS dump.
--
-- All silences use `say`'s inline `[[slnc N]]` command (N milliseconds).
-- `word` / `clause` / `sentence` are within a block; `para` / `section` /
-- `after_heading` are between blocks.

local M = {}

-- preset -> { rate (say -r wpm),
--             para (ms between paragraphs / list items),
--             section (ms before a heading), after_heading (ms after it),
--             word (ms of air between words),
--             clause (ms beat at , ; : — ), sentence (ms beat at . ! ?) }
M.presets = {
  follow = {
    rate = 155,
    para = 480,
    section = 820,
    after_heading = 300,
    word = 22,
    clause = 115,
    sentence = 360,
  },
  relaxed = {
    rate = 175,
    para = 360,
    section = 600,
    after_heading = 230,
    word = 14,
    clause = 90,
    sentence = 280,
  },
  natural = {
    rate = 200,
    para = 200,
    section = 380,
    after_heading = 140,
    word = 0,
    clause = 55,
    sentence = 190,
  },
}

---@param cfg table resolved vdots.readaloud config
---@return { rate: integer, para: integer, section: integer, after_heading: integer, word: integer, clause: integer, sentence: integer }
function M.settings(cfg)
  local p = M.presets[cfg.pace] or M.presets.follow
  return {
    rate = tonumber(cfg.rate) or p.rate,
    para = p.para,
    section = p.section,
    after_heading = p.after_heading,
    word = p.word,
    clause = p.clause,
    sentence = p.sentence,
  }
end

---Add breathing room WITHIN a block: a hair of air between words, a short beat
---at clause punctuation, a longer one at sentence ends. Returns the marked-up
---text and the total silence (seconds) it added, so cue timing stays honest.
---@param text string
---@param s table result of M.settings
---@return string, number
function M.breathe(text, s)
  text = vim.trim((tostring(text):gsub("%s+", " ")))
  if text == "" then
    return text, 0
  end
  local wm = (s.word or 0) > 0 and M.marker(s.word) or ""
  local parts, nwords, nclause, nsent = {}, 0, 0, 0
  for w in text:gmatch "%S+" do
    nwords = nwords + 1
    local tail = ""
    if w:match "[.!?][\"'%)%]]*$" then
      tail, nsent = " " .. M.marker(s.sentence or 0), nsent + 1
    elseif w:match "[,;:—–][\"'%)%]]*$" then
      tail, nclause = " " .. M.marker(s.clause or 0), nclause + 1
    end
    parts[#parts + 1] = w .. tail
  end
  local added = (nwords - 1) * (s.word or 0) + nclause * (s.clause or 0) + nsent * (s.sentence or 0)
  return table.concat(parts, " " .. wm), added / 1000
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
    local spoken = (M.breathe(b.speak, s))
    out[#out + 1] = M.marker(M.lead(prev, b.kind, s)) .. spoken
    prev = b.kind
  end
  return table.concat(out, "\n")
end

local function words(str)
  local w = 0
  for _ in tostring(str):gmatch "%S+" do
    w = w + 1
  end
  return w
end

local function ts(sec)
  local ms = math.floor((sec % 1) * 1000 + 0.5)
  sec = math.floor(sec)
  local h = math.floor(sec / 3600)
  local m = math.floor((sec % 3600) / 60)
  return ("%02d:%02d:%02d.%03d"):format(h, m, sec % 60, ms)
end

---Estimate a timed cue per block for a WebVTT transcript.
---
---`say` gives no timing data, so time is modelled: total = (spoken words ÷ rate)
---scaled to the real audio duration, plus the exact `[[slnc]]` pauses we
---inserted. Block-level, not word-level — enough to highlight the paragraph
---being read.
local function sentences(str)
  local out = {}
  for chunk in tostring(str):gmatch "[^.!?]+[.!?]*" do
    chunk = vim.trim(chunk)
    if chunk ~= "" then
      out[#out + 1] = chunk
    end
  end
  if #out == 0 and vim.trim(str) ~= "" then
    out[1] = vim.trim(str)
  end
  return out
end

---Estimate a timed cue per block (or per sentence, `opts.sentences`) for a
---WebVTT transcript.
---
---`say` gives no timing data, so time is modelled: total = (spoken words ÷ rate)
---scaled to the real audio duration, plus the exact `[[slnc]]` pauses we
---inserted. Block/sentence level, not word level.
---@param blocks { speak: string, kind: string, text: string }[]
---@param cfg table
---@param total_dur number seconds of the rendered audio
---@param opts { sentences?: boolean }?
---@return { start: number, stop: number, text: string, kind: string }[]
function M.cues(blocks, cfg, total_dur, opts)
  opts = opts or {}
  local s = M.settings(cfg)
  local total_words, total_pause = 0, 0
  local prev
  for _, b in ipairs(blocks) do
    local _, bp = M.breathe(b.speak, s)
    total_words = total_words + words(b.speak)
    total_pause = total_pause + M.lead(prev, b.kind, s) / 1000 + bp
    prev = b.kind
  end
  local speech = math.max((tonumber(total_dur) or 0) - total_pause, 0.1)
  local per_word = total_words > 0 and (speech / total_words) or 0

  local cues, t = {}, 0
  prev = nil
  for _, b in ipairs(blocks) do
    local _, bp = M.breathe(b.speak, s)
    t = t + M.lead(prev, b.kind, s) / 1000
    local block_dur = math.max(words(b.speak) * per_word + bp, 0.4)
    if opts.sentences and b.kind ~= "heading" then
      local sents = sentences(b.text)
      local bw = 0
      for _, sent in ipairs(sents) do
        bw = bw + words(sent)
      end
      for _, sent in ipairs(sents) do
        local d = bw > 0 and (block_dur * words(sent) / bw) or (block_dur / #sents)
        cues[#cues + 1] = { start = t, stop = t + d, text = sent, kind = b.kind }
        t = t + d
      end
    else
      cues[#cues + 1] = { start = t, stop = t + block_dur, text = b.text, kind = b.kind }
      t = t + block_dur
    end
    prev = b.kind
  end
  return cues
end

---Rough spoken duration (seconds) before rendering: words ÷ wpm + the beats.
---@param blocks table
---@param cfg table
---@return number
function M.estimate(blocks, cfg)
  local s = M.settings(cfg)
  local w, pause, prev = 0, 0, nil
  for _, b in ipairs(blocks) do
    local _, bp = M.breathe(b.speak, s)
    w = w + words(b.speak)
    pause = pause + M.lead(prev, b.kind, s) / 1000 + bp
    prev = b.kind
  end
  return w / (s.rate / 60) + pause
end

---Chapter markers from the heading blocks. `sections` (if given) supplies the
---canonical titles/order — only headings whose text matches a section become
---chapters.
---@param blocks table
---@param cfg table
---@param total_dur number
---@param sections string[]?
---@return { start: number, title: string }[]
function M.chapters(blocks, cfg, total_dur, sections)
  local want = {}
  for _, name in ipairs(sections or {}) do
    want[vim.trim(name):lower()] = name
  end
  local out = {}
  for _, c in ipairs(M.cues(blocks, cfg, total_dur)) do
    if c.kind == "heading" then
      local canon = want[vim.trim(c.text):lower()]
      if canon or not sections or #sections == 0 then
        out[#out + 1] = { start = c.start, title = canon or c.text }
      end
    end
  end
  return out
end

---@param chapters { start: number, title: string }[]
---@param total_dur number
---@return string
function M.chapters_vtt(chapters, total_dur)
  local out = { "WEBVTT", "", "NOTE Chapters", "" }
  for i, ch in ipairs(chapters) do
    local stop = chapters[i + 1] and chapters[i + 1].start or (tonumber(total_dur) or ch.start + 1)
    out[#out + 1] = ("Chapter %d"):format(i)
    out[#out + 1] = ("%s --> %s"):format(ts(ch.start), ts(stop))
    out[#out + 1] = (ch.title:gsub("%s+", " "))
    out[#out + 1] = ""
  end
  return table.concat(out, "\n")
end

---Render blocks + audio duration to a WebVTT transcript string.
---@param blocks table
---@param cfg table
---@param total_dur number
---@param opts { sentences?: boolean }?
---@return string
function M.vtt(blocks, cfg, total_dur, opts)
  local out = { "WEBVTT", "" }
  for i, c in ipairs(M.cues(blocks, cfg, total_dur, opts)) do
    out[#out + 1] = tostring(i)
    out[#out + 1] = ("%s --> %s"):format(ts(c.start), ts(c.stop))
    out[#out + 1] = (c.text:gsub("%s+", " "))
    out[#out + 1] = ""
  end
  return table.concat(out, "\n")
end

return M
