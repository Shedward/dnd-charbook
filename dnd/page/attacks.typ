#import "../core/core.typ": *

#let attacks = {
  let headerCell(colspan: 1, body) = grid.cell(
    colspan: colspan,
    tableHeader(body)
  )
  let emptyCell(colspan: 1) = grid.cell(colspan: colspan, [])
  let vline(row) = grid.vline(stroke: strokes.hairline, start: row, end: row + 1)
  let hline = grid.hline(stroke: strokes.hairline)

  let attackFrame(lines: 4) = framed(
    fitting: expand-h,
    insets: (bottom: 0pt, rest: paddings(1))
  )[
    #grid(
      columns: (1fr, 1fr, 1fr),
      rows: paddings(2),
      stroke: none,
      headerCell(colspan: 2, loc(en: [Name], ru: [Название])), headerCell(loc(en: [Damage], ru: [Урон])),
      emptyCell(colspan: 2), vline(1), emptyCell(),
      grid.hline(stroke: (thickness: strokes.hairline, dash: "dashed")),
      emptyCell(colspan: 2), vline(2), emptyCell(),

      headerCell(loc(en: [Range], ru: [Дальность])), headerCell(loc(en: [Atk. bonus], ru: [Бонус атак.])), headerCell(loc(en: [Type], ru: [Тип])),
      emptyCell(), vline(4), emptyCell(), vline(4), emptyCell(),
      ..((hline, emptyCell(colspan: 3)) * lines),
    )
  ]

  page(
    header: section(loc(en: [Attacks], ru: [Атаки]))
  )[
    #grid(
      columns: (1fr, 1fr),
      rows: 1fr,
      stroke: none,
      gutter: paddings(2),
      ..((attackFrame(),) * 8),
    )
  ]
}
