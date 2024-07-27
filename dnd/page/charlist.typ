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
          pad(y: paddings(1), c)
        )
      ]
    ])
  )
]

#let charlist = page[
  #grid(
    columns: (20mm, 1fr, 25mm),
    rows: 100%,
    gutter: paddings(1),
    // ---
    stats(), frame(), frame()
  )
]
