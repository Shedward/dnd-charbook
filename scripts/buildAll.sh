#!/usr/bin/env sh

set -e

mkdir -p build

for book in books/*.typ; do
  [ -e "$book" ] || continue

  book_name=`basename "${book%.typ}"`
  typst compile "books/$book_name.typ" --root . build/$book_name.pdf
done
