#import "../core/core.typ": *

#let abilities(title: loc(en: [Abilities], ru: [Умения]), ..abilities) = page(
  header: section(title)
)[
  #let abilityBlock(ability) = [
    #set text(hyphenate: false)
    #set text(top-edge: 0.5em)

    #abilityHeader(ability.title)\
    #if ability.source != none [
      #abilitySource(ability.source)
    ]

    #ability.body
  ]

  #columned(separator: false)[
    #for ability in abilities.pos() {
      if type(ability) == content {
        ability
      } else if type(ability) == dictionary {
        [ #abilityBlock(ability)\ ]
      } else {
        panic("Not supported ability type " + type(ability))
      }
    }
  ]
]
