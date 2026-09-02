-- editor/readaloud.lua — read a Markdown buffer aloud, following along with the text.
--
-- Engine: macOS `say` (offline, built in). macOS only — every entry point guards
-- on `vim.fn.executable("say")`.
--
-- Parsing is line based (GitHub-flavored Markdown block structure is line
-- anchored: headings, fences, block quotes, list items, tables, blank-line
-- separated paragraphs). No Tree-sitter dependency; `M.parse` is a pure function
-- and the tested seam. Frontmatter (`---` fenced YAML at the top) is skipped.
--
-- Public API:
--   M.start({ from_cursor = bool })   M.stop()   M.toggle_pause()
--   M.next()   M.prev()   M.read_current()   M.export({ line1, line2 })
--   M.parse(lines, opts) -> utterances          (pure)

local M = {}

local DEFAULTS = {
  voice = nil, -- `say -v ?` to list; nil = system default
  rate = 220, -- words per minute
  skip_code = true, -- announce fenced code blocks instead of reading them
  skip_tables = false, -- read tables row by row
  stop_on_edit = true, -- halt playback when the buffer is modified
  player = nil, -- external player for :VdotsReadExport; nil = vim.ui.open
}

local function cfg()
  return vim.tbl_extend("force", DEFAULTS, vim.g.vdots_readaloud or {})
end

--------------------------------------------------------------------------------
-- Parsing
--------------------------------------------------------------------------------

---Strip inline Markdown markup down to spoken text.
---@param s string
---@return string
local function clean_inline(s)
  s = s:gsub("<!%-%-.-%-%->", "") -- HTML comments
  s = s:gsub("!%[([^%]]*)%]%([^)]*%)", "%1") -- images -> alt text
  s = s:gsub("%[([^%]]*)%]%([^)]*%)", "%1") -- inline links -> link text
  s = s:gsub("%[([^%]]*)%]%[[^%]]*%]", "%1") -- reference links -> link text
  s = s:gsub("`([^`]*)`", "%1") -- inline code
  s = s:gsub("~~([^~]*)~~", "%1") -- strikethrough
  s = s:gsub("%*+", "") -- bold / italic asterisks
  s = s:gsub("%s+\\$", "") -- trailing hard-break backslash
  s = s:gsub("%s+", " ")
  return vim.trim(s)
end

