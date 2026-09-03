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

# bin/ scripts + the zsh completion parse clean
echo "Checking shell script syntax..."
for f in bin/vdots bin/vdots-ctl bin/vdots-doctor bin/vdots-listen bin/vdots-publish bin/vdots-read bin/vdots-update; do
  bash -n "$f"
done
command -v shellcheck >/dev/null 2>&1 && shellcheck -x -S error bin/vdots bin/vdots-ctl bin/vdots-doctor bin/vdots-listen bin/vdots-publish bin/vdots-read bin/vdots-update
command -v zsh >/dev/null 2>&1 && zsh -n completions/_vdots

# man pages: fail on ERROR/FATAL, tolerate mandoc's style nits
if command -v mandoc >/dev/null 2>&1; then
  echo "Checking man pages..."
  for m in man/man1/*.1; do
    if mandoc -T lint "$m" 2>&1 | grep -qE 'mandoc: .*(ERROR|FATAL):'; then
      mandoc -T lint "$m"; echo "mandoc error in $m"; exit 1
    fi
  done
fi

echo "Lint checks passed."
