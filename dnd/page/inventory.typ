#import "../core/core.typ": *

#let inventoryTable(
  header: (),
  columns: auto,
  rowsCount: auto,
) = {
  layout(size => {
    let columnsCount = header.len()
    let rowHeight = paddings(2.5)
    let gridColumns = if (columns == auto) {
      (1fr,) * columnsCount
    } else {
      columns
    }

    let emptyRow = (none,) * columnsCount

    let actualRowsCount = if (rowsCount == auto) {
      calc.trunc(size.height / rowHeight)
    } else {
      rowsCount
    }

    grid(
      columns: gridColumns,
      rows: rowHeight,
      column-gutter: paddings(1),
      inset: paddings(0.5),
      align: left,
      stroke: innerRowStrokes(),
      ..header.map(tableHeader),
      grid.hline(end: columnsCount, stroke: strokes.thin),
      ..(emptyRow * actualRowsCount),
    )
  })
}

#let inventoryDoubleColumnGrid(..content) = framed(fitting: expand, insets: 0pt)[
  #grid(
    columns: (1fr, 1fr),
    inset: paddings(2),
    stroke: innerColumnStrokes(),
    ..content
  )
]

#let magicItemsTable = inventoryTable(
  header: (loc(en: [Atn], ru: [Нас.]), loc(en: [Magic Item], ru: [Маг. предметы]), loc(en: [Val], ru: [Цен.])),
  columns: (paddings(2.5), 1fr, paddings(3))
)

#let itemsTable = inventoryTable(
  header: (loc(en: [E], ru: [Эк]), loc(en: [Item], ru: [Предмет]), loc(en: [C.], ru: [Кол.]), loc(en: [W.], ru: [Вес])),
  columns: (paddings(2.5), 1fr, paddings(3), paddings(3))
)

#let moneyInput = framed(
  fitting: expand-h,
  insets: (x: paddings(2), y: paddings(1)),
  {
    let coins = (
      loc(en: "PP", ru: "пм"),
      loc(en: "GP", ru: "зм"),
      loc(en: "SP", ru: "см"),
      loc(en: "CP", ru: "мм")
    )

    grid(
      columns: (20mm, 1fr, 20mm, 20mm),
      rows: (4mm, auto),
      gutter: paddings(2),
      inset: (bottom: 0pt, rest: paddings(1)),
      stroke: innerRowStrokes(),
      ..((none,) * coins.len()),
      ..(coins.map(propCap))
    )
  }
)

#let inventory = [
  #page(
    header: section(loc(en: [Inventory], ru: [Интентарь]))
  )[
    #inventoryDoubleColumnGrid(
      magicItemsTable,
      itemsTable
    )
  ]

  #page[
    #grid(
      rows: (1fr, auto, auto),
      gutter: paddings(2),
      inventoryDoubleColumnGrid(
        itemsTable,
        itemsTable
      ),
      subsection(loc(en: [Money], ru: [Деньги])),
      moneyInput
    )
  ]
]
