local M = {}

--- Fzf-Lua & Ack Integration
--- Provides ultra-fast interactive fuzzy search using fzf and ack.

function M.get_ack_cmd()
  if vim.fn.executable "ack" == 1 then
    return "ack -H --nogroup --column --smart-case --nocolor --nofilter"
  end
  return nil
end

function M.setup()
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    return false
  end

  local ack_cmd = M.get_ack_cmd()

  fzf.setup {
    winopts = {
      height = 0.85,
      width = 0.85,
      row = 0.35,
      col = 0.50,
      preview = {
        layout = "flex",
        flip_columns = 120,
      },
    },
    keymap = {
      builtin = {
        ["<C-d>"] = "preview-page-down",
        ["<C-u>"] = "preview-page-up",
      },
      fzf = {
        ["ctrl-z"] = "abort",
        ["ctrl-u"] = "unix-line-discard",
        ["ctrl-a"] = "beginning-of-line",
        ["ctrl-e"] = "end-of-line",
      },
    },
    files = {
      multiprocess = true,
      cmd = vim.fn.executable "ack" == 1 and "ack -f" or nil,
    },
    grep = {
      cmd = ack_cmd,
    },
  }

  -- User commands
  vim.api.nvim_create_user_command("FzfAck", function(opts)
    local query = opts.args ~= "" and opts.args or nil
    if ack_cmd then
      fzf.live_grep {
        cmd = ack_cmd,
        search = query,
        prompt = "FzfAck> ",
      }
    else
      fzf.live_grep { search = query }
    end
  end, {
    nargs = "*",
    desc = "Live interactive search via Fzf and Ack",
  })

  vim.api.nvim_create_user_command("FzfAckFiles", function()
    if vim.fn.executable "ack" == 1 then
      fzf.files {
        cmd = "ack -f",
        prompt = "AckFiles> ",
      }
    else
      fzf.files()
    end
  end, {
    desc = "Find files indexed by Ack (.ackrc) via Fzf",
  })

  return true
end

function M.ack(query)
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    return false
  end
  local ack_cmd = M.get_ack_cmd()
  if ack_cmd then
    fzf.live_grep {
      cmd = ack_cmd,
      search = query,
      prompt = "FzfAck> ",
    }
  else
    fzf.live_grep { search = query }
  end
  return true
end

function M.files()
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    return false
  end
  if vim.fn.executable "ack" == 1 then
    fzf.files {
      cmd = "ack -f",
      prompt = "AckFiles> ",
    }
  else
    fzf.files()
  end
  return true
end

return M