---Split a blob into sentence-sized utterance strings.
---@param s string
---@return string[]
local function sentences(s)
  local out = {}
  for chunk in s:gmatch "[^.!?]+[.!?]*" do
    chunk = vim.trim(chunk)
    if chunk ~= "" then
      out[#out + 1] = chunk
    end
  end
  if #out == 0 and vim.trim(s) ~= "" then
    out[1] = vim.trim(s)
  end
  return out
end

local function is_blank(l)
  return l:match "^%s*$" ~= nil
end
local function fence_at(l)
  return l:match "^%s*```+%s*([%w_+-]*)"
end
local function is_fence(l)
  return l:match "^%s*```+" ~= nil
end
local function heading_at(l)
  local hashes, rest = l:match "^(#+)%s+(.*)$"
  if hashes then
    return #hashes, (rest:gsub("%s+#+%s*$", ""))
  end
end
local function quote_at(l)
  return l:match "^%s*>%s?(.*)$"
end
local function list_at(l)
  return l:match "^%s*[-*+]%s+(.*)$" or l:match "^%s*%d+[.)]%s+(.*)$"
end
local function table_row(l)
  return l:match "^%s*|.*|%s*$" ~= nil
end
local function table_sep(l)
  return l:match "^%s*|[%s:|-]+|%s*$" ~= nil
end

local function cells(l)
  local parts = vim.split(vim.trim(l), "|", { plain = true })
  -- A well-formed row is `| a | b |` → leading/trailing empty fields; drop them.
  if parts[1] == "" then
    table.remove(parts, 1)
  end
  if #parts > 0 and parts[#parts] == "" then
    table.remove(parts, #parts)
  end
  return vim.tbl_map(clean_inline, parts)
end

---Parse buffer lines into ordered utterances.
---@param lines string[] 1-based list of buffer lines
---@param opts table? overrides for skip_code / skip_tables
---@return { s: integer, e: integer, text: string }[] # line numbers are 1-based
function M.parse(lines, opts)
  opts = vim.tbl_extend("force", cfg(), opts or {})
  local u = {}
  local n = #lines
  local i = 1

  -- Frontmatter: leading `---` ... `---`
  if lines[1] == "---" then
    for j = 2, n do
      if lines[j] == "---" or lines[j] == "..." then
        for k = 2, j - 1 do
          local title = lines[k]:match "^title:%s*(.+)$"
          if title then
            title = title:gsub("^[\"']", ""):gsub("[\"']$", "")
            u[#u + 1] = { s = 1, e = j, text = "Title. " .. clean_inline(title) }
          end
        end
        i = j + 1
        break
      end
    end
  end

  while i <= n do
    local line = lines[i]

    if is_fence(line) then
      local lang = fence_at(line) or ""
      local close = n
      for k = i + 1, n do
        if is_fence(lines[k]) then
          close = k
          break
        end
      end
      if opts.skip_code then
        local count = close - i - 1
        u[#u + 1] = {
          s = i,
          e = close,
          text = ("Code block. %s. %d line%s."):format(
            lang ~= "" and lang or "unknown language",
            count,
            count == 1 and "" or "s"
          ),
        }
      else
        for k = i + 1, close - 1 do
          if not is_blank(lines[k]) then
            u[#u + 1] = { s = k, e = k, text = lines[k] }
          end
        end
      end
      i = close + 1
    elseif heading_at(line) then
      local level, text = heading_at(line)
      u[#u + 1] =
        { s = i, e = i, text = ("Heading level %d. %s."):format(level, clean_inline(text)) }
      i = i + 1
    elseif is_blank(line) then
      i = i + 1
    elseif table_row(line) then
      local start = i
      local rows = {}
      while i <= n and table_row(lines[i]) do
        if not table_sep(lines[i]) then
          rows[#rows + 1] = cells(lines[i])
        end
        i = i + 1
      end
      if opts.skip_tables then
        u[#u + 1] =
          { s = start, e = i - 1, text = ("Table. %d rows."):format(math.max(#rows - 1, 0)) }
      else
        local header = rows[1] or {}
        for r = 2, #rows do
          local parts = {}
          for c, val in ipairs(rows[r]) do
            local h = header[c]
            parts[#parts + 1] = (h and h ~= "") and (h .. ": " .. val) or val
          end
          u[#u + 1] = { s = start, e = i - 1, text = table.concat(parts, ". ") .. "." }
        end
      end
    elseif quote_at(line) then
      local start = i
      local buf = {}
      while i <= n and quote_at(lines[i]) do
        buf[#buf + 1] = quote_at(lines[i])
        i = i + 1
      end
      local joined = clean_inline(table.concat(buf, " "))
      local parts = sentences(joined)
      for idx, sent in ipairs(parts) do
        u[#u + 1] = { s = start, e = i - 1, text = (idx == 1 and "Quote. " or "") .. sent }
      end
    elseif list_at(line) then
      u[#u + 1] = { s = i, e = i, text = clean_inline(list_at(line)) }
      i = i + 1
    else
      -- paragraph: gather to blank or structural line
      local start = i
      local buf = {}
      while i <= n do
        local l = lines[i]
        if
          is_blank(l)
          or is_fence(l)
          or heading_at(l)
          or quote_at(l)
          or list_at(l)
          or table_row(l)
        then
          break
        end
        buf[#buf + 1] = l
        i = i + 1
      end
      local joined = clean_inline(table.concat(buf, " "))
      for _, sent in ipairs(sentences(joined)) do
        u[#u + 1] = { s = start, e = i - 1, text = sent }
      end
    end
  end

  return u
end

--------------------------------------------------------------------------------
-- Playback
--------------------------------------------------------------------------------

local ns = vim.api.nvim_create_namespace "vdots_readaloud"
local st =
  { utts = nil, idx = 0, buf = nil, win = nil, handle = nil, gen = 0, paused = false, aug = nil }

local function have_say()
  if vim.fn.executable "say" == 1 then
    return true
  end
  vim.notify("readaloud: `say` not found (macOS only)", vim.log.levels.ERROR)
  return false
end

local function clear_hl()
  if st.buf and vim.api.nvim_buf_is_valid(st.buf) then
    vim.api.nvim_buf_clear_namespace(st.buf, ns, 0, -1)
  end
end

local function highlight(u)
  clear_hl()
  if not (st.buf and vim.api.nvim_buf_is_valid(st.buf)) then
    return
  end
  vim.api.nvim_set_hl(0, "VdotsReadAloud", { link = "Search", default = true })
  local last = vim.api.nvim_buf_line_count(st.buf)
  for l = u.s, math.min(u.e, last) do
    pcall(vim.api.nvim_buf_set_extmark, st.buf, ns, l - 1, 0, { line_hl_group = "VdotsReadAloud" })
  end
  if st.win and vim.api.nvim_win_is_valid(st.win) then
    pcall(vim.api.nvim_win_set_cursor, st.win, { math.min(u.s, last), 0 })
    vim.api.nvim_win_call(st.win, function()
      vim.cmd "normal! zz"
    end)
  end
end

local function finish(msg)
  if st.handle then
    local h = st.handle
    st.handle = nil
    pcall(function()
      h:kill(15)
    end)
  end
  clear_hl()
  if st.aug then
    pcall(vim.api.nvim_del_augroup_by_id, st.aug)
    st.aug = nil
  end
  st.utts, st.idx, st.paused = nil, 0, false
  if msg then
    vim.notify("readaloud: " .. msg, vim.log.levels.INFO)
  end
end
M.stop = function()
  finish(nil)
end

local function speak()
  if not st.utts or st.idx < 1 or st.idx > #st.utts then
    return finish "done"
  end
  local u = st.utts[st.idx]
  highlight(u)
  if vim.trim(u.text) == "" then
    st.idx = st.idx + 1
    return speak()
  end

  local c = cfg()
  local args = { "say", "-r", tostring(c.rate) }
  if c.voice and c.voice ~= "" then
    vim.list_extend(args, { "-v", c.voice })
  end
  args[#args + 1] = u.text

  st.gen = st.gen + 1
  local gen = st.gen
  st.handle = vim.system(
    args,
    {},
    vim.schedule_wrap(function(obj)
      if gen ~= st.gen then
        return
      end -- superseded by stop/next/prev
      st.handle = nil
      if obj.code == 0 then
        st.idx = st.idx + 1
        speak()
      else
        finish "stopped"
      end
    end)
  )
end

---@param opts { from_cursor?: boolean, utts?: table, buf?: integer, win?: integer }
function M.start(opts)
  opts = opts or {}
  if not have_say() then
    return
  end
  finish(nil)

  st.buf = opts.buf or vim.api.nvim_get_current_buf()
  st.win = opts.win or vim.api.nvim_get_current_win()
  st.utts = opts.utts or M.parse(vim.api.nvim_buf_get_lines(st.buf, 0, -1, false))
  if #st.utts == 0 then
    return vim.notify("readaloud: nothing to read", vim.log.levels.WARN)
  end

  st.idx = 1
  if opts.from_cursor then
    local row = vim.api.nvim_win_get_cursor(st.win)[1]
    for k, u in ipairs(st.utts) do
      if u.e >= row then
        st.idx = k
        break
      end
    end
  end

  if cfg().stop_on_edit then
    st.aug = vim.api.nvim_create_augroup("vdots_readaloud_edit", { clear = true })
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
      group = st.aug,
      buffer = st.buf,
      callback = function()
        finish "stopped (buffer edited)"
      end,
    })
  end

  speak()
end

function M.toggle_pause()
  if not st.handle then
    return
  end
  local pid = st.handle.pid
  if st.paused then
    vim.uv.kill(pid, "sigcont")
    st.paused = false
  else
    vim.uv.kill(pid, "sigstop")
    st.paused = true
    vim.notify("readaloud: paused", vim.log.levels.INFO)
  end
end

local function skip(delta)
  if not st.utts then
    return
  end
  st.gen = st.gen + 1 -- orphan the in-flight callback
  if st.handle then
    pcall(function()
      st.handle:kill(15)
    end)
    st.handle = nil
  end
  st.idx = math.max(1, math.min(#st.utts, st.idx + delta))
  speak()
end
M.next = function()
  skip(1)
end
M.prev = function()
  skip(-1)
end

function M.read_current()
  if not have_say() then
    return
  end
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local utts = M.parse(vim.api.nvim_buf_get_lines(buf, 0, -1, false))
  local row = vim.api.nvim_win_get_cursor(win)[1]
  for _, u in ipairs(utts) do
    if u.e >= row then
      return M.start { utts = { u }, buf = buf, win = win }
    end
  end
end

---@param range { [1]: integer, [2]: integer }? 1-based inclusive line range
function M.export(range)
  if not have_say() then
    return
  end
  local buf = vim.api.nvim_get_current_buf()
  local lo, hi = 0, -1
  if range then
    lo, hi = range[1] - 1, range[2]
  end
  local utts = M.parse(vim.api.nvim_buf_get_lines(buf, lo, hi, false))
  if #utts == 0 then
    return vim.notify("readaloud: nothing to export", vim.log.levels.WARN)
  end
  local text = {}
  for _, u in ipairs(utts) do
    text[#text + 1] = u.text
  end
  local out = vim.fn.tempname() .. ".m4a"
  local c = cfg()
  vim.notify("readaloud: rendering audio…", vim.log.levels.INFO)
  vim.system(
    { "say", "-r", tostring(c.rate), "-o", out, table.concat(text, "\n") },
    {},
    vim.schedule_wrap(function(obj)
      if obj.code ~= 0 then
        return vim.notify("readaloud: render failed\n" .. (obj.stderr or ""), vim.log.levels.ERROR)
      end
      vim.notify("readaloud: " .. out, vim.log.levels.INFO)
      if c.player then
        vim.system { c.player, out }
      elseif vim.ui.open then
        vim.ui.open(out)
      else
        vim.system { "open", out }
      end
    end)
  )
end

return M
