local cmd = vim.api.nvim_create_user_command

-- Config editing shortcuts
cmd("Reload", "source $MYVIMRC", {})
cmd("Vimrc", "edit $MYVIMRC", {})
cmd("Svimrc", "split $MYVIMRC", {})
cmd("Tvimrc", "tabedit $MYVIMRC", {})
cmd("Vvimrc", "vsplit $MYVIMRC", {})

-- Shell env editing shortcuts
cmd("Zshenv", "edit $ZDOTDIR/.zshenv", {})
cmd("Szshenv", "split $ZDOTDIR/.zshenv", {})
cmd("Tzshenv", "tabedit $ZDOTDIR/.zshenv", {})
cmd("Vzshenv", "vsplit $ZDOTDIR/.zshenv", {})

-- zdots platform commands
cmd("ZdotsIngest", function()
  require("zdots").ingest_buffer(0)
end, { desc = "Ingest current buffer into zdots context engine" })

cmd("ZdotsStatus", function()
  require("zdots").show_status()
end, { desc = "Show zdots platform status in a floating window" })

-- Markdown read-aloud (lua/vdots/readaloud/; macOS `say`). :help vdots-readaloud
cmd("VdotsRead", function()
  require("vdots.readaloud").play { from_cursor = false }
end, { desc = "Read the Markdown buffer aloud (rendered preview pane)" })

cmd("VdotsReadFromHere", function()
  require("vdots.readaloud").play { from_cursor = true }
end, { desc = "Read aloud from the block under the cursor" })

cmd("VdotsReadStop", function()
  require("vdots.readaloud").stop()
end, { desc = "Stop read-aloud playback (keep the preview pane)" })

cmd("VdotsReadClose", function()
  require("vdots.readaloud").close()
end, { desc = "Close the read-aloud preview pane" })

cmd("VdotsReadRefresh", function()
  require("vdots.readaloud").refresh()
end, { desc = "Re-render the read-aloud preview from the source" })

cmd("VdotsReadInfo", function()
  require("vdots.readaloud").info()
end, { desc = "Show the read-aloud parse / frontmatter interpretation" })

cmd("VdotsReadExport", function(o)
  local range = o.range == 2 and { o.line1, o.line2 } or nil
  require("vdots.readaloud").export(range)
end, { range = true, desc = "Render read-aloud audio to a file and open it" })

cmd("VdotsReadPublish", function(o)
  require("vdots.readaloud").publish { force = o.bang }
end, { bang = true, desc = "Publish doc + read-through to the listen library (! = re-record)" })

-- Recent files, Markdown only (dashboard `m` key + standalone)
cmd("VdotsRecentMarkdown", function()
  Snacks.picker.recent {
    filter = {
      filter = function(item)
        return require("editor.mdfiles").is_markdown(item.file)
      end,
    },
  }
end, { desc = "Pick from recently opened Markdown files" })

-- Plugin package management commands (vim.pack)
cmd("PackUpdate", function()
  vim.pack.update()
end, { desc = "Interactive plugin update with changelog review" })

cmd("PackSync", function()
  vim.pack.update(nil, { target = "lockfile" })
end, { desc = "Sync plugins to lockfile" })

cmd("PackClean", function()
  local plugins = vim.pack.get()
  local inactive = {}
  for _, p in ipairs(plugins) do
    if not p.active then
      table.insert(inactive, p.spec.name)
    end
  end
  if #inactive == 0 then
    vim.notify(
      "No unmanaged/inactive plugins to clean.",
      vim.log.levels.INFO,
      { title = "vim.pack" }
    )
    return
  end
  vim.pack.del(inactive, { force = true })
  vim.notify(
    "Cleaned " .. #inactive .. " inactive plugins: " .. table.concat(inactive, ", "),
    vim.log.levels.INFO,
    { title = "vim.pack" }
  )
end, { desc = "Remove unmanaged/inactive plugins from disk" })

