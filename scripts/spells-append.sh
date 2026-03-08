#!/usr/bin/env bash
# Append one or more spell records to spellbook.json.
# Usage: spells-append.sh '<json-array>'
#   The argument must be a valid JSON array of spell record objects.
#
# Creates spellbook.json if it does not exist.
# Writes atomically via a temp file.

set -euo pipefail

SPELLS_OUT="/Users/shed/Projects/dnd-charbook/resources/data/spellbook.json"
TMP=$(mktemp)

if [[ $# -eq 0 ]]; then
  echo "Usage: spells-append.sh '<json-array>'" >&2
  exit 1
fi

NEW_RECORDS="$1"

# Validate input is a JSON array
if ! echo "$NEW_RECORDS" | jq -e 'if type == "array" then true else error("not an array") end' > /dev/null 2>&1; then
  echo "Error: argument must be a JSON array" >&2
  exit 1
fi

if [[ -f "$SPELLS_OUT" ]]; then
  jq --argjson new "$NEW_RECORDS" '. + $new' "$SPELLS_OUT" > "$TMP"
else
  echo "$NEW_RECORDS" | jq '.' > "$TMP"
fi

mv "$TMP" "$SPELLS_OUT"
echo "Wrote $(jq 'length' "$SPELLS_OUT") total spells to $SPELLS_OUT"
