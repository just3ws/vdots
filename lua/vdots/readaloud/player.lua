-- vdots.readaloud.player — the `say` playback state machine.
--
-- Playback is anchored to source lines, not a flat index: "play from cursor"
-- and "jump" resolve to the block covering that line and (re)read it from the
-- start before advancing. Highlight + cursor track the active block in both
-- panes. Editing the source halts playback; :w refreshes the preview.

local M = {}

local uv = vim.uv or vim.loop
local cfg = require "vdots.readaloud.config"
local parse = require "vdots.readaloud.parse"
local pace = require "vdots.readaloud.pace"
local preview = require "vdots.readaloud.preview"
local mediakeys = require "vdots.readaloud.mediakeys"

local NS = vim.api.nvim_create_namespace "vdots_readaloud"
local AUG = "vdots_readaloud"

local st = {
  blocks = nil,
  idx = 0,
  paused = false,
  pause_line = nil,
  gen = 0,
  handle = nil,
  src_buf = nil,
  syncing = false,
}

--------------------------------------------------------------------------------
-- state file (SwiftBar + Now-Playing helper read this)
--------------------------------------------------------------------------------

local function state_file()
  local d = (vim.env.XDG_CACHE_HOME or (vim.env.HOME .. "/.cache")) .. "/vdots"
  vim.fn.mkdir(d, "p")
  return d .. "/readaloud.json"
end

local function write_state(active)
  local f = state_file()
  if not active then
    local cur = vim.fn.filereadable(f) == 1
        and vim.json.decode(table.concat(vim.fn.readfile(f), ""))
      or nil
    if not cur or cur.addr == vim.v.servername then
      pcall(vim.fn.delete, f)
    end
    return
  end
  local b = st.blocks and st.blocks[st.idx]
  local data = {
    active = true,
    paused = st.paused,
    file = st.src_buf and vim.fn.fnamemodify(vim.api.nvim_buf_get_name(st.src_buf), ":t") or "",
    block = st.idx,
    blocks = st.blocks and #st.blocks or 0,
    line = b and b.s or 0,
    addr = vim.v.servername,
  }
  pcall(vim.fn.writefile, { vim.json.encode(data) }, f)
end

--------------------------------------------------------------------------------
-- highlight + cursor
--------------------------------------------------------------------------------

vim.api.nvim_set_hl(0, "VdotsReadAloud", { link = "Visual", default = true })

local function clear_hl()
  for _, buf in ipairs { st.src_buf, preview.buf() } do
    if buf and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_clear_namespace(buf, NS, 0, -1)
    end
  end
end

local function focus_block(b)
  clear_hl()
  st.syncing = true
  for _, spec in ipairs { { st.src_buf, preview.src_win() }, { preview.buf(), preview.win() } } do
    local buf, win = spec[1], spec[2]
    if buf and vim.api.nvim_buf_is_valid(buf) then
      local last = vim.api.nvim_buf_line_count(buf)
      for l = b.s, math.min(b.e, last) do
        pcall(vim.api.nvim_buf_set_extmark, buf, NS, l - 1, 0, { line_hl_group = "VdotsReadAloud" })
      end
      if win and vim.api.nvim_win_is_valid(win) then
        pcall(vim.api.nvim_win_set_cursor, win, { math.min(b.s, last), 0 })
        vim.api.nvim_win_call(win, function()
          vim.cmd "normal! zz"
        end)
      end
    end
  end
  st.syncing = false
end

--------------------------------------------------------------------------------
-- speaking
--------------------------------------------------------------------------------

local function stop_say()
  st.gen = st.gen + 1
  if st.handle then
    local h = st.handle
    st.handle = nil
    pcall(function()
      h:kill(15)
    end)
  end
end