cmd("PackStatus", function()
  local plugins = vim.pack.get()
  local active_count = 0
  for _, p in ipairs(plugins) do
    if p.active then
      active_count = active_count + 1
    end
  end
  vim.notify(
    string.format("vim.pack: %d active plugins installed", active_count),
    vim.log.levels.INFO,
    { title = "vim.pack" }
  )
end, { desc = "Show vim.pack plugin status" })

-- Formatter commands (run by command name: :Format [formatter] or :Prettier)
cmd("Format", function(opts)
  local range = nil
  if opts.range == 2 then
    local last_line = vim.fn.getline(opts.line2)
    range = { start = { opts.line1, 0 }, ["end"] = { opts.line2, #last_line } }
  end
  local ok, conform = pcall(require, "conform")
  if not ok then
    vim.notify("conform.nvim is not loaded", vim.log.levels.ERROR)
    return
  end
  local async = not opts.bang
  local formatter_name = vim.trim(opts.args or "")
  if formatter_name ~= "" then
    conform.format {
      formatters = { formatter_name },
      async = async,
      range = range,
    }
  else
    conform.format {
      async = async,
      lsp_fallback = true,
      range = range,
    }
  end
end, {
  bang = true,
  nargs = "?",
  range = true,
  complete = function(arg_lead)
    local ok, conform = pcall(require, "conform")
    if not ok then
      return {}
    end
    local formatters = {}
    local seen = {}
    local function add(name)
      if name and not seen[name] and vim.startswith(name, arg_lead) then
        seen[name] = true
        formatters[#formatters + 1] = name
      end
    end
    for _, f in ipairs(conform.list_formatters(0)) do
      add(f.name)
    end
    for _, f in ipairs(conform.list_all_formatters()) do
      add(f.name)
    end
    for _, name in ipairs {
      "prettier",
      "prettierd",
      "stylua",
      "rubocop",
      "gofmt",
      "goimports",
      "eslint_d",
    } do
      add(name)
    end
    table.sort(formatters)
    return formatters
  end,
  desc = "Format buffer or range (optional: specify formatter by name, e.g. :Format prettier; ! for sync)",
})

cmd("Prettier", function(opts)
  local range = nil
  if opts.range == 2 then
    local last_line = vim.fn.getline(opts.line2)
    range = { start = { opts.line1, 0 }, ["end"] = { opts.line2, #last_line } }
  end
  local ok, conform = pcall(require, "conform")
  if not ok then
    vim.notify("conform.nvim is not loaded", vim.log.levels.ERROR)
    return
  end
  conform.format {
    formatters = { "prettierd", "prettier" },
    async = not opts.bang,
    range = range,
    stop_after_first = true,
  }
end, {
  bang = true,
  range = true,
  desc = "Format current buffer or range using Prettier (! for sync)",
})

-- File explorer commands (NERDTree muscle memory + standard Explorer aliases)
cmd("NERDTree", function()
  require("editor.explorer").open()
end, { desc = "Open explorer sidebar focused on current file (NERDTree alias)" })

cmd("NERDTreeToggle", function()
  require("editor.explorer").toggle()
end, { desc = "Toggle explorer sidebar, focusing current file (NERDTree alias)" })

cmd("NERDTreeFind", function()
  require("editor.explorer").find()
end, { desc = "Reveal and focus current file in explorer sidebar (NERDTreeFind alias)" })

cmd("NERDTreeFocus", function()
  require("editor.explorer").focus()
end, { desc = "Focus explorer sidebar on current file (NERDTree alias)" })

cmd("Explorer", function()
  require("editor.explorer").open()
end, { desc = "Open explorer sidebar focused on current file" })

cmd("ExplorerToggle", function()
  require("editor.explorer").toggle()
end, { desc = "Toggle explorer sidebar, focusing current file" })

cmd("ExplorerFind", function()
  require("editor.explorer").find()
end, { desc = "Reveal and focus current file in explorer sidebar" })

cmd("ExplorerFocus", function()
  require("editor.explorer").focus()
end, { desc = "Focus explorer sidebar on current file" })
