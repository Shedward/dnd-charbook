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

#let abilities(title: [Abilities], ..abilities) = page(
  header: section(title)
)[
  #columned(withSeparator: false)[
    #for ability in abilities.pos() {
      if type(ability) == "content" {
        ability
      } else if type(ability) == "dictionary" {
        [ #abilityParagraph(ability)\ ]
      } else {
        panic("Not supported ability type")
      }
    }
  ]
]
