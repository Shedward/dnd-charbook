#import "../core/core.typ": *
#import "../game/game.typ": *

#let spellRow(spell) = (
  table.cell(rowspan: 2, align: top + center)[#spell.prep],
  table.cell(rowspan: 2, align: top + left)[
    #spell.name\
    #spellCaption(spell.school)
  ],
  table.cell(align: left)[#spell.castTime],
  spell.duration,
  spell.range,
  spell.components.components,
  table.cell(align: right)[
    #if (spell.castType == none) [-] else [#spell.castType]
  ],
  table.cell(colspan: 3, par(justify: true, spell.body))
)

#let spellsTable(..spells) = {
  show: spellBody
  set text(hyphenate: false)

  table(
    columns: (9mm, 25mm, 8mm, 1fr, 1fr, 1fr),
    align: top + left,
    stroke: (x, y) => (
      top: if (y > 0 and calc.rem(y, 2) == 1) { strokes.hairline } else { 0pt },
      bottom: none
    ),
    inset: paddings(0.75),

    table.cell(align: center, tableHeader[Pr.]),
    tableHeader[Name],
    table.cell(align: center, tableHeader[Time]),
    tableHeader[Dur],
    tableHeader[Range],
    tableHeader[Comp.],

    ..(spells.pos().map(spellRow).flatten()),
  )
}

#let spellsSection(level: none, ..spells) = {
  let levelRow = if level == none {()} else {
    (
      level.name,
      level.slots
    )
  }
  framed(fitting: expand-h)[
    #grid(
      columns: 2,
      align: (left, right),
      inset: paddings(1),
      ..levelRow,
      grid.cell(colspan: 2, spellsTable(..spells))
    )
  ]
}
