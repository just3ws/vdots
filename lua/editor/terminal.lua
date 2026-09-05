-- lua/editor/terminal.lua — ergonomic terminal experience via Snacks.terminal.
--
-- Design goals:
--   • One key (<C-/>) toggles the main terminal, same key dismisses it.
--   • Named slots (<C-1..3>) let you keep server / client / tests side-by-side.
--   • <Esc><Esc> exits terminal mode without memorising <C-\><C-n>.
--   • Split navigation (<C-h/j/k/l>) works identically inside terminal mode.
--   • Terminal windows are free of line-number / sign-column / status-column
--     clutter, and the cursor is hidden so it doesn't chase the prompt.
--   • Auto-insert when you enter any terminal buffer so you can type immediately.

local M = {}

-- Shared Snacks win options applied to every terminal we open.
-- `position = "bottom"` gives a horizontal split; adjust height to taste.
local TERM_WIN = {
  position = "bottom",
  height = 0.35,
  border = "rounded",
  wo = {
    number = false,
    relativenumber = false,
    signcolumn = "no",
    statuscolumn = "",
    winbar = "",
    winhighlight = "Normal:NormalFloat",
  },
}

---Toggle a named terminal by integer id (1-based).
---The same keymap opens and closes the terminal.
---@param id integer
---@param cmd? string|string[] Optional command to run in that slot.
local function toggle(id, cmd)
  Snacks.terminal.toggle(cmd, { id = id, win = TERM_WIN })
end

function M.setup()
  local map = vim.keymap.set

  -- ── Normal-mode toggles ────────────────────────────────────────────────
  -- <C-/> → main terminal (id=1, plain shell)
  map("n", "<C-/>", function()
    toggle(1)
  end, { desc = "Terminal: toggle main" })

  -- Named slots: server dev, client dev, spare/tests
  map("n", "<C-1>", function()
    toggle(1)
  end, { desc = "Terminal 1 (main)" })
  map("n", "<C-2>", function()
    toggle(2)
  end, { desc = "Terminal 2" })
  map("n", "<C-3>", function()
    toggle(3)
  end, { desc = "Terminal 3" })

  -- ── Terminal-mode keymaps ──────────────────────────────────────────────
  -- <Esc><Esc> = leave terminal mode (much nicer than <C-\><C-n>)
  map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal: exit insert" })

  -- <C-/> from inside terminal also toggles (hides) it
  map("t", "<C-/>", "<C-\\><C-n><cmd>lua Snacks.terminal.toggle(nil, { id = 1 })<cr>", {
    desc = "Terminal: hide",
  })

  -- Split navigation works the same way inside terminal mode
  map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Window: move left" })
  map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Window: move down" })
  map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Window: move up" })
  map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Window: move right" })

  -- Numbered-slot toggles also close from inside the terminal
  map("t", "<C-1>", function()
    toggle(1)
  end, { desc = "Terminal 1 toggle" })
  map("t", "<C-2>", function()
    toggle(2)
  end, { desc = "Terminal 2 toggle" })
  map("t", "<C-3>", function()
    toggle(3)
  end, { desc = "Terminal 3 toggle" })

  -- ── Autocmds ──────────────────────────────────────────────────────────
  local grp = vim.api.nvim_create_augroup("vimrc_terminal", { clear = true })

  -- Enter insert mode automatically when focusing a terminal buffer.
  -- Use vim.schedule so the window is fully rendered before startinsert.
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    group = grp,
    pattern = "term://*",
    callback = function()
      vim.schedule(function()
        if vim.bo.buftype == "terminal" then
          vim.cmd "startinsert"
        end
      end)
    end,
  })

  -- Clean up window-local options in terminal windows: no line numbers,
  -- no sign column, no status column.  Snacks sets most of these via
  -- TERM_WIN.wo above, but bare :terminal buffers (e.g. DAP console) still
  -- benefit from this fallback.
  vim.api.nvim_create_autocmd("TermOpen", {
    group = grp,
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn = "no"
      vim.opt_local.statuscolumn = ""
    end,
  })
end

return M
