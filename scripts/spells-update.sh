#!/usr/bin/env bash
# Update existing spell records in spellbook.json by ID.
# Usage: spells-update.sh '<json-array>'
#   Records in the array replace existing records with matching IDs.
#
# Writes atomically via a temp file.

set -euo pipefail

SPELLS_OUT="/Users/shed/Projects/dnd-charbook/resources/data/spellbook.json"
TMP=$(mktemp)

if [[ $# -eq 0 ]]; then
  echo "Usage: spells-update.sh '<json-array>'" >&2
  exit 1
fi

NEW_RECORDS="$1"

# Validate input is a JSON array
if ! echo "$NEW_RECORDS" | jq -e 'if type == "array" then true else error("not an array") end' > /dev/null 2>&1; then
  echo "Error: argument must be a JSON array" >&2
  exit 1
fi

jq --argjson updates "$NEW_RECORDS" '
  ($updates | map({(.id): .}) | add) as $lookup
  | map(if .id | in($lookup) then $lookup[.id] else . end)
' "$SPELLS_OUT" > "$TMP"

mv "$TMP" "$SPELLS_OUT"
echo "Updated $(echo "$NEW_RECORDS" | jq 'length') spells in $SPELLS_OUT"
