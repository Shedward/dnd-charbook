#import "../core/core.typ": *

#let proficiencies(..proficiencies) = page(
  header: section[Tools Proficiencies]
)[

  #columned(withSeparator: false)[
    #let proficiencyBlock(proficiency) = [
      #todo("Implement")
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
