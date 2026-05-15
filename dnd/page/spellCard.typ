#import "../core/core.typ": *
#import "../core/layout.typ": *

#let spellCardLayout(body) = pad(
  paddings(2),
  framed(fitting: expand, insets: paddings(2), alignment: center + top, body)
)

#let spellCardResources(spell) = [
  Mat, 1 Ac, 5 lvl, Con, Rit
]

#let spellCardTarget(spell) = [
  120ft cube, 10 min
]

#let spellCard

#let spellCardFront(spell) = spellCardLayout(
  vstack(
    spacing: paddings(2),
    spellCardResources(spell),
    spellCardTitle(spell.name),
    spellCardTarget(spell.name),
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