local function speak(i)
  if not st.blocks or i < 1 or i > #st.blocks then
    return M.stop()
  end
  st.idx = i
  st.paused = false
  local b = st.blocks[i]
  focus_block(b)
  write_state(true)

  local c = cfg.get()
  local s = pace.settings(c)
  local args = { "say", "-r", tostring(s.rate) }
  local voice = cfg.resolve_voice()
  if voice then
    vim.list_extend(args, { "-v", voice })
  end
  local prev = st.blocks[i - 1] and st.blocks[i - 1].kind or nil
  local lead = pace.marker(pace.lead(prev, b.kind, s))
  local pron = require "vdots.readaloud.pronounce"
  local spoken = (st.doc and st.doc.enhanced) and pron.lexicon(b.speak, st.doc.fm.pronunciation)
    or pron.apply(b.speak, c.pronounce)
  args[#args + 1] = lead .. spoken

  st.gen = st.gen + 1
  local gen = st.gen
  st.handle = vim.system(
    args,
    { text = true },
    vim.schedule_wrap(function(res)
      if gen ~= st.gen then
        return
      end
      st.handle = nil
      if res.code == 0 then
        speak(i + 1)
      else
        M.stop()
      end
    end)
  )
end

--------------------------------------------------------------------------------
-- autocmds (cursor sync + edit halt + refresh + teardown)
--------------------------------------------------------------------------------

local function mirror_cursor(from_win, to_win)
  if st.syncing or not cfg.get().sync_cursor then
    return
  end
  if
    not (
      from_win
      and to_win
      and vim.api.nvim_win_is_valid(from_win)
      and vim.api.nvim_win_is_valid(to_win)
    )
  then
    return
  end
  st.syncing = true
  local row = vim.api.nvim_win_get_cursor(from_win)[1]
  local last = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(to_win))
  pcall(vim.api.nvim_win_set_cursor, to_win, { math.min(row, last), 0 })
  vim.schedule(function()
    st.syncing = false
  end)
end

local function setup_autocmds()
  local grp = vim.api.nvim_create_augroup(AUG, { clear = true })
  local src_buf, prev_buf = st.src_buf, preview.buf()

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = grp,
    buffer = src_buf,
    callback = function()
      mirror_cursor(preview.src_win(), preview.win())
    end,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = grp,
    buffer = prev_buf,
    callback = function()
      mirror_cursor(preview.win(), preview.src_win())
    end,
  })
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = grp,
    buffer = src_buf,
    callback = function()
      if cfg.get().stop_on_edit then
        M.halt()
      end
    end,
  })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = grp,
    buffer = src_buf,
    callback = function()
      M.refresh()
    end,
  })
  vim.api.nvim_create_autocmd({ "BufWipeout", "WinClosed" }, {
    group = grp,
    buffer = prev_buf,
    callback = function()
      M.close()
    end,
  })
end

--------------------------------------------------------------------------------
-- public API
--------------------------------------------------------------------------------

local function reparse()
  local doc = parse.document(vim.api.nvim_buf_get_lines(st.src_buf, 0, -1, false), cfg.get())
  st.blocks = doc.blocks
  st.doc = doc
end

local function block_at(line)
  if not st.blocks then
    return 1
  end
  for k, b in ipairs(st.blocks) do
    if b.e >= line then
      return k
    end
  end
  return #st.blocks
end

---@param opts { from_cursor?: boolean }?
function M.play(opts)
  opts = opts or {}
  if vim.fn.executable "say" == 0 then
    return vim.notify("readaloud: `say` not found (macOS only)", vim.log.levels.ERROR)
  end
  local c = cfg.get()

  if not preview.is_open() then
    st.src_buf = vim.api.nvim_get_current_buf()
    if c.preview then
      preview.open(st.src_buf, vim.api.nvim_get_current_win())
    end
    reparse()
    setup_autocmds()
    if c.media_keys then
      mediakeys.start()
    end
  elseif not st.blocks then
    reparse()
  end

  -- resume in place?
  local cur_win = vim.api.nvim_get_current_win()
  local cur_line = vim.api.nvim_win_get_cursor(cur_win)[1]
  if st.paused and st.handle and st.pause_line == cur_line then
    return M.resume()
  end

  local target = (opts.from_cursor == false) and 1 or block_at(cur_line)
  speak(target)
end

function M.pause()
  if not st.handle or st.paused then
    return
  end
  uv.kill(st.handle.pid, "sigstop")
  st.paused = true
  st.pause_line = st.blocks[st.idx] and st.blocks[st.idx].s or nil
  write_state(true)
  vim.notify("readaloud: paused", vim.log.levels.INFO)
end

function M.resume()
  if not st.handle or not st.paused then
    return
  end
  uv.kill(st.handle.pid, "sigcont")
  st.paused = false
  write_state(true)
end

function M.toggle_pause()
  if st.paused then
    M.resume()
  elseif st.handle then
    M.pause()
  else
    M.play { from_cursor = true }
  end
end

