local luasnip = require "luasnip"

-- Load VS Code-style snippets from friendly-snippets and any local snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Extend filetypes: use Ruby snippets in eruby (erb) files
luasnip.filetype_extend("eruby", { "ruby" })
