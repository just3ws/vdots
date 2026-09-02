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
