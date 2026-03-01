-- Go buffer-local abbreviations
local function abbrev(lhs, rhs)
  vim.cmd(string.format("iabbrev <buffer> %s %s", lhs, rhs))
end

abbrev("re", "return")
abbrev("fu", "func")
abbrev("fun", "func")
abbrev("im", "import")
abbrev("pa", "package")
abbrev("ma", "main")
