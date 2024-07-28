#import "../core/core.typ": *

#let stats(
  names: ("STR", "DEX", "CON", "INT", "WIS", "CHA")
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

#let charlist(
  character
) = page[
  #grid(
    columns: (20mm, 1fr, 25mm),
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
          [ #character.race, #character.type ], character.story
        )
        #line(length: 100%, stroke: strokes.thin)
    ],
    grid.cell[ Hello ],
    stats(), frame(), frame()
  )
]
