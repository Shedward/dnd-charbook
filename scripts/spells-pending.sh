#!/usr/bin/env bash
# Print the first N unprocessed spell IDs (one per line).
# Usage: spells-pending.sh [N]
#   N — how many IDs to return (default: 15)
#
# Compares source spells.json against spellbook.json and prints
# IDs that are in the source but not yet in the output.

set -euo pipefail

SPELLS_SRC="/Users/shed/Projects/dnd-soup/spells.json"
SPELLS_OUT="/Users/shed/Projects/dnd-charbook/resources/data/spellbook.json"
N="${1:-15}"

if [[ ! -f "$SPELLS_OUT" ]]; then
  jq -r --argjson n "$N" '.[].id | @json' "$SPELLS_SRC" \
    | head -n "$N" \
    | jq -rs '.'
  exit 0
fi

jq -rn \
  --slurpfile src "$SPELLS_SRC" \
  --slurpfile out "$SPELLS_OUT" \
  --argjson n "$N" \
  '($out[0] | map(.id) | {done: .}) as $seen
  | $src[0]
  | map(select(.id | IN($seen.done[]) | not))
  | .[0:$n]
  | map(.id)'
