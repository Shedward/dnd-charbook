#import "../core/core.typ": *
#import "names.typ": statName, skillName
#import "../game/game.typ"

#let statDescription(character, stat) = {
  vstack(
    pad(top: 0.5em)[
      #propBody(game.statModifier(character, stat))
    ],
    pad(top: 1em)[
      #game.statValue(character, stat)
    ]
  )
}

#let saveDescription(character, stat) = {
  skillBody(saveModifier(character, stat))
}

#let statsGrid(
  character,
  names: game.stats
) = framed(fitting: expand)[
  #grid(
    columns: 100%,
    gutter: paddings(1),
    rows: 1fr,
    ..names.map(c => [
      #framed(fitting: expand, insets: 0pt, stroke: strokes.normal)[
        #grid(
          columns: 100%,
          rows: (1fr, auto),
          statDescription(character, c),
          grid.hline(stroke: strokes.normal),
          pad(y: paddings(1), charStat(statName(c)))
        )
      ]
    ])
  )
]

#let savingRolls() = table(
  columns: (1fr, 10mm, 1fr, 10mm),
  stroke: innerRowStrokes(),
  // ---
  ..(for stat in game.stats {
    (none, statCaption(statName(stat)))
  })
)

#let deathSavesCheckboxes(caption) = grid.cell(colspan: 2)[
  #propCap(caption)
  #box[
    #rect(width: 12mm, height: 1mm)
    #place(center + horizon)[
      #checkboxes(3, size: 2.5mm, padding: 100%, shape: circle.with(fill: white))
    ]
  ]
]

#let deathSaves() = grid(
  columns: (auto, auto),
  rows: (auto, auto),
  gutter: paddings(1),
  // ---
  propCap(loc(en: [Destiny P.], ru: [Оч. судьб.])), propCap(loc(en: [Ins], ru: [Вдох.])),
  checkboxes(3), checkboxes(1),
  deathSavesCheckboxes(loc(en: [Sc.], ru: [Успех])),
  deathSavesCheckboxes(loc(en: [Fl.], ru: [Пров.]))
)

#let rollsCaption(caption: none, body) = figure(
  caption: propCap(caption),
  supplement: none,
  numbering: none,
  body
)

#let saves() = grid(
  columns: (1fr, auto, auto),
  gutter: paddings(0.5),
  inset: paddings(0.5),
  // ---
  rollsCaption(caption: loc(en: [Saving roll], ru: [Спасброски]))[
    #savingRolls()
  ],
  line(length: 100%, angle: 90deg, stroke: strokes.hairline),
  rollsCaption(caption: loc(en: [Death saves], ru: [Проверки на смерть]))[
    #deathSaves()
  ]
)

#let skillsGrid() = grid(
  columns: 100%,
  rows: (auto, 1fr),
  row-gutter: paddings(1),
  // ---
  framed(fitting: expand-h)[
    #saves()
  ],
  framed(fitting: expand, insets: (x: paddings(2), y: 0pt))[
    #table(
      columns: (18mm, 1fr, 10mm),
      rows: 1fr,
      stroke: innerRowStrokes(),
      align: (auto, left, center),
      // ---
      ..(for skill in game.skills {
        (
          none,
          skillName(skill.skill),
          statCaption(fill: colors.secondary, statName(skill.stat))
        )
      })
    )
  ]
)

#let propsSeparator = line(stroke: strokes.thin, length: 100% + paddings(2), angle: 0deg)

#let healthPropBox = propBox.with(shape: heart, dy: -0.25em)

#let propsGrid(character) = framed(fitting: expand)[
  #grid(
    columns: 100%,
    rows: (auto, auto, 1fr, auto, auto, auto, 1fr, auto),
    row-gutter: paddings(1),
    // ---
    propBox(loc(en: [Initiative], ru: [Иниц.])),
    propBox(shape: shield, dy: -0.25em, loc(en: [AC], ru: [КБ])),
    propsSeparator,
    healthPropBox(loc(en: [Max], ru: [Макс]), content: method(character, c => c.maxHp)),
    badge(
      width: 60%,
      height: 4mm
    )[
      #healthPropBox(loc(en: [Cur.], ru: [Тек.]))
    ],
    healthPropBox(loc(en: [Temp.], ru: [Врем.])),
    propsSeparator,
    propBox(loc(en: [Prf.Bonus], ru: [Бон. маст.])),
    propBox(loc(en: [Movement], ru: [Скорость]))
  )
]

#let charlist(
  character
) = page[
  #grid(
    columns: (20mm, 1fr, 21mm),
    rows: (auto, 1fr),
    gutter: paddings(1),
    // ---
    grid.cell(colspan: 2)[
      #characterName(character.name)
        #table(
          columns: (1fr, 1fr),
          align: (left, right),
          inset: 2pt,
          stroke: none,
          [ #character.class, #character.subclass ], character.alignment,
          [ #character.race, #character.type ], character.story,
        )
    ],
    grid.cell[
      #pad(paddings(1))[
        #propBox(content: character.level, loc(en: [Level], ru: [Уровень]))
      ]
    ],
    statsGrid(character), skillsGrid(), propsGrid(character)
  )
]
