#import "../core/core.typ": *

#let proficiencies(..proficiencies) = page(
  header: section[Tools Proficiencies]
)[

  #columned(withSeparator: false)[
    #let proficiencyBlock(proficiency) = [
      #set text(hyphenate: false)
      #set text(top-edge: 0.5em)

      #abilityHeader(proficiency.title)\
      #if proficiency.source != none [
        #abilitySource(proficiency.source)
      ]
      #par[
        #for item in proficiency.items [
          - #item,\
        ]
      ]
      #for action in proficiency.actions [
        #grid(
          columns: (1fr, 1fr),
          abilitySubtitle(action.name),
          if action.dc != none [
            DC #action.dc
          ]
        )
        #par(first-line-indent: 1.5em)[
          #action.body
        ]
      ]

      #for skillEffect in proficiency.skillsEffects [
        #par(first-line-indent: 1.5em)[
          *#skillEffect.skills.pos().join(", ")*:
          #skillEffect.body
        ]
      ]
    ]

    #for proficiency in proficiencies.pos() {
      if type(proficiency) == "content" {
        proficiency
      } else if type(proficiency) == "dictionary" {
        [ #proficiencyBlock(proficiency) ]
      } else {
        panic("Not supported proficiency type " + type(proficiency))
      }
    }
  ]
]
