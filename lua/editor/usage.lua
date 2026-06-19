-- ============================================================================
-- 📊  usage.lua — lightweight friction / "rage" telemetry for nvim
-- ============================================================================
-- Captures high-signal usage events to a local JSONL log and turns them into
-- recommendations via :NvimUsage. NO content is logged — only command *names*
-- (first token), key *names*, and error *codes/messages*; never file contents,
-- search terms, or command arguments.
--
-- Events (one JSON object per line in stdpath("state")/usage.jsonl):
--   {ts, kind="rage_repeat", key, count}   same key mashed >=4x in <800ms
--   {ts, kind="cmd",         name}         a ":" command you typed by hand
--   {ts, kind="error",       msg}          v:errmsg changed (E486, E37, ...)
--   {ts, kind="chord",       seq, abandoned}  a <leader> sequence (Esc = gave up)
--
-- The capture path is defensive: the on_key hook is wrapped in pcall so a bug
-- here can never break typing. Events buffer in memory and flush every 5s.
-- ============================================================================

local M = {}

local RAGE_THRESHOLD = 4 -- identical keys in a row
local RAGE_WINDOW = 800 -- ms between repeats to count as a burst
local CHORD_TIMEOUT = 1500 -- ms gap that ends a leader chord
local CHORD_MAX_KEYS = 4 -- keys after leader before we call it complete

local function logfile()
  return vim.fn.stdpath "state" .. "/usage.jsonl"
end

-- ---------------------------------------------------------------------------
-- Buffered writer
-- ---------------------------------------------------------------------------
local pending = {}

function M.record(ev)
  ev.ts = ev.ts or os.time()
  pending[#pending + 1] = ev
end

function M.flush()
  if #pending == 0 then
    return
  end
  local lines = {}
  for _, ev in ipairs(pending) do
    local ok, json = pcall(vim.json.encode, ev)
    if ok then
      lines[#lines + 1] = json
    end
  end
  pending = {}
  pcall(vim.fn.writefile, lines, logfile(), "a")
end

-- ---------------------------------------------------------------------------
-- Capture: on_key (rage bursts + leader chords + error watcher)
-- ---------------------------------------------------------------------------
local function readable(key)
  local ok, s = pcall(vim.fn.keytrans, key)
  return ok and s or key
end

local function install_onkey()
  local leader = vim.g.mapleader or ";"
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

  -- rage state
  local last_key, last_t, run = nil, 0, 0
  -- chord state
  local chord, chord_t, chord_keys = nil, 0, 0
  -- error state
  local last_err = ""

  local function end_chord(abandoned)
    if chord and chord_keys >= 1 then
      M.record { kind = "chord", seq = chord, abandoned = abandoned }
    end
    chord, chord_t, chord_keys = nil, 0, 0
  end

  vim.on_key(function(key, typed)
    pcall(function()
      local t = (typed and typed ~= "") and typed or key
      if not t or t == "" then
        return
      end
      local now = vim.uv.now()

      -- error watcher: log when v:errmsg changes, then clear so repeats re-fire
      local em = vim.v.errmsg
      if em ~= "" and em ~= last_err then
        M.record { kind = "error", msg = em:sub(1, 140) }
        vim.v.errmsg = ""
        last_err = ""
      end

      -- rage-repeat: log a burst when it ends (key changes or window lapses)
      if t == last_key and (now - last_t) < RAGE_WINDOW then
        run = run + 1
      else
        if run >= RAGE_THRESHOLD then
          M.record { kind = "rage_repeat", key = readable(last_key), count = run }
        end
        run = 1
      end
      last_key, last_t = t, now

      -- leader chord tracking (normal/visual only)
      if chord and (now - chord_t) > CHORD_TIMEOUT then
        end_chord(false)
      end
      if chord then
        if t == esc then
          end_chord(true)
        elseif t == "\r" or t == "\n" then
          end_chord(false)
        else
          chord = chord .. readable(t)
          chord_keys = chord_keys + 1
          chord_t = now
          if chord_keys >= CHORD_MAX_KEYS then
            end_chord(false)
          end
        end
      elseif t == leader then
        local mode = vim.fn.mode()
        if mode == "n" or mode:match "^[vV\22]" then
          chord, chord_t, chord_keys = readable(t), now, 0
        end
      end
    end)
  end, vim.api.nvim_create_namespace "usage_onkey")
end

-- ---------------------------------------------------------------------------
-- Capture: ":" command names (CmdlineLeave) — name only, never the args
-- ---------------------------------------------------------------------------
local function install_cmdline(group)
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    callback = function()
      if vim.fn.getcmdtype() ~= ":" then
        return
      end
      local line = vim.fn.getcmdline() or ""
      local name = line:match "^%s*(%a[%w_]*)"
      if name then
        M.record { kind = "cmd", name = name }
      end
    end,
  })
end

