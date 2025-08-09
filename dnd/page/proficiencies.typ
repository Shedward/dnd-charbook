#import "../core/core.typ": *
#import "../game/proficiencies.typ": *

#let proficiencies(..proficiencies) = page(
  header: section(loc(en: [Proficiencies], ru: [Компетенции]))
)[

  #columned(separator: false)[
    #let proficiencyBlockStyle(body) = {
      set text(hyphenate: false)
      set text(top-edge: 0.5em)

      body
    }

    #let toolProficiencyBlock(proficiency) = [
      #show: proficiencyBlockStyle

      #abilityHeader(proficiency.title)\
      #if proficiency.source != none [
        #abilitySource(proficiency.source)
      ]

      #for item in proficiency.items [
        - #item\
      ]

      #for action in proficiency.actions [
        #par[
          #table(
            stroke: none,
            inset: 0pt,
            gutter: 0.75em,
            columns: (1fr, auto),
            [*#actionName(action.name)*],
            mapOrNone(
              action.dc,
              v => actionName[dc #v]
            ),
            ..arrayOrNone(action.body).map(v => table.cell(colspan: 2, v))
          )
        ]
      ]

      #for skillEffect in proficiency.skillsEffects [
        #par[
            *#skillEffect.skills.pos().join(", ")*:
            #skillEffect.body\
        ]
      ]
    ]

    #let simpleProficiencyBlock(proficiency) = [
      #show: proficiencyBlockStyle

      #simpleProficiencyTitle(proficiency.title)\
      #if proficiency.source != none [
        #abilitySource(proficiency.source)
      ]
    ]

    #for proficiency in proficiencies.pos() {
      if type(proficiency) == content {
        proficiency
      } else if type(proficiency) == dictionary {
        [
          #if proficiency.class == tool {
            toolProficiencyBlock(proficiency)
          } else {
            simpleProficiencyBlock(proficiency)
          }\
        ]
      } else {
        panic("Not supported proficiency type " + type(proficiency))
      }
    }
  ]
]
