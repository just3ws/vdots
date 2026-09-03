-- editor/mdfiles.lua — "what counts as a Markdown file" (one definition, two
-- call sites: the dashboard "Recent Markdown" section and :VdotsRecentMarkdown).

local M = {}

local EXT = { md = true, markdown = true, mdx = true, mkd = true, mdown = true, mkdn = true }

---@param path string?
---@return boolean
function M.is_markdown(path)
  if not path or path == "" then
    return false
  end
  local ext = path:lower():match "%.([%w]+)$"
  return ext ~= nil and EXT[ext] == true
end

return M