-- ---------------------------------------------------------------------------
-- Report: :NvimUsage — aggregate the log into recommendations
-- ---------------------------------------------------------------------------
local function aggregate()
  M.flush()
  local agg = { cmd = {}, rage = {}, error = {}, chord = {}, abandoned = {}, total = 0 }
  local ok, lines = pcall(vim.fn.readfile, logfile())
  if not ok then
    return agg
  end
  for _, l in ipairs(lines) do
    local good, ev = pcall(vim.json.decode, l)
    if good and type(ev) == "table" then
      agg.total = agg.total + 1
      if ev.kind == "cmd" and ev.name then
        agg.cmd[ev.name] = (agg.cmd[ev.name] or 0) + 1
      elseif ev.kind == "rage_repeat" and ev.key then
        agg.rage[ev.key] = (agg.rage[ev.key] or 0) + 1
      elseif ev.kind == "error" and ev.msg then
        local code = ev.msg:match "^(E%d+)" or ev.msg:sub(1, 40)
        agg.error[code] = (agg.error[code] or 0) + 1
      elseif ev.kind == "chord" and ev.seq then
        agg.chord[ev.seq] = (agg.chord[ev.seq] or 0) + 1
        if ev.abandoned then
          agg.abandoned[ev.seq] = (agg.abandoned[ev.seq] or 0) + 1
        end
      end
    end
  end
  return agg
end

local function top(tbl, n)
  local arr = {}
  for k, v in pairs(tbl) do
    arr[#arr + 1] = { k = k, v = v }
  end
  table.sort(arr, function(a, b)
    return a.v > b.v
  end)
  return vim.list_slice(arr, 1, n)
end

local function build_report()
  local agg = aggregate()
  local L =
    { "# 📊 nvim usage & friction report", "", ("Events logged: %d"):format(agg.total), "" }

  L[#L + 1] = "## ⌨️  Hand-typed `:` commands → candidates to bind"
  local cmds = top(agg.cmd, 8)
  if #cmds == 0 then
    L[#L + 1] = "_(none yet)_"
  end
  for _, e in ipairs(cmds) do
    L[#L + 1] = ("  %-14s %d×"):format(":" .. e.k, e.v)
  end

  L[#L + 1] = ""
  L[#L + 1] = "## 😤 Rage bursts (key mashed ≥4× fast) → possible friction"
  local rage = top(agg.rage, 6)
  if #rage == 0 then
    L[#L + 1] = "_(none yet)_"
  end
  for _, e in ipairs(rage) do
    L[#L + 1] = ("  %-14s %d bursts"):format(e.k, e.v)
  end

  L[#L + 1] = ""
  L[#L + 1] = "## ⛔ Recurring errors"
  local errs = top(agg.error, 6)
  if #errs == 0 then
    L[#L + 1] = "_(none yet)_"
  end
  for _, e in ipairs(errs) do
    L[#L + 1] = ("  %-14s %d×"):format(e.k, e.v)
  end

  L[#L + 1] = ""
  L[#L + 1] = "## 🤔 Abandoned leader chords → bindings you may have forgotten"
  local ab = top(agg.abandoned, 6)
  if #ab == 0 then
    L[#L + 1] = "_(none yet)_"
  end
  for _, e in ipairs(ab) do
    local started = agg.chord[e.k] or e.v
    L[#L + 1] = ("  %-14s abandoned %d/%d"):format(e.k, e.v, started)
  end

  -- recommendations
  L[#L + 1] = ""
  L[#L + 1] = "## 💡 Recommendations"
  local recs = {}
  for _, e in ipairs(cmds) do
    if e.v >= 5 then
      recs[#recs + 1] = ("Bind `:%s` — typed by hand %d×."):format(e.k, e.v)
    end
  end
  for _, e in ipairs(rage) do
    if e.v >= 3 then
      recs[#recs + 1] = ("`%s` mashed in %d bursts — is the action slow or the motion awkward?"):format(
        e.k,
        e.v
      )
    end
  end
  for _, e in ipairs(ab) do
    if e.v >= 3 then
      recs[#recs + 1] = ("You start `%s` then bail often — surface it in which-key or rebind."):format(
        e.k
      )
    end
  end
  if agg.error["E486"] and agg.error["E486"] >= 3 then
    recs[#recs + 1] =
      "Frequent E486 (pattern not found) — consider case-insensitive or fuzzy search defaults."
  end
  if #recs == 0 then
    recs[#recs + 1] = "Not enough data yet — keep working and re-run :NvimUsage later."
  end
  for _, r in ipairs(recs) do
    L[#L + 1] = "  • " .. r
  end

  return L
end

local function show_report()
  local lines = build_report()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  local width = math.min(80, math.floor(vim.o.columns * 0.8))
  local height = math.min(#lines + 1, math.floor(vim.o.lines * 0.85))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = math.max(height, 5),
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " 📊 :NvimUsage ",
    title_pos = "center",
  })
  vim.wo[win].wrap = true
  vim.wo[win].conceallevel = 2
  for _, key in ipairs { "q", "<Esc>" } do
    vim.keymap.set("n", key, "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
  end
end

-- ---------------------------------------------------------------------------
function M.setup(o)
  o = o or {}
  if o.enabled == false then
    return
  end
  local group = vim.api.nvim_create_augroup("usage_telemetry", { clear = true })

  install_onkey()
  install_cmdline(group)

  -- periodic + on-exit flush
  local timer = vim.uv.new_timer()
  timer:start(5000, 5000, vim.schedule_wrap(M.flush))
  vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = M.flush })

  vim.api.nvim_create_user_command("NvimUsage", show_report, { desc = "Usage / friction report" })
  vim.api.nvim_create_user_command("NvimUsageReset", function()
    pcall(vim.fn.delete, logfile())
    pending = {}
    vim.notify("Usage log cleared.", vim.log.levels.INFO, { title = "📊 NvimUsage" })
  end, { desc = "Clear the usage log" })
end

return M
