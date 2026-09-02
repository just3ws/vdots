local P = require "vdots.readaloud.parse"

local function blocks(md)
  return P.parse(vim.split(md, "\n", { plain = true }))
end
local function speak(bs)
  return vim.tbl_map(function(b)
    return b.speak
  end, bs)
end

describe("vdots.readaloud.parse", function()
  it("skips YAML frontmatter but keeps the title", function()
    local b = blocks '---\ntitle: "Hello World"\ntags: [x]\n---\n\nBody text here.'
    assert.same({ "Title. Hello World", "Body text here." }, speak(b))
  end)

  it("announces a fenced code block instead of reading it", function()
    local b = blocks "Intro line.\n\n```lua\nlocal x = 1\nprint(x)\n```\n"
    assert.same({ "Intro line.", "Code block. lua. 2 lines." }, speak(b))
  end)

  it("reads link text and drops URLs / autolinks / HTML", function()
    local b = blocks "See [the docs](https://example.com/x) and <https://auto.link> in <b>bold</b>."
    assert.same({ "See the docs and link in bold." }, speak(b))
  end)

  it("announces heading level for ATX and setext", function()
    assert.same({ "Heading level 3. Third." }, speak(blocks "### Third"))
    assert.same({ "Heading level 1. Big Title." }, speak(blocks "Big Title\n========"))
    assert.same({ "Heading level 2. Sub Title." }, speak(blocks "Sub Title\n---------"))
  end)

  it("labels task-list checkboxes", function()
    local b = blocks "- [ ] pending\n- [x] finished\n- plain"
    assert.same({ "to do: pending", "done: finished", "plain" }, speak(b))
  end)

  it("reads table rows as header: value", function()
    local b = blocks "| Name | Role |\n|------|------|\n| Alice | Dev |\n"
    assert.same({ "Name: Alice. Role: Dev." }, speak(b))
  end)

  it("resolves HTML entities and skips reference-link definitions", function()
    local b = blocks "Tom &amp; Jerry.\n\n[ref]: https://example.com/ref"
    assert.same({ "Tom and Jerry." }, speak(b))
  end)

  it("gives every block a real source line range", function()
    for _, b in ipairs(blocks "# H\n\npara one\n\npara two\n") do
      assert.is_true(b.s >= 1 and b.e >= b.s)
    end
  end)

  it("returns nothing for an empty buffer", function()
    assert.same({}, blocks "")
  end)
end)

describe("vdots.readaloud.pronounce", function()
  local pron = require "vdots.readaloud.pronounce"

  it("spells acronyms and phonetic-izes tool names", function()
    assert.equals(
      "Run cube cuttle against kubernetes over H T T P S.",
      pron.apply "Run kubectl against k8s over HTTPS."
    )
  end)

  it("keeps trailing punctuation", function()
    assert.equals(
      "Read the yammel, the jason, and the U R L.",
      pron.apply "Read the YAML, the JSON, and the URL."
    )
  end)

  it("honours overrides and false-disables a builtin", function()
    assert.equals(
      "wibble and nginx",
      pron.apply("foo and nginx", { foo = "wibble", nginx = false })
    )
  end)
end)

describe("vdots.readaloud.pace", function()
  local pace = require "vdots.readaloud.pace"

  it("tags block kinds and inserts a bigger beat before a section", function()
    local bs = P.parse(vim.split("# One\n\npara a.\n\n## Two\n\npara b.\n", "\n", { plain = true }))
    local kinds = vim.tbl_map(function(b)
      return b.kind
    end, bs)
    assert.same({ "heading", "para", "heading", "para" }, kinds)

    local script = pace.script(bs, { pace = "follow" })
    -- section lead (750) > paragraph lead (400) > after-heading lead (250)
    assert.truthy(script:find "%[%[slnc 750%]%] Heading level 2")
    assert.truthy(script:find "%[%[slnc 250%]%] para a")
    assert.is_nil(script:match "^%[%[slnc") -- no lead on the very first block
  end)

  it("keeps list items moving (shorter gap than paragraphs)", function()
    local bs = P.parse(vim.split("- one\n- two\n", "\n", { plain = true }))
    local s = pace.settings { pace = "follow" }
    assert.is_true(pace.lead("list", "list", s) < pace.lead("para", "para", s))
  end)

  it("rate follows the preset unless overridden", function()
    assert.equals(160, pace.settings({ pace = "follow" }).rate)
    assert.equals(210, pace.settings({ pace = "natural" }).rate)
    assert.equals(999, pace.settings({ pace = "follow", rate = 999 }).rate)
  end)
end)
