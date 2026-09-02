local ra = require "editor.readaloud"

---@param md string
local function parse(md)
  return ra.parse(vim.split(md, "\n", { plain = true }))
end

---@param utts table
local function texts(utts)
  return vim.tbl_map(function(u)
    return u.text
  end, utts)
end

describe("editor.readaloud.parse", function()
  it("skips YAML frontmatter but keeps the title", function()
    local u = parse '---\ntitle: "Hello World"\ntags: [x]\n---\n\nBody text here.'
    local t = texts(u)
    assert.same({ "Title. Hello World", "Body text here." }, t)
  end)

  it("announces a fenced code block instead of reading it", function()
    local u = parse "Intro line.\n\n```lua\nlocal x = 1\nprint(x)\n```\n"
    local t = texts(u)
    assert.same({ "Intro line.", "Code block. lua. 2 lines." }, t)
  end)

  it("reads link text, not the URL", function()
    local u = parse "See [the docs](https://example.com/deep/path) now."
    assert.same({ "See the docs now." }, texts(u))
  end)

  it("announces heading level", function()
    local u = parse "### Third Level"
    assert.same({ "Heading level 3. Third Level." }, texts(u))
  end)

  it("splits a paragraph into sentences", function()
    local u = parse "One thing. Two things! Three?"
    assert.same({ "One thing.", "Two things!", "Three?" }, texts(u))
  end)

  it("reads table rows as header: value pairs", function()
    local u = parse "| Name | Role |\n|------|------|\n| Alice | Dev |\n"
    assert.same({ "Name: Alice. Role: Dev." }, texts(u))
  end)

  it("maps every utterance to a real line range", function()
    local u = parse "# H\n\npara one\n"
    for _, utt in ipairs(u) do
      assert.is_true(utt.s >= 1 and utt.e >= utt.s)
    end
  end)

  it("returns nothing for an empty buffer", function()
    assert.same({}, parse "")
  end)
end)
