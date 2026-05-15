#import "../core/core.typ": *
#import "../core/layout.typ": *

#let spellCardLayout(body) = pad(
  paddings(2),
  framed(
    fitting: expand,
    insets: paddings(2),
    alignment: center + top,
    stroke: strokes.thin + colors.secondary,
    body,
  )
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

#let spellCardSectionDivider = line(
  length: 100%,
  stroke: strokes.thin + colors.secondary,
)

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

#let spellCardResources(spell) = grid(
  columns: (1fr, auto, 1fr, auto, 2fr),
  align: center + horizon,
  spellCardChip(spell.components),
  spellCardDivider,
  spellCardChip(spell.castTime),
  spellCardLevelBadge(spell.at("level", default: none)),
  spellCardChip(spell.castType, alignment: left + horizon),
)

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

#let spellCardBack(spell) = spellCardLayout(
  vstack(
    spacing: paddings(2),
    spellCardDescriptionTitle(spell.name),
    block(width: 100%, clip: true)[
      #set align(left)
      #par(justify: true, spellCardDescription(spell.description))
    ]
  )
)

#let spellCard(spell) = (
  front: spellCardFront(spell),
  back: spellCardBack(spell)
)
