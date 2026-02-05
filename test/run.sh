#!/usr/bin/env bash
# ============================================================================
# Neovim Configuration Regression Test Runner
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
TEST_FILE="$SCRIPT_DIR/regression.lua"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Neovim Configuration Regression Tests${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Config: ${YELLOW}$CONFIG_DIR${NC}"
echo -e "Neovim: ${YELLOW}$(nvim --version | head -1)${NC}"
echo ""

# Check test file exists
if [[ ! -f "$TEST_FILE" ]]; then
    echo -e "${RED}Error: Test file not found: $TEST_FILE${NC}"
    exit 2
fi

# Run tests
echo -e "${BLUE}Running tests...${NC}"
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
    -c "luafile $TEST_FILE" \
    2>&1 | tee "$TMPFILE"

EXIT_CODE=${PIPESTATUS[0]}
set -e

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [[ $EXIT_CODE -eq 0 ]]; then
    echo -e "${GREEN}✓ All regression tests passed${NC}"
else
    echo -e "${RED}✗ Some tests failed (exit code: $EXIT_CODE)${NC}"
    echo ""
    echo -e "${YELLOW}Review the output above for details.${NC}"
    echo -e "${YELLOW}Do NOT proceed with changes until tests pass.${NC}"
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

exit $EXIT_CODE
