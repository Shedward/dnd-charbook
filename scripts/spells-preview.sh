#!/usr/bin/env bash
# Build the spell preview PDF and report any errors.
# Usage: spells-preview.sh [--full]
#   --full  — build spellbook-test.typ (all spells) instead of last-10 preview

set -euo pipefail

ROOT="/Users/shed/Projects/dnd-charbook"
BOOK="spellbook-preview"
if [[ "${1:-}" == "--full" ]]; then
  BOOK="spellbook-test"
fi

typst compile "$ROOT/books/$BOOK.typ" --root "$ROOT" "$ROOT/build/$BOOK.pdf"
echo "Built $ROOT/build/$BOOK.pdf"
