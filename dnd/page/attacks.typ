#import "../core/core.typ": *

#let attacks = [
  #show: columned

  #let headerCell(colspan: 1, body) = table.cell(colspan: colspan, tableHeader(body))
  #let emptyCell(colspan: 1) = table.cell(colspan: colspan, [])
  #let vline(row) = table.vline(stroke: strokes.thin, start: row, end: row + 1)
  #let hline = table.hline(stroke: strokes.thin)

  #let attackFrame = framed(fitting: "expand-h")[
    #table(
      columns: (1fr, 1fr, 1fr),
      stroke: none,
      headerCell(colspan: 2)[Name], headerCell[Damage],
      emptyCell(colspan: 2), vline(1), emptyCell(),
      hline,
      emptyCell(colspan: 2), vline(2), emptyCell(),

      headerCell[Range], headerCell[Atk. bonus], headerCell[Type],
      emptyCell(), vline(4), emptyCell(), vline(4), emptyCell(),
      hline,
      emptyCell(colspan: 3),
      hline,
      emptyCell(colspan: 3)
    )
  ]

  #repeat[#attackFrame]
]
