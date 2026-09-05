local search = require "editor.search"

describe("editor.search", function()
  it("rejects empty or whitespace-only queries", function()
    assert.is_false(search.run_grep "   ")
    assert.is_false(search.run_grep(nil))
    assert.is_false(search.run_ack "   ")
    assert.is_false(search.run_ack(nil))
    assert.is_false(search.run_ack_trouble "   ")
    assert.is_false(search.run_ack_trouble(nil))
  end)

  it("sets grepprg and ackprg correctly when ack is available", function()
    search.setup()
    if vim.fn.executable "ack" == 1 then
      assert.is_truthy(vim.opt.grepprg:get():find "ack")
      assert.are.same("%f:%l:%c:%m", vim.o.grepformat)
      assert.is_truthy(vim.g.ackprg:find "ack")
      assert.are.same(1, vim.g.ackhighlight)
    end
  end)

  it("configures telescope vimgrep_arguments with ack", function()
    local conf = require("telescope.config").values
    if vim.fn.executable "ack" == 1 then
      assert.is_truthy(conf.vimgrep_arguments)
      assert.are.same("ack", conf.vimgrep_arguments[1])
    end
  end)
end)
