local preview = require "vdots.readaloud.preview"

describe("vdots.readaloud.preview", function()
  local src_buf, src_win

  before_each(function()
    src_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_lines(src_buf, 0, -1, false, {
      "# Heading",
      "",
      "First paragraph.",
      "",
      "Second paragraph.",
    })
    vim.api.nvim_set_current_buf(src_buf)
    src_win = vim.api.nvim_get_current_win()
  end)

  after_each(function()
    preview.close()
    pcall(vim.api.nvim_buf_delete, src_buf, { force = true })
  end)

  it("opens a second window with a verbatim, read-only copy", function()
    local before = #vim.api.nvim_tabpage_list_wins(0)
    preview.open(src_buf, src_win)
    assert.equals(before + 1, #vim.api.nvim_tabpage_list_wins(0))
    assert.is_true(preview.is_open())

    local pbuf = preview.buf()
    assert.same(
      vim.api.nvim_buf_get_lines(src_buf, 0, -1, false),
      vim.api.nvim_buf_get_lines(pbuf, 0, -1, false)
    )
    assert.is_false(vim.bo[pbuf].modifiable)
    assert.equals("nofile", vim.bo[pbuf].buftype)
  end)

  it("refresh_lines picks up source edits", function()
    preview.open(src_buf, src_win)
    vim.api.nvim_buf_set_lines(src_buf, -1, -1, false, { "", "Third paragraph." })
    preview.refresh_lines()
    assert.same(
      vim.api.nvim_buf_get_lines(src_buf, 0, -1, false),
      vim.api.nvim_buf_get_lines(preview.buf(), 0, -1, false)
    )
  end)

  it("close tears the pane down", function()
    local before = #vim.api.nvim_tabpage_list_wins(0)
    preview.open(src_buf, src_win)
    preview.close()
    assert.is_false(preview.is_open())
    assert.equals(before, #vim.api.nvim_tabpage_list_wins(0))
  end)
end)
