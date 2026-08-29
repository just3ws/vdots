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
