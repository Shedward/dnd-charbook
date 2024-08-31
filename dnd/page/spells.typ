#import "../core/core.typ": *
#import "../game/game.typ": *

#let spellRow(spell) = (
  table.cell(rowspan: 2, align: horizon + center)[#spell.prep],
  table.cell(rowspan: 2, align: horizon + left)[
    #par(justify: false)[
      #spell.name\
      #spellCaption(spell.school)
    ]
  ],
  table.cell(align: left)[#spell.castTime],
  spell.duration,
  spell.range,
  spell.components,
  table.cell(align: right, inset: (top: paddings(0.25)))[
    #if (spell.castType == none) [-] else [#spell.castType]
  ],
  table.cell(colspan: 3, inset: (top: paddings(0.25)), par(spell.body))
)

#let spellPropBox(content, dy: -0.5em) = {
  box(height: 15mm)[
    #framed(fitting: expand)[]
    #place(bottom + center, dy: dy)[
      #propCap(content)
    ]
  ]
}

#let spellcasting(character) = {
  framed(fitting: expand-h)[
  #grid(
    row-gutter: paddings(1),
    grid(
      columns: (1fr, 1fr, 1fr),
      inset: 0.25em,
      character.class,
      grid.hline(stroke: strokes.thin),
      [Tools, Infusions],
      grid.cell(rowspan: 2)[Ritual Casting],
      propCap[Class], propCap[Focus]
    ),
    grid(
      columns: (1fr, 1fr, 1fr, 1fr),
      column-gutter: paddings(1),
      spellPropBox[Ability], spellPropBox[Atk Bonus], spellPropBox[Save DC], spellPropBox[Max Prep.]
    )
  )]
}

#let spellsTable(..spells) = {
  show: spellBody
  set text(hyphenate: false)

  table(
    columns: (9mm, 23mm, 8mm, 1fr, 1fr, 1fr),
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

#let spellsSection(
  level: none,
  bottom: none,
  ..spells
) = {
  let levelRow = if level == none {()} else {
    (
      grid(
        columns: (1fr, 1fr),
        align: (left, right),
        level.name,
        level.slots
      ),
    )
  }
  framed(fitting: expand-h, insets: (x: paddings(1), y: paddings(0.5)))[
    #grid(
      columns: 1,
      inset: paddings(1),
      ..levelRow,
      spellsTable(..spells)
    )
  ]
}
