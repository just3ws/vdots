local fzf_mod = require "editor.fzf"

describe("editor.fzf", function()
  it("detects ack command when available", function()
    local cmd = fzf_mod.get_ack_cmd()
    if vim.fn.executable "ack" == 1 then
      assert.is_truthy(cmd)
      assert.is_truthy(cmd:find "ack")
    end
  end)

  it("sets up fzf-lua and defines user commands", function()
    local ok = fzf_mod.setup()
    assert.is_true(ok)
    assert.are.same(2, vim.fn.exists ":Fack")
    assert.are.same(2, vim.fn.exists ":Fackf")
    assert.are.same(2, vim.fn.exists ":FackWord")
    assert.are.same(2, vim.fn.exists ":FzfAck")
    assert.are.same(2, vim.fn.exists ":FzfAckFiles")
  end)
end)
