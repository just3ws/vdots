local search = require "editor.search"

describe("editor.search", function()
  it("rejects empty or whitespace-only queries", function()
    assert.is_false(search.run_grep "   ")
    assert.is_false(search.run_grep(nil))
  end)
end)
