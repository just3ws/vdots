# Domain & Architecture Navigation (`vdots`)

## Orientation Order for Agents

1. **`AGENTS.md`** (or `CLAUDE.md` / `README.md`) — repository rules, verification gates, and operational boundaries.
2. **`graphify-out/GRAPH_REPORT.md` & `graphify-out/graph.json`** — AST + semantic knowledge graph (god nodes, communities, surprising connections). Query via `/graphify query "<question>"`.
3. **`groma/`** — live C4 architecture map in Open Knowledge Format (OKF) Markdown. Inspect via `groma view` or `groma agent-instructions`.
4. **`backlog/`** — active and completed engineering tasks managed via the `backlog` CLI.
