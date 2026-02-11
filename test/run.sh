#!/usr/bin/env bash
# ============================================================================
# Neovim Configuration Test Runner (Smoke + Unit)
# ============================================================================
# Usage: ./test/run.sh [--verbose]
#
# Exit codes:
#   0 = All tests passed
#   1 = One or more tests failed
#   2 = Neovim failed to start
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")"
SMOKE_TEST_FILE="$SCRIPT_DIR/regression.lua"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Neovim Configuration Tests${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Config: ${YELLOW}$CONFIG_DIR${NC}"
echo -e "Neovim: ${YELLOW}$(nvim --version | head -1)${NC}"
echo ""

# Check smoke test file exists
if [[ ! -f "$SMOKE_TEST_FILE" ]]; then
    echo -e "${RED}Error: Smoke test file not found: $SMOKE_TEST_FILE${NC}"
    exit 2
fi

# Run smoke tests
echo -e "${BLUE}Running smoke tests...${NC}"
echo ""

# Use a temp file to capture output
TMPFILE=$(mktemp)
trap "rm -f $TMPFILE" EXIT

# Run nvim with the test suite
# --headless: no UI
# -u init.lua: use the config
# -c "luafile ...": run the test file
set +e
nvim --headless \
    -u "$CONFIG_DIR/init.lua" \
    -c "luafile $SMOKE_TEST_FILE" \
    2>&1 | tee "$TMPFILE"

EXIT_CODE=${PIPESTATUS[0]}
set -e

if [[ $EXIT_CODE -ne 0 ]]; then
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}✗ Smoke tests failed (exit code: $EXIT_CODE)${NC}"
    echo -e "${YELLOW}Do NOT proceed with changes until smoke tests pass.${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit $EXIT_CODE
fi

echo ""
echo -e "${GREEN}✓ Smoke tests passed${NC}"
echo ""
echo -e "${BLUE}Running unit tests (Plenary/Busted)...${NC}"
echo ""

set +e
nvim --headless \
    -u "$CONFIG_DIR/init.lua" \
    -c "PlenaryBustedDirectory $SCRIPT_DIR/unit { minimal_init = '$CONFIG_DIR/init.lua' }" \
    -c "qa!" \
    2>&1 | tee "$TMPFILE"
UNIT_EXIT_CODE=${PIPESTATUS[0]}
set -e

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [[ $UNIT_EXIT_CODE -eq 0 ]]; then
    echo -e "${GREEN}✓ All smoke + unit tests passed${NC}"
else
    echo -e "${RED}✗ Unit tests failed (exit code: $UNIT_EXIT_CODE)${NC}"
    echo ""
    echo -e "${YELLOW}Review the output above for details.${NC}"
    echo -e "${YELLOW}Do NOT proceed with changes until unit tests pass.${NC}"
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

exit $UNIT_EXIT_CODE
