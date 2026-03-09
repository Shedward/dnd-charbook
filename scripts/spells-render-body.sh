#!/usr/bin/env bash
# Render a spell body string and print its text content to stdout.
# Uses Typst's experimental HTML export to extract readable text.
# Usage: scripts/spells-render-body.sh 'body string'

set -euo pipefail

BODY="${1?Usage: spells-render-body.sh 'body string'}"
TMP_HTML=$(mktemp /tmp/body-preview-XXXX.html)

typst compile books/body-preview.typ --root . \
  --features html \
  --input "body=$BODY" \
  --format html "$TMP_HTML" 2>/dev/null

# Replace tags with spaces, collapse whitespace
sed 's/<[^>]*>/ /g' "$TMP_HTML" \
  | tr -s ' \t\n' ' ' \
  | sed 's/^ //; s/ $//'
echo
rm -f "$TMP_HTML"