function M.next()
  if st.blocks then
    stop_say()
    speak(math.min(#st.blocks, st.idx + 1))
  end
end

function M.prev()
  if st.blocks then
    stop_say()
    speak(math.max(1, st.idx - 1))
  end
end

---Stop the voice but keep the panes + position (used by the edit autocmd).
function M.halt()
  stop_say()
  st.paused = false
end

---Stop playback entirely; keep the preview pane open.
function M.stop()
  stop_say()
  clear_hl()
  st.paused = false
  write_state(false)
  mediakeys.stop()
end

---Re-copy + re-parse the source; keep the current block by line if possible.
function M.refresh()
  if not st.src_buf then
    return
  end
  local anchor = st.blocks and st.blocks[st.idx] and st.blocks[st.idx].s or nil
  preview.refresh_lines()
  pcall(function()
    require("render-markdown.api").buf_enable()
  end)
  reparse()
  if anchor then
    st.idx = block_at(anchor)
  end
end

function M.close()
  M.stop()
  pcall(vim.api.nvim_del_augroup_by_name, AUG)
  preview.close()
  st.blocks, st.idx, st.src_buf, st.pause_line = nil, 0, nil, nil
end

function M.export(range)
  if vim.fn.executable "say" == 0 then
    return vim.notify("readaloud: `say` not found (macOS only)", vim.log.levels.ERROR)
  end
  local buf = vim.api.nvim_get_current_buf()
  local lo, hi = 0, -1
  if range then
    lo, hi = range[1] - 1, range[2]
  end
  local doc = parse.document(vim.api.nvim_buf_get_lines(buf, lo, hi, false), cfg.get())
  local blocks = doc.blocks
  if #blocks == 0 then
    return vim.notify("readaloud: nothing to export", vim.log.levels.WARN)
  end
  local c = cfg.get()
  local pron = require "vdots.readaloud.pronounce"
  for _, b in ipairs(blocks) do
    b.speak = doc.enhanced and pron.lexicon(b.speak, doc.fm.pronunciation)
      or pron.apply(b.speak, c.pronounce)
  end
  local script = pace.script(blocks, c)
  local out = vim.fn.tempname() .. ".m4a"
  local args = { "say", "-r", tostring(pace.settings(c).rate) }
  local voice = cfg.resolve_voice()
  if voice then
    vim.list_extend(args, { "-v", voice })
  end
  vim.list_extend(args, { "-o", out, script })
  vim.notify("readaloud: rendering audio…", vim.log.levels.INFO)
  vim.system(
    args,
    { text = true },
    vim.schedule_wrap(function(res)
      if res.code ~= 0 then
        return vim.notify("readaloud: render failed\n" .. (res.stderr or ""), vim.log.levels.ERROR)
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

---Publish the current buffer to the listen library (bin/vdots-listen): a clean
---readable doc + a pre-recorded read-through, added to the Google-Drive-synced
---catalog under ~/ai/outbox/listen.
---@param opts { force?: boolean }?  force = overwrite an existing same-day session
function M.publish(opts)
  opts = opts or {}
  if vim.fn.executable "say" == 0 then
    return vim.notify("readaloud: `say` not found (macOS only)", vim.log.levels.ERROR)
  end
  pcall(M.preflight)
  local repo = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h:h")
  local vdots_listen = repo .. "/bin/vdots-listen"
  if vim.fn.executable(vdots_listen) == 0 then
    return vim.notify("readaloud: bin/vdots-listen missing", vim.log.levels.ERROR)
  end

  local buf = vim.api.nvim_get_current_buf()
  local src = vim.api.nvim_buf_get_name(buf)
  if src == "" or vim.bo[buf].modified then
    -- publish exactly what's on screen: stage it to a temp .md
    local base = src ~= "" and vim.fn.fnamemodify(src, ":t:r") or "untitled"
    src = vim.fn.tempname() .. "-" .. base .. ".md"
    vim.fn.writefile(vim.api.nvim_buf_get_lines(buf, 0, -1, false), src)
  end

  local c = cfg.get()
  local args = { vdots_listen, "publish", src, "--tone", c.tone, "--pace", c.pace }
  if c.rate then
    vim.list_extend(args, { "--rate", tostring(c.rate) })
  end
  local voice = cfg.resolve_voice()
  if voice then
    vim.list_extend(args, { "--voice", voice })
  end
  if opts.force then
    args[#args + 1] = "--force"
  end
  if c.publish_open then
    args[#args + 1] = "--open"
  end
  local env = c.listen_dir and { VDOTS_LISTEN_DIR = vim.fn.expand(c.listen_dir) } or nil

  vim.notify("readaloud: publishing to the listen library…", vim.log.levels.INFO)
  vim.system(
    args,
    { text = true, env = env },
    vim.schedule_wrap(function(res)
      local msg = vim.trim((res.stdout or "") .. (res.stderr or ""))
      vim.notify(
        "readaloud: " .. (msg ~= "" and msg or ("done (exit " .. res.code .. ")")),
        res.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
      )
    end)
  )
end

--------------------------------------------------------------------------------
-- summary / info
--------------------------------------------------------------------------------

---Analyse the current buffer without playing or publishing.
---@return string[] lines, table meta
local function analyse()
  local buf = vim.api.nvim_get_current_buf()
  local c = cfg.get()
  local doc = parse.document(vim.api.nvim_buf_get_lines(buf, 0, -1, false), c)
  local fm = doc.fm
  local est = pace.estimate(doc.blocks, c)
  local heads, sentences = {}, 0
  for _, b in ipairs(doc.blocks) do
    if b.kind == "heading" then
      heads[#heads + 1] = b.text
    end
    for _ in b.text:gmatch "[^.!?]+[.!?]*" do
      sentences = sentences + 1
    end
  end
  local chapters = pace.chapters(doc.blocks, c, est, fm.sections)
  local voice = cfg.resolve_voice() or "system default"

  -- frontmatter ↔ body drift: a section with no matching heading won't chapter
  local drift = {}
  if doc.enhanced and #fm.sections > 0 then
    local hset = {}
    for _, h in ipairs(heads) do
      hset[vim.trim(h):lower()] = true
    end
    for _, s in ipairs(fm.sections) do
      if not hset[vim.trim(s):lower()] then
        drift[#drift + 1] = 'section "' .. s .. '" has no matching heading'
      end
    end
  end

  local L = {}
  local function add(k, v)
    L[#L + 1] = ("%-14s %s"):format(k, v)
  end
  add(
    "mode",
    doc.enhanced and "enhanced read-aloud" or (doc.present and "plain (+ frontmatter)" or "plain")
  )
  add("title", fm.title or "(from first heading / filename)")
  if doc.enhanced then
    add("lang", fm.lang)
    add("source", fm.source or "—")
    add("generated_at", fm.generated_at or "—")
    add("expected", fm.spoken_minutes and (fm.spoken_minutes .. " min") or "—")
    add(
      "lexicon",
      ("%d term%s"):format(
        vim.tbl_count(fm.pronunciation),
        vim.tbl_count(fm.pronunciation) == 1 and "" or "s"
      )
    )
  end
  add("voice", ("%s (%s pace)"):format(voice, c.pace))
  add("blocks", ("%d  ·  %d sentences  ·  %d headings"):format(#doc.blocks, sentences, #heads))
  add("chapters", #chapters > 0 and table.concat(
    vim.tbl_map(function(x)
      return x.title
    end, chapters),
    " · "
  ) or "none")
  add("estimate", ("%d:%02d"):format(math.floor(est / 60), math.floor(est % 60)))
  if doc.enhanced and fm.spoken_minutes then
    local off = math.abs(est / 60 - fm.spoken_minutes) / fm.spoken_minutes
    if off > 0.25 then
      L[#L + 1] = ("  ! %d:%02d is >25%% off the expected %d min"):format(
        math.floor(est / 60),
        math.floor(est % 60),
        fm.spoken_minutes
      )
    end
  end
  for _, d in ipairs(drift) do
    L[#L + 1] = "  ! " .. d
  end
  return L,
    {
      enhanced = doc.enhanced,
      title = fm.title,
      chapters = #chapters,
      voice = voice,
      est = est,
      drift = #drift,
    }
end

---One-line pre-flight for :VdotsReadPublish.
function M.preflight()
  local _, m = analyse()
  vim.notify(
    ("readaloud: %s · %s · %s · %d:%02d%s%s"):format(
      m.enhanced and "enhanced" or "plain",
      m.title or "(auto title)",
      m.voice,
      math.floor(m.est / 60),
      math.floor(m.est % 60),
      m.chapters > 0 and (" · " .. m.chapters .. " chapters") or "",
      m.drift > 0 and (" · ! " .. m.drift .. " frontmatter/body mismatch — :VdotsReadInfo") or ""
    ),
    m.drift > 0 and vim.log.levels.WARN or vim.log.levels.INFO
  )
end

---:VdotsReadInfo — a read-only float with the parse interpretation.
function M.info()
  local lines = analyse()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "vdots-readaloud-info"
  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, #l)
  end
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.min(width + 2, vim.o.columns - 4),
    height = #lines,
    row = math.max(0, math.floor((vim.o.lines - #lines) / 2) - 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " read-aloud ",
  })
  for _, k in ipairs { "q", "<esc>" } do
    vim.keymap.set("n", k, function()
      pcall(vim.api.nvim_win_close, win, true)
    end, { buffer = buf, nowait = true })
  end
end

M._state = st -- for tests / health
return M
