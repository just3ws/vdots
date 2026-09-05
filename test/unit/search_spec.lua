local search = require "editor.search"

describe("editor.search", function()
  it("rejects empty or whitespace-only queries", function()
    assert.is_false(search.run_grep "   ")
    assert.is_false(search.run_grep(nil))
    assert.is_false(search.run_ack "   ")
    assert.is_false(search.run_ack(nil))
  end)

  it("sets grepprg correctly when ack is available", function()
    search.setup()
    if vim.fn.executable "ack" == 1 then
      assert.is_truthy(vim.opt.grepprg:get():find "ack")
      assert.are.same("%f:%l:%c:%m", vim.o.grepformat)
    end
  end)
end)
