#import "../core/core.typ": *

#let spellCardFront(spell) = [
  #spell.name \n #spell.at("body", default: [])
]

#let spellCardBack(spell) = [ ]

#let spellCard(spell) = (
  front: spellCardFront(spell),
  back: spellCardBack(spell)
)
