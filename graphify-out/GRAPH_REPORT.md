# Graph Report - nvim  (2026-11-15)

## Corpus Check
- 137 files · ~86,819 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 837 nodes · 907 edges · 108 communities (56 shown, 19 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 1 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `4913639c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Completed Tasks
- Keymaps
- Expert Audit (2026-02-28) — Medium Impact
- player.lua
- Process
- setup-matt-pocock-skills/SKILL.md
- Triage
- What You Must Do When Invoked
- Keymaps
- tdd/SKILL.md
- Plugins
- 🛠️ Essential Development Tools
- fzf.lua
- parse.lua
- pace.lua
- HTML Report Format
- LSP and Tooling
- Repository Guidelines
- Diagnose
- Process
- vdots-listen
- Read-Aloud
- usage.lua
- vdots-readalong
- graphify reference: extra exports and benchmark
- CONTEXT.md Format
- to-prd/SKILL.md
- Writing Skills
- vdots-guide-image
- vdots-listen-catalog.py
- preview.lua
- Dependency categories
- System Cartography & Schema Topology
- explorer.lua
- During the session
- /ponytail — Reducing Premature Technical Debt
- llm.lua
- mediakeys.lua
- graphify reference: query, path, explain
- ADR Format
- Process
- Machine, Heal Thyself
- zdots/init.lua
- caveman/SKILL.md
- Process
- Language
- vdots-mediakey-helper.swift
- options.lua
- AI Surface & Multi-Agent Integration Guide
- Security Policy
- hitl-loop.template.sh
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native AGENTS.md integration
- graphify reference: incremental update and cluster-only
- vdots-ctl
- vdots-read
- vdots-readability
- Issue Tracker: Backlog.md CLI (`backlog`) & Groma.md (`groma`)
- errors.lua
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- vdots-readaloud-swiftbar
- Domain & Architecture Navigation (`vdots`)
- Triage Labels
- index.md
- terminal.lua
- frontmatter.lua
- extraction-spec.md
- vdots
- vdots-doctor
- vdots-publish
- vdots-update
- commit-msg
- lint.sh
- run.sh

## God Nodes (most connected - your core abstractions)
1. `Keymaps` - 22 edges
2. `Keymaps` - 15 edges
3. `M.parse()` - 13 edges
4. `What You Must Do When Invoked` - 12 edges
5. `LSP and Tooling` - 12 edges
6. `Plugins` - 12 edges
7. `Repository Guidelines` - 11 edges
8. `🛠️ Essential Development Tools` - 11 edges
9. `/graphify` - 10 edges
10. `Triage` - 9 edges

## Surprising Connections (you probably didn't know these)
- `analyse()` --calls--> `add()`  [INFERRED]
  lua/vdots/readaloud/player.lua → lua/editor/commands.lua

## Import Cycles
- None detected.

## Communities (108 total, 19 thin omitted)

### Community 0 - "Completed Tasks"
Cohesion: 0.05
Nodes (42): Ad-hoc Fixes (discovered during 2026-02-28 audit), Completed Tasks, Expert Audit (2026-02-28) — Bugs / Defects (6/6 Complete), P0 - Potential Data Loss (3/3 Complete), P1 - Broken Functionality (5/5 Complete), P2 - Double Execution / Race Conditions (3/3 Complete), P3 - Redundancy / Cleanup (4/4 Complete), P4 - Best Practices / Optimization (2/5 Complete) (+34 more)

### Community 1 - "Keymaps"
Cohesion: 0.04
Nodes (40): Architecture, Control-plane CLI (`bin/`), Entrypoint, Module Layout, Plugin Manager, zdots Integration (`lua/zdots/`), Quick Reference, The ecosystem (+32 more)

### Community 2 - "Expert Audit (2026-02-28) — Medium Impact"
Cohesion: 0.06
Nodes (31): Expert Audit (2026-02-28) — Bugs / Defects, Expert Audit (2026-02-28) — High Impact, Expert Audit (2026-02-28) — Long Term / Architectural, Expert Audit (2026-02-28) — Medium Impact, [ ] H-1: Add terminal integration, [ ] L-1: Use global vim.lsp.config("*") for shared on_attach, [ ] L-2: Remove vim.deprecate monkey-patch in healthcheck.lua, [ ] M-2: Replace vim-surround with nvim-surround (+23 more)

### Community 3 - "player.lua"
Cohesion: 0.11
Nodes (28): add(), installed_voices(), M.diagnose(), M.get(), M.resolve_voice(), analyse(), block_at(), clear_hl() (+20 more)

### Community 4 - "Process"
Cohesion: 0.07
Nodes (28): 1. State the question, 2. Pick the language, 3. Isolate the logic in a portable module, 4. Build the smallest TUI that exposes the state, 5. Make it runnable in one command, 6. Hand it over, 7. Capture the answer, Anti-patterns (+20 more)

### Community 5 - "setup-matt-pocock-skills/SKILL.md"
Cohesion: 0.06
Nodes (25): Before exploring, read these, Domain Docs, File structure, Flag ADR conflicts, Use the glossary's vocabulary, Conventions, Issue tracker: GitHub, When a skill says "fetch the relevant ticket" (+17 more)

### Community 6 - "Triage"
Cohesion: 0.06
Nodes (28): Bad agent brief, Behavioral, not procedural, Complete acceptance criteria, Durability over precision, Examples, Explicit scope boundaries, Good agent brief (bug), Good agent brief (enhancement) (+20 more)

### Community 7 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native AGENTS.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 8 - "Keymaps"
Cohesion: 0.08
Nodes (25): Abbreviations, AI & Code Intelligence, Code Formatting (Conform), Command-line, Commands, Completion (blink.cmp), Development, Explorer (nvim-tree with NERDTree compatibility) (+17 more)

### Community 9 - "tdd/SKILL.md"
Cohesion: 0.09
Nodes (17): Deep Modules, Interface Design for Testability, Designing for Mockability, When to Mock, Refactor Candidates, 1. Planning, 2. Tracer Bullet, 3. Incremental Loop (+9 more)

### Community 10 - "Plugins"
Cohesion: 0.17
Nodes (12): AI, Debugging (DAP), Editing Primitives (tpope + utilities), Git, LSP & Completion, Navigation & Files, Plugins, Ruby & Rails (+4 more)

### Community 11 - "🛠️ Essential Development Tools"
Cohesion: 0.11
Nodes (18): AI & Code Intelligence, Code Formatting (Conform), Editing & Clipboard, ERB & LSP, 🛠️ Essential Development Tools, External Changes and Usage, Git & Diffing, Navigation & UI (+10 more)

### Community 12 - "fzf.lua"
Cohesion: 0.19
Nodes (12): M.ack(), M.ack_visual(), M.ack_word(), M.get_ack_cmd(), M.setup(), M.run_ack(), M.run_ack_trouble(), M.run_ack_visual() (+4 more)

### Community 13 - "parse.lua"
Cohesion: 0.23
Nodes (14): atx_heading(), cells(), fence_lang(), is_blank(), is_fence(), is_hrule(), is_ref_def(), is_table_row() (+6 more)

### Community 14 - "pace.lua"
Cohesion: 0.30
Nodes (13): M.breathe(), M.chapters(), M.chapters_vtt(), M.cues(), M.estimate(), M.lead(), M.marker(), M.script() (+5 more)

### Community 15 - "HTML Report Format"
Cohesion: 0.15
Nodes (13): Call-graph collapse, Candidate card, Cross-section (good for layered shallowness), Diagram patterns, Hand-built boxes-and-arrows (when Mermaid's layout fights you), Header, HTML Report Format, Mass diagram (good for "interface as wide as implementation") (+5 more)

### Community 16 - "LSP and Tooling"
Cohesion: 0.15
Nodes (13): CLI Tooling, Completion, Debugging (DAP), Embedded Language LSP, Formatters (conform.nvim, on save), Language Servers, Linters (nvim-lint), LSP and Tooling (+5 more)

### Community 17 - "Repository Guidelines"
Cohesion: 0.17
Nodes (11): Build, Test, and Development Commands, Coding Style & Naming Conventions, Commit & Pull Request Guidelines, Groma, No AI Attribution, Anywhere, Platform Integration & Machine Context, Project Structure & Module Organization, Repository Guidelines (+3 more)

### Community 18 - "Diagnose"
Cohesion: 0.17
Nodes (11): Diagnose, Iterate on the loop itself, Non-deterministic bugs, Phase 1 — Build a feedback loop, Phase 2 — Reproduce, Phase 3 — Hypothesise, Phase 4 — Instrument, Phase 5 — Fix + regression test (+3 more)

### Community 19 - "Process"
Cohesion: 0.17
Nodes (11): 1. Gather context, 2. Explore the codebase (optional), 3. Draft vertical slices, 4. Quiz the user, 5. Publish the issues to the issue tracker, Acceptance criteria, Blocked by, Parent (+3 more)

### Community 20 - "vdots-listen"
Cohesion: 0.33
Nodes (9): vdots-listen script, cmd_publish(), die(), doc_title(), _has_fm(), rebuild(), resolve_source(), slugify() (+1 more)

### Community 21 - "Read-Aloud"
Cohesion: 0.17
Nodes (12): CLI reference, Data flow, Dependencies, Enhanced read-aloud documents, In the editor, Module map, Pacing, Read-Aloud (+4 more)

### Community 22 - "usage.lua"
Cohesion: 0.35
Nodes (11): aggregate(), build_report(), install_cmdline(), install_onkey(), logfile(), M.flush(), M.record(), M.setup() (+3 more)

### Community 23 - "vdots-readalong"
Cohesion: 0.36
Nodes (9): build_lines(), chapter_at(), esc(), frame_svg(), main(), Flatten cues -> display lines. Returns (lines, sent_span) where sent_span[i] =…, vtt_ts(), wrap() (+1 more)

### Community 24 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 25 - "CONTEXT.md Format"
Cohesion: 0.22
Nodes (6): CONTEXT.md Format, Rules, Single vs multi-context repos, Structure, Domain awareness, File structure

### Community 26 - "to-prd/SKILL.md"
Cohesion: 0.22
Nodes (8): Further Notes, Implementation Decisions, Out of Scope, Problem Statement, Process, Solution, Testing Decisions, User Stories

### Community 27 - "Writing Skills"
Cohesion: 0.22
Nodes (8): Description Requirements, Process, Review Checklist, SKILL.md Template, Skill Structure, When to Add Scripts, When to Split Files, Writing Skills

### Community 28 - "vdots-guide-image"
Cohesion: 0.39
Nodes (8): blocks(), esc(), inline(), main(), page_svg(), paginate(), Markdown -> a flat list of render items: (kind, text, height) where kind in…, wrap()

### Community 29 - "vdots-listen-catalog.py"
Cohesion: 0.53
Nodes (8): build_article(), build_catalog(), build_md(), dur(), esc(), load_json(), main(), sessions()

### Community 30 - "preview.lua"
Cohesion: 0.33
Nodes (4): M.is_open(), M.open(), M.refresh_lines(), M.win()

### Community 31 - "Dependency categories"
Cohesion: 0.25
Nodes (8): 1. In-process, 2. Local-substitutable, 3. Remote but owned (Ports & Adapters), 4. True external (Mock), Deepening, Dependency categories, Seam discipline, Testing strategy: replace, don't layer

### Community 32 - "System Cartography & Schema Topology"
Cohesion: 0.22
Nodes (8): 1. Core Principles, 2. Standard Workflows by Application, 3. C4 Architecture & AST Graph Integration (`Groma.md` + `graphify`), 4. System Map Documentation, Context Engine (`~/my/context-engine`), Hallway (`~/github.com/just3ws/hallway`), System Cartography & Schema Topology, WWWorkRemote (`~/github.com/wwworkremote/wwworkremote`)

### Community 35 - "During the session"
Cohesion: 0.29
Nodes (7): Challenge against the glossary, Cross-reference with code, Discuss concrete scenarios, During the session, Offer ADRs / Backlog Decisions sparingly, Sharpen fuzzy language, Update CONTEXT.md inline

### Community 36 - "/ponytail — Reducing Premature Technical Debt"
Cohesion: 0.29
Nodes (6): 1. When to Use This Skill, 2. The Complexity Razor: 5 Interrogations, 3. The Ponytail Ladder, 4. How to Annotate a Seam, 5. Audit Workflow for Agents, /ponytail — Reducing Premature Technical Debt

### Community 37 - "llm.lua"
Cohesion: 0.48
Nodes (5): collect(), M.setup(), notify(), query(), range_or_nil()

### Community 38 - "mediakeys.lua"
Cohesion: 0.38
Nodes (3): M.build(), M.start(), src_path()

### Community 39 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 40 - "ADR Format"
Cohesion: 0.33
Nodes (6): ADR Format, Numbering, Optional sections, Template, What qualifies, When to offer an ADR

### Community 41 - "Process"
Cohesion: 0.33
Nodes (6): 1. Explore, 2. Present candidates as an HTML report, 3. Grilling loop, Glossary, Improve Codebase Architecture, Process

### Community 42 - "Machine, Heal Thyself"
Cohesion: 0.33
Nodes (5): Goal, Guidelines, Machine, Heal Thyself, Prerequisites, Workflow

### Community 44 - "caveman/SKILL.md"
Cohesion: 0.40
Nodes (4): Auto-Clarity Exception, Examples, Persistence, Rules

### Community 46 - "Process"
Cohesion: 0.40
Nodes (5): 1. Frame the problem space, 2. Spawn sub-agents, 3. Present and compare, Interface Design, Process

### Community 47 - "Language"
Cohesion: 0.40
Nodes (5): Language, Principles, Rejected framings, Relationships, Terms

### Community 48 - "vdots-mediakey-helper.swift"
Cohesion: 0.40
Nodes (4): AppKit, nvim(), MediaPlayer, String

### Community 49 - "options.lua"
Cohesion: 0.70
Nodes (4): has_python_module(), probe_python_host(), python_cache_key(), resolve_python_host()

### Community 50 - "AI Surface & Multi-Agent Integration Guide"
Cohesion: 0.40
Nodes (4): 1. Environment Posture (Home vs. Work), 2. Per-Agent Integration Requirements, 3. Shared Non-Negotiable Rules, AI Surface & Multi-Agent Integration Guide

### Community 51 - "Security Policy"
Cohesion: 0.40
Nodes (4): Reporting a vulnerability, Scope, Security Policy, What this repo already does

### Community 52 - "hitl-loop.template.sh"
Cohesion: 0.83
Nodes (3): capture(), hitl-loop.template.sh script, step()

### Community 53 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 54 - "graphify reference: commit hook and native AGENTS.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native AGENTS.md integration, graphify reference: commit hook and native AGENTS.md integration

### Community 55 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 56 - "vdots-ctl"
Cohesion: 0.83
Nodes (3): vdots-ctl script, check(), run_healthcheck()

### Community 57 - "vdots-read"
Cohesion: 0.67
Nodes (3): vdots-read script, auto_voice(), VDOTS_PACE

### Community 58 - "vdots-readability"
Cohesion: 0.83
Nodes (3): band(), main(), syllables()

### Community 59 - "Issue Tracker: Backlog.md CLI (`backlog`) & Groma.md (`groma`)"
Cohesion: 0.50
Nodes (3): Creating and Managing Tasks, Issue Tracker: Backlog.md CLI (`backlog`) & Groma.md (`groma`), Linking Tasks to Groma Architecture

## Knowledge Gaps
- **397 isolated node(s):** `AppKit`, `MediaPlayer`, `lint.sh script`, `run.sh script`, `Persistence` (+392 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 522 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **19 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Vdots` connect `Keymaps` to `Keymaps`?**
  _High betweenness centrality (0.006) - this node is a cross-community bridge._
- **Why does `Completed Tasks` connect `Completed Tasks` to `Expert Audit (2026-02-28) — Medium Impact`?**
  _High betweenness centrality (0.006) - this node is a cross-community bridge._
- **What connects `AppKit`, `MediaPlayer`, `lint.sh script` to the rest of the system?**
  _397 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Completed Tasks` be split into smaller, more focused modules?**
  _Cohesion score 0.046511627906976744 - nodes in this community are weakly interconnected._
- **Should `Keymaps` be split into smaller, more focused modules?**
  _Cohesion score 0.04343971631205674 - nodes in this community are weakly interconnected._
- **Should `Expert Audit (2026-02-28) — Medium Impact` be split into smaller, more focused modules?**
  _Cohesion score 0.06060606060606061 - nodes in this community are weakly interconnected._
- **Should `player.lua` be split into smaller, more focused modules?**
  _Cohesion score 0.1066066066066066 - nodes in this community are weakly interconnected._