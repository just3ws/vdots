local cmd = vim.cmd

-- --- Geeky constants ---
cmd [[iabbrev Npi 3.1415926535897932384626433832795028841972]]
cmd [[iabbrev Ne  2.7182818284590452353602874713526624977573]]

-- --- Common typos ---
local typos = {
  { "cant", "can't" },
  { "Cant", "Can't" },
  { "dont", "don't" },
  { "Dont", "Don't" },
  { "wont", "won't" },
  { "Wont", "Won't" },
  { "alos", "also" },
  { "aslo", "also" },
  { "becuase", "because" },
  { "bianry", "binary" },
  { "bianries", "binaries" },
  { "charcter", "character" },
  { "charcters", "characters" },
  { "exmaple", "example" },
  { "exmaples", "examples" },
  { "shoudl", "should" },
  { "seperate", "separate" },
  { "teh", "the" },
  { "tpyo", "typo" },
  { "optino", "option" },
  { "udpate", "update" },
  { "typdef", "typedef" },
  { "flase", "false" },
  { "taht", "that" },
  { "resposne", "response" },
}
for _, pair in ipairs(typos) do
  cmd(string.format("iabbrev %s %s", pair[1], pair[2]))
end

-- --- Convenience snippets ---
cmd [[iabbrev /} //}}}]]
cmd [[iabbrev /{ //{{{]]
cmd [[iabbrev dt <C-r>=strftime("%Y-%m-%d %H:%M:%S")<CR>]]

-- --- Short forms for languages ---
local shortcuts = {
  { "pu", "public" },
  { "pr", "private" },
  { "fu", "func" },
  { "im", "import" },
  { "pa", "package" },
  { "ma", "main" },
  { "fun", "func" },
  { "re", "return" },
}
for _, pair in ipairs(shortcuts) do
  cmd(string.format("iabbrev %s %s", pair[1], pair[2]))
end

-- --- Global normal-mode abbreviation (legacy style) ---
cmd [[ab teh the]]
cmd [[ab fro for]]
