-- vdots.readaloud.parse — Markdown (GFM) → ordered speech blocks.
--
-- Pure: no editor state, no side effects. This is the tested seam.
-- Line-based (GFM block structure is line anchored). One block per logical unit
-- (heading, paragraph, list item, table row, block quote, fenced-code
-- announcement) so playback control ("jump up/down", "re-read from this line")
-- lands on sensible boundaries.
--
--   parse(lines, opts) -> blocks
--   blocks[i] = { s = <src line, 1-based>, e = <src line>, speak = <string> }

local M = {}

local ENTITIES = {
  ["&amp;"] = " and ",
  ["&lt;"] = " less than ",
  ["&gt;"] = " greater than ",
  ["&nbsp;"] = " ",
  ["&mdash;"] = " — ",
  ["&ndash;"] = " – ",
  ["&hellip;"] = " … ",
  ["&quot;"] = '"',
  ["&#39;"] = "'",
  ["&apos;"] = "'",
}

---Strip inline Markdown / HTML markup down to spoken text.
---@param s string
---@return string
function M.clean_inline(s)
  s = s:gsub("<!%-%-.-%-%->", "") -- HTML comments
  s = s:gsub("<https?://[^>]+>", " link ") -- autolinks (before HTML-tag strip)
  s = s:gsub("<[%a/][%a%d]*[^>]*>", "") -- HTML tags (keep inner text)
  s = s:gsub("!%[([^%]]*)%]%([^)]*%)", "%1") -- images -> alt text
  s = s:gsub("%[([^%]]*)%]%([^)]*%)", "%1") -- inline links -> link text
  s = s:gsub("%[([^%]]*)%]%[[^%]]*%]", "%1") -- reference links -> link text
  s = s:gsub("%[%^[^%]]+%]", "") -- footnote markers [^1]
  s = s:gsub("https?://%S+", " link ") -- bare URLs
  s = s:gsub("`([^`]*)`", "%1") -- inline code
  s = s:gsub("~~([^~]*)~~", "%1") -- strikethrough
  s = s:gsub("%*%*?([^%*]+)%*?%*", "%1") -- **bold** / *italic*
  s = s:gsub("%f[%w_]_([^_]+)_%f[^%w_]", "%1") -- _italic_ at word boundaries
  s = s:gsub("%s+\\$", "") -- trailing hard-break backslash
  s = s:gsub("%b{}", "") -- {#anchor} / {.class} attributes
  for ent, rep in pairs(ENTITIES) do
    s = s:gsub(ent, rep)
  end
  s = s:gsub("&#%d+;", " ")
  s = s:gsub("%s+", " ")
  return vim.trim(s)
end

local clean = M.clean_inline

local function is_blank(l)
  return l:match "^%s*$" ~= nil
end
local function fence_lang(l)
  return l:match "^%s*```+%s*([%w_+-]*)"
end
local function is_fence(l)
  return l:match "^%s*```+" ~= nil
end
local function is_hrule(l)
  return l:match "^%s*%-%-%-+%s*$" ~= nil
    or l:match "^%s*%*%*%*+%s*$" ~= nil
    or l:match "^%s*___+%s*$" ~= nil
end
local function atx_heading(l)
  local h, rest = l:match "^(#+)%s+(.*)$"
  if h then
    return #h, (rest:gsub("%s+#+%s*$", ""))
  end
end
local function quote_body(l)
  return l:match "^%s*>%s?(.*)$"
end
local function list_body(l)
  local task, rest = l:match "^%s*[-*+]%s+%[([ xX])%]%s+(.*)$"
  if task then
    return (task == " " and "to do: " or "done: ") .. rest
  end
  return l:match "^%s*[-*+]%s+(.*)$" or l:match "^%s*%d+[.)]%s+(.*)$"
end
local function is_table_row(l)
  return l:match "^%s*|.*|%s*$" ~= nil
end
local function is_table_sep(l)
  return l:match "^%s*|?[%s:|-]*%-[%s:|-]*|?%s*$" ~= nil and l:match "%-" ~= nil
end
local function is_ref_def(l)
  return l:match "^%s*%[[^%]]+%]:%s+%S+" ~= nil
end

local function cells(l)
  local parts = vim.split(vim.trim(l), "|", { plain = true })
  if parts[1] == "" then
    table.remove(parts, 1)
  end
  if #parts > 0 and parts[#parts] == "" then
    table.remove(parts, #parts)
  end
  return vim.tbl_map(clean, parts)
end

---@param lines string[] 1-based list of source lines
---@param opts table? { skip_code?, skip_tables?, enhanced?, skip_frontmatter?, title? }
---@return { s: integer, e: integer, speak: string, kind: string, text: string }[]
function M.parse(lines, opts)
  opts = opts or {}
  local skip_code = opts.skip_code ~= false
  local skip_tables = opts.skip_tables == true
  local enhanced = opts.enhanced == true

  local blocks = {}
  local n = #lines
  local i = 1
  -- `speak` = the TTS form ("Heading level 2. Foo."); `text` = the verbatim
  -- reading-transcript prose ("Foo"), defaulting to `speak`.
  local function emit(s, e, speak, kind, text)
    speak = vim.trim(speak or "")
    if speak ~= "" then
      blocks[#blocks + 1] = {
        s = s,
        e = e,
        speak = speak,
        kind = kind or "para",
        text = vim.trim(text or speak),
      }
    end
  end

  -- An explicit title (from a caller that already parsed the frontmatter).
  -- Enhanced docs open with just the title; plain docs get a "Title." cue.
  if opts.title and opts.title ~= "" then
    local t = clean(opts.title)
    emit(1, 1, enhanced and t or ("Title. " .. t), "title", t)
  end

  -- Frontmatter: leading `---` ... `---`. `skip_frontmatter` = the caller
  -- already stripped it and passed body-only lines.
  if not opts.skip_frontmatter and lines[1] == "---" then
    for j = 2, n do
      if lines[j] == "---" or lines[j] == "..." then
        if not opts.title then
          for k = 2, j - 1 do
            local title = lines[k]:match "^title:%s*(.+)$"
            if title then
              title = title:gsub("^[\"']", ""):gsub("[\"']$", "")
              emit(1, j, "Title. " .. clean(title), "title", clean(title))
            end
          end
        end
        i = j + 1
        break
      end
    end
  end

  -- Enhanced docs are already speech-ready: headings are spoken plainly (they
  -- double as chapter titles), no "Heading level N" / "Quote." announcements.
  local function hspeak(level, txt)
    return enhanced and clean(txt) or ("Heading level %d. %s."):format(level, clean(txt))
  end

  while i <= n do
    local line = lines[i]

    if is_fence(line) then
      local lang = fence_lang(line) or ""
      local close = n
      for k = i + 1, n do
        if is_fence(lines[k]) then
          close = k
          break
        end
      end
      if skip_code then
        local count = close - i - 1
        emit(
          i,
          close,
          ("Code block. %s. %d line%s."):format(
            lang ~= "" and lang or "unknown language",
            count,
            count == 1 and "" or "s"
          ),
          "code",
          ("(code block%s)"):format(lang ~= "" and (": " .. lang) or "")
        )
      else
        for k = i + 1, close - 1 do
          if not is_blank(lines[k]) then
            emit(k, k, lines[k], "code", lines[k])
          end
        end
      end
      i = close + 1
    elseif is_hrule(line) or is_blank(line) or is_ref_def(line) then
      i = i + 1
    elseif atx_heading(line) then
      local level, text = atx_heading(line)
      emit(i, i, hspeak(level, text), "heading", clean(text))
      i = i + 1
    elseif lines[i + 1] and lines[i + 1]:match "^%s*=+%s*$" and not is_blank(line) then
      emit(i, i + 1, hspeak(1, line), "heading", clean(line))
      i = i + 2
    elseif
      lines[i + 1]
      and lines[i + 1]:match "^%s*%-%-+%s*$"
      and not is_blank(line)
      and not list_body(line)
    then
      emit(i, i + 1, hspeak(2, line), "heading", clean(line))
      i = i + 2
    elseif is_table_row(line) then
      local start = i
      local rows = {}
      while i <= n and is_table_row(lines[i]) do
        if not is_table_sep(lines[i]) then
          rows[#rows + 1] = cells(lines[i])
        end
        i = i + 1
      end
      if skip_tables then
        emit(
          start,
          i - 1,
          ("Table. %d rows."):format(math.max(#rows - 1, 0)),
          "table",
          ("(table, %d rows)"):format(math.max(#rows - 1, 0))
        )
      else
        local header = rows[1] or {}
        for r = 2, #rows do
          local parts = {}
          for c, val in ipairs(rows[r]) do
            local h = header[c]
            parts[#parts + 1] = (h and h ~= "") and (h .. ": " .. val) or val
          end
          emit(start, i - 1, table.concat(parts, ". ") .. ".", "table", table.concat(parts, ", "))
        end
      end
    elseif quote_body(line) then
      local start = i
      local buf = {}
      while i <= n and quote_body(lines[i]) do
        buf[#buf + 1] = quote_body(lines[i])
        i = i + 1
      end
      local qt = clean(table.concat(buf, " "))
      emit(start, i - 1, (enhanced and "" or "Quote. ") .. qt, "quote", qt)
    elseif list_body(line) then
      emit(i, i, clean(list_body(line)), "list")
      i = i + 1
    else
      local start = i
      local buf = {}
      while i <= n do
        local l = lines[i]
        if
          is_blank(l)
          or is_fence(l)
          or atx_heading(l)
          or quote_body(l)
          or list_body(l)
          or is_table_row(l)
          or is_hrule(l)
        then
          break
        end
        buf[#buf + 1] = l
        i = i + 1
      end
      emit(start, i - 1, clean(table.concat(buf, " ")))
    end
  end

  return blocks
end

---Frontmatter-aware parse: detect an enhanced read-aloud block, strip it, and
---parse the body with the right mode. The one entry point for every caller
---(player, preview, the CLI bridge).
---@param lines string[]
---@param opts table? merged into parse opts (skip_code / skip_tables …)
---@return { blocks: table, enhanced: boolean, present: boolean, fm: table }
function M.document(lines, opts)
  opts = opts or {}
  local fmres = require("vdots.readaloud.frontmatter").parse(lines)
  local body = fmres.present and vim.list_slice(lines, fmres.body_start, #lines) or lines
  local blocks = M.parse(
    body,
    vim.tbl_extend("force", opts, {
      enhanced = fmres.enhanced,
      skip_frontmatter = fmres.present,
      title = fmres.enhanced and fmres.fm.title or nil,
    })
  )
  return { blocks = blocks, enhanced = fmres.enhanced, present = fmres.present, fm = fmres.fm }
end

return M
