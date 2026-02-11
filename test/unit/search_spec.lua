local search = require "editor.search"

describe("editor.search", function()
  it("normalizes non-empty query strings", function()
    assert.are.equal("foo", search.normalize_query "  foo  ")
  end)

  it("returns nil for empty query strings", function()
    assert.is_nil(search.normalize_query "   ")
  end)

  it("builds grep command with shellescaped query", function()
    local query = "foo bar"
    local expected = ("silent grep! %s"):format(vim.fn.shellescape(query))
    assert.are.equal(expected, search.build_grep_cmd(query))
  end)
end)
