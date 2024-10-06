#import "../core/core.typ": *

#let quests = {
  let headerCell(colspan: 1, body) = grid.cell(
    colspan: colspan,
    align: left,
    tableHeader(body)
  )
  let emptyCell = grid.cell([])

  let questFrame(fromLines: 2, goalLines: 5, rewardLines: 1) = [
    #framed(
      fitting: expand-h,
      insets: (top: paddings(1), bottom: 0pt, rest: paddings(2))
    )[
      #grid(
        columns: (1fr),
        rows: paddings(2),
        stroke: innerRowStrokes(),
        headerCell[Goal:], emptyCell,
        ..((emptyCell,) * goalLines),
        headerCell[From:],
        ..((emptyCell,) * fromLines),
        headerCell[Reward:], emptyCell,
        ..((emptyCell,) * rewardLines)
      )
    ]

    #place(
      top + right,
      dx: paddings(1),
      dy: -paddings(0.5),
      rhombus(
        width: paddings(4),
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
      ..((questFrame(),) * 6),
    )
  ]
}
