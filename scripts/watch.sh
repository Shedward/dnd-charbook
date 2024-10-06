#!/usr/bin/env sh

set -e

book_name="$1"
typ_file="books/${book_name}.typ"
pdf_file="build/${book_name}.pdf"

typst compile "${typ_file}" --root . "${pdf_file}"
open -a Skim.app "${pdf_file}"
typst watch "${typ_file}" --root . "${pdf_file}"
