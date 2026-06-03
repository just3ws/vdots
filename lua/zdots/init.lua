local M = {}

local BIN_DIR = "/Users/mike/.config/zsh/bin/"

---Get a brief status from the zdots platform.
---@return table|nil
function M.get_status()
  local cmd = BIN_DIR .. "pi-ctx-status 2>/dev/null"
  local handle = io.popen(cmd)
  if not handle then return nil end
  local result = handle:read("*a")
  handle:close()

  if result == "" then return nil end

  local lines = {}
  for line in result:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end
  return lines
end

---Run a ztask command and return results.
---@param subcmd string
---@return table
function M.ztask(subcmd)
  local cmd = string.format("%sztask %s --json 2>/dev/null", BIN_DIR, subcmd)
  local handle = io.popen(cmd)
  if not handle then return {} end
  local result = handle:read("*a")
  handle:close()

  local ok, data = pcall(vim.fn.json_decode, result)
  return ok and data or {}
end

---Hydrate context for a file using the zdots platform.
---@param file_path string
---@return string
function M.hydrate_context(file_path)
  local cmd = string.format("%spi-ctx-hydrate --file %s --brief 2>/dev/null", BIN_DIR, vim.fn.shellescape(file_path))
  local handle = io.popen(cmd)
  if not handle then return "" end
  local result = handle:read("*a")
  handle:close()
  return result
end

---Ingest the current buffer into the zdots context engine.
---@param bufnr number
function M.ingest_buffer(bufnr)
  local file_path = vim.api.nvim_buf_get_name(bufnr)
  if file_path == "" then
    vim.notify("Cannot ingest: buffer has no file path", vim.log.levels.ERROR)
    return
  end

  -- We use zdots-ingest-prepare followed by zdots-ctx to capture the content.
  -- This ensures it goes through the proper distillation pipeline.
  local cmd = string.format("%szdots-ctx capture --file %s 2>&1", BIN_DIR, vim.fn.shellescape(file_path))
  
  vim.notify("Ingesting context into zdots...", vim.log.levels.INFO)
  
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      if data and data[1] ~= "" then
        print(table.concat(data, "\n"))
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("zdots: Context successfully ingested", vim.log.levels.INFO)
      else
        vim.notify("zdots: Ingestion failed (check :messages)", vim.log.levels.ERROR)
      end
    end,
  })
end

---Show zdots status in a floating window.
function M.show_status()
  local status = M.get_status()
  if not status then
    vim.notify("zdots: Platform status unavailable", vim.log.levels.WARN)
    return
  end
  
  -- Create a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, status)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 80,
    height = #status,
    col = (vim.o.columns - 80) / 2,
    row = (vim.o.lines - #status) / 2,
    style = "minimal",
    border = "rounded",
    title = " zdots Platform Status ",
  })
  
  vim.bo[buf].modifiable = false
  vim.keymap.set("n", "q", "<cmd>bd<cr>", { buffer = buf, nowait = true })
end

return M
