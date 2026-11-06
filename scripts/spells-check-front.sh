#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
clipped=$(typst eval --root . --in books/debug/spells-check-front.typ --format json 'query(<clipped-spell-front>).map(it => it.value)')
jq -r '"Не помещаются на лицевой стороне: \(length)", (.[] | "\(.name) (\(.id))")' <<< "$clipped"
jq -e 'length == 0' <<< "$clipped" > /dev/null
