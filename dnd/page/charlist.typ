#import "../core/core.typ": *
#import "../core/data.typ"

#let stats(
  names: stats
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
          [],
          grid.hline(stroke: strokes.normal),
          pad(y: paddings(1), charStat(c))
        )
      ]
    ])
  )
]

#let savings() = grid(
  columns: (1fr, auto),
  column-gutter: paddings(1),
  // ---
  [Saving rolls],
  grid.vline(stroke: strokes.hairline),
  square()
)

#let skills() = grid(
  columns: 100%,
  rows: (auto, 1fr),
  row-gutter: paddings(1),
  // ---
  framed(fitting: expand-h)[
    #savings()
  ],
  framed(fitting: expand, insets: (x: paddings(2), y: 0pt))[
    #table(
      columns: (18mm, 1fr, 10mm),
      rows: 1fr,
      stroke: (x: none, y: strokes.hairline),
      align: (auto, left, center),
      // ---
      ..(for skill in data.skills {
        (
          none,
          skill.name,
          caption(skill.stat)
        )
      })
    )
  ]
)

#let propsSeparator = line(stroke: strokes.thin, length: 100% + paddings(2), angle: 0deg)

#let healthPropBox = propBox.with(shape: heart, dy: -0.25em)

#let props() = framed(fitting: expand)[
  #grid(
    columns: 100%,
    rows: (auto, auto, 1fr, auto, auto, auto, 1fr, auto),
    row-gutter: paddings(1),
    // ---
    propBox[Initiative],
    healthPropBox[AC],
    propsSeparator,
    healthPropBox[Max],
    healthPropBox[Cur.],
    healthPropBox[Temp.],
    propsSeparator,
    propBox[Prf.Bonus],
    propBox[Movement]
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
        #propBox[Level]
      ]
    ],
    stats(), skills(), props()
  )
]
