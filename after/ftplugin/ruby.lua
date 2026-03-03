-- Ruby buffer-local abbreviations
local function abbrev(lhs, rhs)
  vim.cmd(string.format("iabbrev <buffer> %s %s", lhs, rhs))
end

abbrev("re", "return")
abbrev("pu", "public")
abbrev("pr", "private")
