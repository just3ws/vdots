-- Ruby text object keymaps (vim-textobj-ruby)
-- ar/ir: handled by vim-textobj-rubyblock
-- af/if: functions   ac/ic: classes   an/in: names
local map = function(lhs, plug)
  vim.keymap.set({ "x", "o" }, lhs, plug, { buffer = true, silent = true })
end

map("af", "<Plug>(textobj-ruby-function-a)")
map("if", "<Plug>(textobj-ruby-function-i)")
map("ac", "<Plug>(textobj-ruby-class-a)")
map("ic", "<Plug>(textobj-ruby-class-i)")
map("an", "<Plug>(textobj-ruby-name)")
map("in", "<Plug>(textobj-ruby-name)")
