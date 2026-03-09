#!/usr/bin/env bash
# Print the first N spell IDs from spellbook.json that have not been proofread.
# Usage: spells-pending-proofread.sh [N]
#   N — how many IDs to return (default: 20)

set -euo pipefail

SPELLS_OUT="/Users/shed/Projects/dnd-charbook/resources/data/spellbook.json"
N="${1:-20}"

jq --argjson n "$N" '[.[] | select(.proofread != true) | .id] | .[0:$n]' "$SPELLS_OUT"
