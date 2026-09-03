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

  it("builds timed cues that fit the audio duration and carry verbatim text", function()
    local bs = P.parse(
      vim.split("# Head\n\nA short paragraph here.\n\nAnother one.\n", "\n", { plain = true })
    )
    local cues = pace.cues(bs, { pace = "follow" }, 30)
    assert.equals(3, #cues)
    assert.equals(0, cues[1].start)
    assert.is_true(cues[#cues].stop <= 30.001)
    for i = 2, #cues do
      assert.is_true(cues[i].start >= cues[i - 1].stop - 0.001) -- monotonic
    end
    assert.equals("Head", cues[1].text) -- verbatim, not "Heading level 1. Head."
    assert.equals("heading", cues[1].kind)
  end)

  it("renders WebVTT with a header and HH:MM:SS.mmm cues", function()
    local bs = P.parse(vim.split("# H\n\npara.\n", "\n", { plain = true }))
    local vtt = pace.vtt(bs, { pace = "follow" }, 12)
    assert.truthy(vtt:match "^WEBVTT")
    assert.truthy(vtt:match "%d%d:%d%d:%d%d%.%d%d%d %-%-> %d%d:%d%d:%d%d%.%d%d%d")
  end)

  it("splits blocks into per-sentence cues when opts.sentences", function()
    local bs = P.parse(vim.split("# H\n\nOne thing. Two things. Three.\n", "\n", { plain = true }))
    local block_cues = pace.cues(bs, { pace = "follow" }, 30)
    local sent_cues = pace.cues(bs, { pace = "follow" }, 30, { sentences = true })
    assert.equals(2, #block_cues) -- heading + paragraph
    assert.equals(4, #sent_cues) -- heading + 3 sentences
    assert.equals("One thing.", sent_cues[2].text)
  end)

  it("derives chapters from headings that match the sections list", function()
    local bs = P.parse(
      vim.split("# Intro\n\nx.\n\n# Skip Me\n\ny.\n\n# Wrap\n\nz.\n", "\n", { plain = true })
    )
    local ch = pace.chapters(bs, { pace = "follow" }, 60, { "Intro", "Wrap" })
    assert.equals(2, #ch)
    assert.equals("Intro", ch[1].title)
    assert.equals("Wrap", ch[2].title)
    assert.is_true(ch[2].start > ch[1].start)
  end)
end)

describe("vdots.readaloud.frontmatter", function()
  local F = require "vdots.readaloud.frontmatter"
  local function fm(md)
    return F.parse(vim.split(md, "\n", { plain = true }))
  end

  it("detects an enhanced doc via format: …read-aloud", function()
    local r = fm "---\nformat: read-aloud\ntitle: Hi\n---\n\nBody.\n"
    assert.is_true(r.enhanced)
    assert.is_true(r.present)
    assert.equals("Hi", r.fm.title)
    assert.equals(5, r.body_start)
  end)

  it("detects via the pronunciation + sections + spoken_minutes triple", function()
    local r = fm(table.concat({
      "---",
      "pronunciation:",
      "  DSP: D S P",
      "sections:",
      "- One",
      "spoken_minutes: 4",
      "---",
      "",
      "Body.",
    }, "\n"))
    assert.is_true(r.enhanced)
    assert.equals("D S P", r.fm.pronunciation.DSP)
    assert.same({ "One" }, r.fm.sections)
    assert.equals(4, r.fm.spoken_minutes)
  end)

  it("is not enhanced without the markers, and a plain file is not present", function()
    assert.is_false(fm("---\ntitle: Just A Title\n---\n\nBody.\n").enhanced)
    assert.is_false(fm("# Plain\n\nBody.\n").present)
  end)
end)

describe("vdots.readaloud.parse.document", function()
  it("unwraps a whole document pasted inside a ``` fence", function()
    local md = "```markdown\n# Real Heading\n\nActual prose here.\n```\n"
    local d = P.document(vim.split(md, "\n", { plain = true }))
    assert.equals("Heading level 1. Real Heading.", d.blocks[1].speak)
    assert.equals(2, d.blocks[1].s) -- source line of the heading (fence was line 1)
    for _, b in ipairs(d.blocks) do
      assert.is_nil(b.speak:match "^Code block")
    end
  end)

  it("keeps a real code block inside a normal doc as an announcement", function()
    local md = "Intro.\n\n```lua\nlocal x = 1\n```\n\nOutro.\n"
    local d = P.document(vim.split(md, "\n", { plain = true }))
    assert.equals("Code block. lua. 1 line.", d.blocks[2].speak)
  end)

  it("maps block line numbers back through a stripped frontmatter block", function()
    local md = "---\nformat: read-aloud\ntitle: T\n---\n\n# First\n\nBody.\n"
    local d = P.document(vim.split(md, "\n", { plain = true }))
    assert.is_true(d.enhanced)
    -- the "# First" heading is source line 6
    local heading
    for _, b in ipairs(d.blocks) do
      if b.kind == "heading" then
        heading = b
        break
      end
    end
    assert.equals(6, heading.s)
  end)
end)

describe("vdots.readaloud.parse enhanced mode", function()
  it("speaks headings plainly and drops announcements", function()
    local bs = P.parse(
      vim.split("## The STAR Method\n\n> quoted bit.\n", "\n", { plain = true }),
      { enhanced = true, skip_frontmatter = true }
    )
    assert.equals("The STAR Method", bs[1].speak)
    assert.equals("heading", bs[1].kind)
    assert.equals("quoted bit.", bs[2].speak) -- no "Quote." prefix
  end)

  it("keeps the plain 'Heading level N' announcement otherwise", function()
    local bs = P.parse(vim.split("## X\n", "\n", { plain = true }))
    assert.equals("Heading level 2. X.", bs[1].speak)
  end)
end)

describe("vdots.readaloud.pronounce.lexicon", function()
  local pron = require "vdots.readaloud.pronounce"

  it("substitutes multi-word terms, case-insensitively, longest first", function()
    local out = pron.lexicon("The IAB Tech Lab governs OpenRTB at basis.", {
      ["IAB Tech Lab"] = "eye ay bee tech lab",
      OpenRTB = "open R T B",
      Basis = "BAY sis",
    })
    assert.equals("The eye ay bee tech lab governs open R T B at BAY sis.", out)
  end)

  it("skips exact-identity hints and leaves unknown text alone", function()
    assert.equals(
      "React and MongoDB now",
      pron.lexicon("React and MongoDB now", { React = "React", MongoDB = "MongoDB" })
    )
  end)
end)
