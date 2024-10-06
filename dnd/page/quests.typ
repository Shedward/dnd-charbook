#import "../core/core.typ": *

#let quests = {
  let headerCell(colspan: 1, body) = grid.cell(
    colspan: colspan,
    align: left,
    tableHeader(body)
  )
  let emptyCell(colspan: 1) = grid.cell(colspan: colspan, [])
  let spacerCell(colspan: 2) = grid.cell(colspan: colspan, [], stroke: none)

  let questFrame(topLines: 3, bottomLines: 4) = [
    #framed(
      fitting: expand-h,
      insets: (bottom: 0pt, rest: paddings(2))
    )[
      #grid(
        columns: (1fr, 1fr),
        rows: paddings(2),
        column-gutter: paddings(1),
        stroke: innerRowStrokes(),
        headerCell[From:], headerCell[Reward:],
        ..((emptyCell(),) * 2 * topLines),
        headerCell[Goal:], emptyCell(),
        ..((emptyCell(colspan: 2),) * bottomLines)
      )
    ]

    #place(
      top + right,
      dx: paddings(1),
      dy: -paddings(1),
      rhombus(
        width: paddings(3),
        stroke: strokes.normal,
        fill: white
      ),
    )
  ]

  page(
    header: section[Quests]
  )[
    #grid(
      columns: (1fr, 1fr),
      rows: 1fr,
      stroke: none,
      gutter: paddings(2),
      ..((questFrame(),) * 8),
    )
  ]
}
