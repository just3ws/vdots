-- vdots.readaloud.preview — the rendered preview pane.
--
-- A read-only vsplit holding a verbatim copy of the source Markdown, with
-- render-markdown.nvim making it look rendered. Verbatim => source line N maps
-- to preview line N, so cursor sync is exact. Buffer/window lifecycle only;
-- player.lua owns the autocmds that drive sync and playback.

local M = {}

local state = { src_buf = nil, src_win = nil, buf = nil, win = nil }

function M.is_open()
  return state.buf ~= nil
    and vim.api.nvim_buf_is_valid(state.buf)
    and state.win ~= nil
    and vim.api.nvim_win_is_valid(state.win)
end

function M.src_buf()
  return state.src_buf
end
function M.src_win()
  return (state.src_win and vim.api.nvim_win_is_valid(state.src_win)) and state.src_win or nil
end
function M.buf()
  return state.buf
end
function M.win()
  return M.is_open() and state.win or nil
end

---Copy the current source buffer content into the preview buffer.
function M.refresh_lines()
  if not (M.is_open() and vim.api.nvim_buf_is_valid(state.src_buf)) then
    return
  end
  local lines = vim.api.nvim_buf_get_lines(state.src_buf, 0, -1, false)
  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false
end

---Open (or focus) the preview pane for the given source buffer/window.
---@param src_buf integer
---@param src_win integer
function M.open(src_buf, src_win)
  if M.is_open() then
    return
  end
  state.src_buf, state.src_win = src_buf, src_win

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "markdown"
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(src_buf), ":t")
  pcall(vim.api.nvim_buf_set_name, buf, "[reading] " .. (name ~= "" and name or "buffer"))

  vim.cmd "noautocmd vertical rightbelow split"
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].wrap = true
  vim.wo[win].cursorline = true
  state.buf, state.win = buf, win

  M.refresh_lines()
  pcall(function()
    require("render-markdown.api").buf_enable()
  end)
  -- same `;r` controls work from the preview pane
  pcall(function()
    require("vdots.readaloud").attach(buf)
  end)

  -- hand focus back to the editor pane
  if vim.api.nvim_win_is_valid(src_win) then
    vim.api.nvim_set_current_win(src_win)
  end
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
  end
  state.src_buf, state.src_win, state.buf, state.win = nil, nil, nil, nil
end

return M
