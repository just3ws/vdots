#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Running Lua lint and style checks..."

luacheck . --no-cache --config .luacheckrc
stylua --check .

if command -v selene >/dev/null 2>&1; then
  selene .
else
  echo "selene not found; skipping (install from Kampfkarren/selene for stricter Lua diagnostics)."
fi

echo "Lint checks passed."
