#import "../core/core.typ": *

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
          grid.hline(stroke: (thickness: strokes.normal)),
          pad(y: paddings(1), charStat(c))
        )
      ]
    ])
  )
]

#let propsSeparator = line(stroke: strokes.thin)

#let props() = framed(fitting: expand)[
  #grid(columns: 100%, row-gutter: paddings(1),
    propBox[Initiative],
    propBox[AC],
    propsSeparator,
    propBox[Max],
    propBox[Cur.],
    propBox[Temp.],
    propsSeparator,
    propBox[Prof.Bonus],
    propBox[Movement],
    box(height: 100%)[
      #circle()
    ]
  )
]

#let charlist(
  character
) = page[
  #grid(
    columns: (20mm, 1fr, 20mm),
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
    stats(), frame(), props()
  )
]
