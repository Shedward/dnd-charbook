#!/usr/bin/env bash
# Build the spell preview PDF and report any errors.
# Usage: spells-preview.sh [--full] [N]
#   --full  — build spellbook-test.typ (all spells) instead of batch preview
#   N       — number of spells to show (default: 5)

set -euo pipefail

ROOT="/Users/shed/Projects/dnd-charbook"
BOOK="spellbook-preview"
COUNT=5

for arg in "$@"; do
  if [[ "$arg" == "--full" ]]; then
    BOOK="spellbook-test"
  elif [[ "$arg" =~ ^[0-9]+$ ]]; then
    COUNT="$arg"
  fi
done

if [[ "$BOOK" == "spellbook-preview" ]]; then
  typst compile "$ROOT/books/$BOOK.typ" --root "$ROOT" "$ROOT/build/$BOOK.pdf" --input count="$COUNT"
else
  typst compile "$ROOT/books/$BOOK.typ" --root "$ROOT" "$ROOT/build/$BOOK.pdf"
fi
echo "Built $ROOT/build/$BOOK.pdf"
