-- vdots.readaloud.pronounce — make `say` handle technical prose.
--
-- `say` mangles acronyms, tool names and code-ish tokens. This applies a
-- word-boundary substitution pass to the *spoken* text only (never the buffer).
-- Extend or override per-term with:
--     vim.g.vdots_readaloud = { pronounce = { kubectl = "cube cuttle", ... } }
-- Set a term to `false` to disable a built-in.

local M = {}

-- Built-in map. Keys are matched case-insensitively at word boundaries; the
-- replacement is spoken verbatim. "X Y Z" spells letters out via `say`.
M.builtin = {
  -- languages / runtimes
  nginx = "engine ex",
  ["postgresql"] = "postgres Q L",
  postgres = "post gres",
  psql = "P S Q L",
  sqlite = "S Q lite",
  zsh = "Z shell",
  bash = "bash",
  neovim = "neo vim",
  nvim = "en vim",
  vim = "vim",
  tmux = "T mux",
  golang = "go lang",
  ["node.js"] = "node J S",
  nodejs = "node J S",
  regex = "reg ex",
  async = "a sink",
  await = "a wait",
  ["async/await"] = "a sink, a wait",
  cron = "cron",
  cli = "C L I",
  gui = "gooey",
  tui = "T U I",
  repo = "repo",
  env = "env",
  -- infra / tools
  kubectl = "cube cuttle",
  kubernetes = "koober net ees",
  k8s = "kubernetes",
  docker = "docker",
  colima = "co lee ma",
  grpc = "G R P C",
  graphql = "graph Q L",
  oauth = "oh auth",
  jwt = "J W T",
  ssh = "S S H",
  scp = "S C P",
  tls = "T L S",
  ssl = "S S L",
  dns = "D N S",
  ip = "I P",
  http = "H T T P",
  https = "H T T P S",
  url = "U R L",
  uri = "U R I",
  api = "A P I",
  sdk = "S D K",
  cdn = "C D N",
  yaml = "yammel",
  toml = "tom-el",
  json = "jason",
  sql = "sequel",
  csv = "C S V",
  ci = "C I",
  cd = "C D",
  ["ci/cd"] = "C I C D",
  llm = "L L M",
  gpu = "G P U",
  cpu = "C P U",
  ram = "ram",
  os = "O S",
  ux = "U X",
  ["i18n"] = "internationalization",
  ["a11y"] = "accessibility",
  -- this platform
  zdots = "Z dots",
  adots = "A dots",
  vdots = "V dots",
  swiftbar = "swift bar",
}

---Apply the pronunciation map to spoken text.
---@param text string
---@param overrides table<string, string|false>? per-term overrides (false disables a built-in)
---@param opts { base?: boolean }? base=false skips M.builtin (enhanced docs)
---@return string
function M.apply(text, overrides, opts)
  local map = {}
  if not (opts and opts.base == false) then
    for k, v in pairs(M.builtin) do
      map[k:lower()] = v
    end
  end
  for k, v in pairs(overrides or {}) do
    map[k:lower()] = v
  end
  -- Token may carry internal . / + - (so "ci/cd", "node.js", "k8s" match), but
  -- trailing punctuation ("YAML.", "URL,") is split off and re-attached.
  return (
    text:gsub("[%w_][%w_%./+-]*", function(tok)
      local core, trail = tok:match "^(.-)([%./+-]*)$"
      local hit = map[core:lower()]
      if hit then -- nil or false => leave the token unchanged
        return hit .. trail
      end
    end)
  )
end

---Apply a document's `pronunciation:` lexicon — phrase-level, case-insensitive,
---longest term first (so "IAB Tech Lab" wins over "Lab"). The hint is spoken
---verbatim. Used for enhanced docs; audio only, never the transcript.
---@param text string
---@param lexicon table<string, string>?
---@return string
function M.lexicon(text, lexicon)
  if not lexicon or next(lexicon) == nil then
    return text
  end
  local terms = {}
  for term in pairs(lexicon) do
    terms[#terms + 1] = term
  end
  table.sort(terms, function(a, b)
    return #a > #b
  end)
  for _, term in ipairs(terms) do
    local hint = lexicon[term]
    if type(hint) == "string" and hint ~= "" and hint ~= term then
      -- escape magic chars, make letters case-insensitive, spaces flexible
      local pat = term:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
      pat = pat:gsub("%a", function(c)
        return "[" .. c:lower() .. c:upper() .. "]"
      end)
      pat = pat:gsub("%s+", "%%s+")
      local rep = hint:gsub("%%", "%%%%")
      text = text:gsub("%f[%w_]" .. pat .. "%f[^%w_]", rep)
    end
  end
  return text
end

return M
