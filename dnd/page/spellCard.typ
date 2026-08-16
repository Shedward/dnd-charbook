#import "../core/core.typ": *
#import "../core/layout.typ": *

#let spellCardLayout(body) = framed(
  fitting: expand,
  insets: paddings(2),
  alignment: center + top,
  stroke: strokes.thin + colors.secondary,
  body,
)

#let spellCardChip(content, alignment: center + horizon) = box(
  width: 100%,
  inset: paddings(0.5),
  align(alignment, if content != none {
    text(font: fonts.header, size: 9pt, smallcaps(content))
  })
)

#let spellCardDivider = line(
  angle: 90deg,
  length: paddings(1),
  stroke: strokes.hairline + colors.secondary,
)

#let spellCardSectionDivider = {
  let segment = line(length: 100%, stroke: strokes.thin + colors.secondary)
  grid(
    columns: (1fr, auto, 1fr),
    align: horizon,
    column-gutter: paddings(0.5),
    segment,
    rhombus(width: 1.5mm, stroke: strokes.thin + colors.secondary, fill: colors.secondary),
    segment,
  )
}

#let spellCardLevelBadge(level) = {
  let label = if level == none {
    []
  } else if level == 0 {
    sym.infinity
  } else {
    roman(level)
  }
  text(font: fonts.ability, size: 18pt, label)
}

#let spellCardResources(spell) = pad(x: -paddings(2), grid(
  columns: (1fr, auto, 1fr, auto, 2fr),
  align: center + horizon,
  spellCardChip(spell.components),
  spellCardDivider,
  spellCardChip(spell.castTime),
  spellCardLevelBadge(spell.at("level", default: none)),
  spellCardChip(spell.castType),
))

#let spellCardTarget(spell) = grid(
  columns: (1fr, auto, 1fr),
  align: center + horizon,
  spellCardChip(spell.range),
  spellCardDivider,
  spellCardChip(spell.duration),
)

#let spellCardFront(spell) = spellCardLayout(
  vstack(
    spacing: (paddings(1.5), paddings(1.5), paddings(1.5), paddings(2)),
    spellCardResources(spell),
    spellCardTitle(spell.name),
    spellCardSectionDivider,
    spellCardTarget(spell),
    block(width: 100%)[
      #set align(left)
      #par(justify: true, spell.body)
    ]
  )
)

#let _tightenDescription(s) = s.replace(
  regex("([^.!?:\n])\n+"),
  m => m.captures.at(0) + " ",
)

#let _renderDescription(s) = par(
  justify: true,
  spellCardDescription(_tightenDescription(s)),
)

#let _fitDescription(rawText) = layout(size => context {
  let full = _renderDescription(rawText)
  if measure(box(width: size.width, full)).height <= size.height {
    return align(left, full)
  }

  let clusters = rawText.clusters()
  let n = clusters.len()
  let lo = 0
  let hi = n
  while lo < hi {
    let mid = calc.div-euclid(lo + hi + 1, 2)
    let candidate = _renderDescription(
      clusters.slice(0, mid).join("") + "…"
    )
    let fits = measure(box(width: size.width, candidate)).height <= size.height
    if fits { lo = mid } else { hi = mid - 1 }
  }

  let i = lo
  while i > 0 and clusters.at(i - 1) != " " and clusters.at(i - 1) != "\n" {
    i = i - 1
  }
  let prefix = clusters.slice(0, i).join("").trim()
  align(left, _renderDescription(prefix + "…"))
})

#let spellCardBack(spell) = {
  let original = spell.at("originalName", default: none)
  let title = if original != none and original != spell.name [
    *#spell.name* #text(size: 0.8em)[(#original)]
  ] else [
    *#spell.name*
  ]
  spellCardLayout(block(width: 100%, height: 100%, grid(
    columns: 1fr,
    rows: (auto, 1fr, auto),
    row-gutter: paddings(1.5),
    align(left, spellCardDescriptionTitle(title)),
    _fitDescription(spell.description),
    align(right, spellCaption(spell.school)),
  )))
}

#let spellCard(spell) = (
  front: spellCardFront(spell),
  back: spellCardBack(spell)
)
