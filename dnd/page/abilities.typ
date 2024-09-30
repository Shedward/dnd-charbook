#import "../core/core.typ": *

#let abilityParagraph(ability) = [
  #set text(hyphenate: false)
  #set text(top-edge: 0.5em)

  #abilityHeader(ability.title)\
  #if ability.source != none [
    #abilitySource(ability.source)
  ]
  #par(
    first-line-indent: 1.5em
  )[
    #ability.body
  ]
]

#let abilities(..abilities) = page(
  header: section[Abilities]
)[
  #columned(withSeparator: false)[
    #for ability in abilities.pos() [
      #abilityParagraph(ability)\
    ]
  ]
]
