local M = {}

---Toggle the sidebar explorer.
function M.toggle()
  require("nvim-tree.api").tree.toggle()
end

---Open the tree and reveal + focus the current buffer's file (like :NERDTreeFind).
---Falls back to just opening the tree when the buffer has no real file.
function M.toggle_find()
  local api = require "nvim-tree.api"
  if vim.fn.expand "%" == "" or vim.bo.buftype ~= "" then
    api.tree.open { focus = true }
  else
    api.tree.find_file { open = true, focus = true, update_root = true }
  end
end

-- ---------------------------------------------------------------------------
-- NERDTree-compatible mappings, layered on top of nvim-tree's defaults.
--
-- We call default_on_attach() first (so EVERY nvim-tree default is preserved)
-- and then bind NERDTree muscle-memory mostly on keys nvim-tree leaves free.
-- One key is overridden ON PURPOSE (user request): `r` = refresh, with the
-- displaced rename relocated to <F2>. Other NERDTree collisions (s, p, x, I, C,
-- u, U, O, m, <C-j>/<C-k>) are left to nvim-tree; equivalents are in KEYMAPS.md.
-- ---------------------------------------------------------------------------
function M.on_attach(bufnr)
  local api = require "nvim-tree.api"

  -- Preserve all nvim-tree default mappings.
  api.config.mappings.default_on_attach(bufnr)

  local function opts(desc)
    return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  local map = vim.keymap.set

  -- Open variants (free keys; mirror NERDTree)
  map("n", "t", api.node.open.tab, opts "NERDTree: open in new tab")
  map("n", "T", function()
    api.node.open.tab()
    pcall(vim.cmd, "tabprevious") -- open in a background tab, keep focus in tree
  end, opts "NERDTree: open in new tab (stay in tree)")
  map("n", "i", api.node.open.horizontal, opts "NERDTree: open in split")
  map("n", "go", api.node.open.preview, opts "NERDTree: open file, keep cursor in tree")
  map("n", "gi", function()
    api.node.open.horizontal()
    pcall(vim.cmd, "wincmd p")
  end, opts "NERDTree: open split, keep cursor in tree")
  map("n", "gs", function()
    api.node.open.vertical()
    pcall(vim.cmd, "wincmd p")
  end, opts "NERDTree: open vsplit, keep cursor in tree")

  -- Tree shape / help (free keys)
  map("n", "X", api.tree.collapse_all, opts "NERDTree: close all child nodes")
  map("n", "?", api.tree.toggle_help, opts "NERDTree: toggle help")

  -- Zoom the tree window toggle (NERDTree A)
  local default_width = 36
  local zoomed = false
  map("n", "A", function()
    vim.cmd("vertical resize " .. (zoomed and default_width or math.floor(vim.o.columns * 0.85)))
    zoomed = not zoomed
  end, opts "NERDTree: zoom/restore tree window")

  -- Intentional override (requested): NERDTree `r` = refresh. The rename that
  -- nvim-tree puts on `r` moves to <F2>; `e` (rename basename) and `u` (rename
  -- full path) are untouched.
  map("n", "r", api.tree.reload, opts "NERDTree: refresh tree")
  map("n", "<F2>", api.fs.rename, opts "Rename (relocated from r)")
end

---Collapse the whole tree, then re-reveal + focus the current file.
---Handy for resetting the view after navigating deep (like NERDTree).
function M.find_collapse()
  local api = require "nvim-tree.api"
  api.tree.collapse_all()
  M.toggle_find()
end

function M.setup()
  local map = vim.keymap.set
  -- Use <leader>e to toggle NvimTree
  map("n", "<leader>e", M.toggle, { silent = true, desc = "Explorer toggle" })

  -- Use <leader>ef to reveal + focus the current file (:NERDTreeFind)
  map("n", "<leader>ef", M.toggle_find, { silent = true, desc = "Explorer reveal current file" })

  -- Use <leader>er to collapse the tree back to the current file
  map(
    "n",
    "<leader>er",
    M.find_collapse,
    { silent = true, desc = "Explorer collapse to current file" }
  )

  -- Sync with window closing
  vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
      if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
        vim.cmd "quit"
      end
    end,
  })

  -- Auto-open the tree when nvim is launched on a directory (e.g. `nvim .`),
  -- cd into it, and focus the tree — NERDTree-style.
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function(data)
      if vim.fn.isdirectory(data.file) ~= 1 then
        return
      end
      vim.cmd.cd(data.file)
      require("nvim-tree.api").tree.open { focus = true }
    end,
  })
end

return M
