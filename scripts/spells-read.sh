#!/usr/bin/env bash
# Read spell records by ID from spells.json and/or text_spells.json.
# Usage: spells-read.sh [--text] <id1> [id2 ...]
#   --text  — read from text_spells.json instead of spells.json
#   IDs     — one or more spell IDs to extract
#
# Prints a JSON array of matching records.

set -euo pipefail

SPELLS_SRC="/Users/shed/Projects/dnd-soup/spells.json"
TEXT_SRC="/Users/shed/Projects/dnd-soup/text_spells.json"

SOURCE="$SPELLS_SRC"
if [[ "${1:-}" == "--text" ]]; then
  SOURCE="$TEXT_SRC"
  shift
fi

if [[ $# -eq 0 ]]; then
  echo "Usage: spells-read.sh [--text] <id1> [id2 ...]" >&2
  exit 1
fi

# Build a jq IN() filter from the remaining args
IDS=$(printf '%s\n' "$@" | jq -Rs 'split("\n") | map(select(length > 0))')

jq --argjson ids "$IDS" \
  '[.[] | select(.id | IN($ids[]))]' \
  "$SOURCE"
