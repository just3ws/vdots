-- vdots.readaloud.config — defaults, user-override merge, validation.

local M = {}

M.defaults = {
  voice = nil, -- nil = auto (best installed from voice_prefs); or a `say -v ?` name
  rate = 220, -- words per minute
  skip_code = true, -- announce fenced code blocks instead of reading them
  skip_tables = false, -- false = read tables row by row
  preview = true, -- open the rendered preview vsplit on start
  sync_cursor = true, -- keep the cursor synced between the two panes
  stop_on_edit = true, -- halt playback when the source buffer is modified
  media_keys = true, -- run the macOS Now-Playing helper for hardware media keys
  pronounce = {}, -- per-term overrides merged over vdots.readaloud.pronounce.builtin
  player = nil, -- external player for :VdotsReadExport; nil = vim.ui.open
  -- Auto-voice preference, best → acceptable. First one installed wins; the
  -- classic `Alex` is unmatched for technical clarity (crisp consonants,
  -- punctuation-aware pauses); the Enhanced/Premium neural voices sound better
  -- but need a download (System Settings ▸ Spoken Content ▸ Manage Voices).
  voice_prefs = {
    "Alex",
    "Ava (Premium)",
    "Ava (Enhanced)",
    "Zoe (Premium)",
    "Evan (Enhanced)",
    "Allison (Enhanced)",
    "Samantha (Enhanced)",
    "Tom (Enhanced)",
    "Daniel (Enhanced)",
    "Samantha",
    "Daniel",
  },
}

---@return table
function M.get()
  return vim.tbl_deep_extend("force", M.defaults, vim.g.vdots_readaloud or {})
end

local _voice_cache = nil

---List installed `say` voice names (cached for the session).
---@return table<string, boolean>
local function installed_voices()
  local set = {}
  local out = vim.fn.systemlist { "say", "-v", "?" }
  for _, line in ipairs(out) do
    -- "Alex                en_US    # ..."   or   "Ava (Premium)       en_US    # ..."
    local name = line:match "^(.-)%s%s+%a%a[_%-]"
      or line:match "^(.-)%s%s+#"
      or line:match "^(%S.-)%s%s"
    if name and name ~= "" then
      set[vim.trim(name)] = true
    end
  end
  return set
end

---Resolve the voice to pass to `say`: explicit config wins, else the first
---installed entry from voice_prefs, else nil (system default).
---@param force? boolean recompute instead of using the cache
---@return string?
function M.resolve_voice(force)
  local c = M.get()
  if type(c.voice) == "string" and c.voice ~= "" then
    return c.voice
  end
  if _voice_cache ~= nil and not force then
    return _voice_cache ~= false and _voice_cache or nil
  end
  if vim.fn.executable "say" == 0 then
    _voice_cache = false
    return nil
  end
  local have = installed_voices()
  for _, name in ipairs(c.voice_prefs or {}) do
    if have[name] then
      _voice_cache = name
      return name
    end
  end
  _voice_cache = false
  return nil
end

---Validate the resolved config. Returns a list of {ok=bool, msg=string}.
---@return { ok: boolean, msg: string }[]
function M.diagnose()
  local c = M.get()
  local out = {}
  local function chk(ok, msg)
    out[#out + 1] = { ok = ok, msg = msg }
  end
  chk(
    type(c.rate) == "number" and c.rate > 0,
    "rate is a positive number (" .. tostring(c.rate) .. ")"
  )
  chk(c.voice == nil or type(c.voice) == "string", "voice is a string or nil")
  chk(c.player == nil or type(c.player) == "string", "player is a string or nil")
  chk(type(c.pronounce) == "table", "pronounce is a table")
  for _, k in ipairs {
    "skip_code",
    "skip_tables",
    "preview",
    "sync_cursor",
    "stop_on_edit",
    "media_keys",
  } do
    chk(type(c[k]) == "boolean", k .. " is a boolean")
  end
  return out
end

return M
