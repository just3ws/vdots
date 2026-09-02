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
  tone = "warm", -- "warm" (natural, easy on the ears) | "clarity" (crisp, Alex-first)
  listen_dir = nil, -- :VdotsReadPublish target; nil = vdots-listen default (~/ai/outbox/listen)
  publish_open = false, -- open the catalog after :VdotsReadPublish
  -- Auto-voice preference per tone, best → acceptable; first one installed wins.
  -- The Premium / Enhanced neural voices are the warm, human ones but need a
  -- download: System Settings ▸ Accessibility ▸ Spoken Content ▸ Manage Voices
  -- (Ava and Evan are the standouts). `Alex` is unmatched for pure technical
  -- clarity but sounds robotic.
  voice_prefs = {
    warm = {
      "Ava (Premium)",
      "Ava (Enhanced)",
      "Evan (Premium)",
      "Evan (Enhanced)",
      "Joelle (Enhanced)",
      "Nathan (Enhanced)",
      "Samantha (Enhanced)",
      "Allison (Enhanced)",
      "Zoe (Premium)",
      "Sandy",
      "Flo",
      "Samantha",
      "Karen",
      "Moira",
    },
    clarity = {
      "Alex",
      "Ava (Enhanced)",
      "Evan (Enhanced)",
      "Samantha (Enhanced)",
      "Daniel (Enhanced)",
      "Samantha",
      "Daniel",
    },
  },
}

---@return table
function M.get()
  return vim.tbl_deep_extend("force", M.defaults, vim.g.vdots_readaloud or {})
end

local _voice_cache = nil

---Installed `say` voice names — both the full label and the bare name
---("Ava (Enhanced)" and "Ava"), so preference lists can use either.
---@return table<string, boolean>
local function installed_voices()
  local set = {}
  for _, line in ipairs(vim.fn.systemlist { "say", "-v", "?" }) do
    -- "Alex   en_US  # ..."  /  "Ava (Premium)  en_US  # ..."  /  "Sandy (English (US))  en_US  # ..."
    local name = line:match "^(.-)%s%s+%a%a[_%-]"
      or line:match "^(.-)%s%s+#"
      or line:match "^(%S.-)%s%s"
    if name and name ~= "" then
      name = vim.trim(name)
      set[name] = true
      set[(name:gsub("%s*%b()%s*$", ""))] = true
    end
  end
  return set
end

---Resolve the voice to pass to `say`: explicit `voice` wins, else the first
---installed entry from voice_prefs[tone], else nil (system default).
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
  local prefs = (c.voice_prefs or {})[c.tone] or (c.voice_prefs or {}).warm or {}
  for _, name in ipairs(prefs) do
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
  chk(c.listen_dir == nil or type(c.listen_dir) == "string", "listen_dir is a string or nil")
  chk(type(c.publish_open) == "boolean", "publish_open is a boolean")
  chk(type(c.pronounce) == "table", "pronounce is a table")
  chk(
    c.tone == "warm" or c.tone == "clarity",
    'tone is "warm" or "clarity" (' .. tostring(c.tone) .. ")"
  )
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
