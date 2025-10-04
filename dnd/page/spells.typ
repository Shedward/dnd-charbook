#import "../core/core.typ": *
#import "../game/game.typ": *
#import "../data/data.typ": *

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
      #propCap(content.at("caption", default: none))
    ]

    #place(horizon + center, dy: 0.5 * dy)[
      #propBody(content.at("content", default: none))
    ]

    #place(top + center, dy: -dy)[
      #propCap(content.at("topCaption", default: none))
    ]
  ]
}

#let spellSlotsSection(character, additional: (:)) = {
  if character.spellcasting != none and character.spellcasting.slots != none {
    let slots = method(character, c => c.spellcasting.slots)

    framed(fitting: expand-h)[
      #propCap(loc(en: [Slots], ru: [Ячейки]))
      #hstack(
        size: (auto,),
        align: horizon,
        gutter: paddings(2),
        ..(slots.keys()
            .map(
              level => vstack(
                gutter: paddings(0.5),

                spellSlots(slots.at(level)),
                [ *#propCap(roman(int(level)))* ]
              )
            )
        ),
        ..(additional.keys()
            .map(
              key => vstack(
                gutter: paddings(0.5),

                spellSlots(additional.at(key)),
                [ *#propCap(key)* ]
              )
            )
        ),
      )
    ]
  }
}

#let spellcasting(character) = {
  let propBox = (
  (
    (
      content: statModifier(character, spellcastingStat(character)),
      caption: [#loc(en: [Ability], ru: [Навык]) - #statName(spellcastingStat(character))]
    ),
    (
      content: spellAtkBonus(character),
      caption: loc(en: [Atk Bonus], ru: [Атк. Бонус])
    ),
    (
      content: spellDC(character),
      caption: loc(en: [Save DC], ru: [Спас. слож.])
    )
  )
  + character.spellcasting.props.map(p => {
    (
      content: method(character, c => p.content),
      caption: method(character, c => p.caption)
    )
  })
  ).filter(v => v != none)

  framed(fitting: expand-h)[
    #vstack(
      row-gutter: paddings(1),
      skipNone: true,
      grid(
        columns: (1fr, 1fr, 1fr),
        inset: 0.25em,
        character.class,
        grid.hline(stroke: strokes.thin),
        character.spellcasting.focus,
        grid.cell(rowspan: 2)[
          #if character.spellcasting.ritualCasting [
            #loc(en: "Ritual Casting", ru: "Ритуальн. Закл.")
          ]
        ],
        propCap(loc(en: [Class], ru: [Класс])), propCap(loc(en: [Focus], ru: [Фокус]))
      ),
      grid(
        columns: (1fr,) * propBox.len(),
        column-gutter: paddings(1),
        ..(propBox.map(spellPropBox))
      )
    )
  ]
}

#let spellsTable(..spells) = {
  show: spellBody
  set text(hyphenate: false)

  table(
    columns: (9mm, 20mm, 8mm, 1fr, 1fr, 1fr),
    align: top + left,
    stroke: (x, y) => (
      top: if (y > 0 and calc.rem(y, 2) == 1) { strokes.hairline } else { 0pt },
      bottom: none
    ),
    inset: paddings(0.75),

    table.cell(align: center, tableHeader(loc(en: [Pr.], ru: [Подг]))),
    tableHeader(loc(en: [Name], ru: [Название])),
    table.cell(align: center, tableHeader(loc(en: [Time], ru: [Время]))),
    tableHeader(loc(en: [Dur], ru: [Длит.])),
    tableHeader(loc(en: [Range], ru: [Даль.])),
    tableHeader(loc(en: [Comp.], ru: [Компон.])),

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

// Spellbook formatters

#let castingTimeFromSpellbook(m) = {
  let withValueIfNeeded = (label) => {
    if m.value > 1 {
      [ #m.value #label ]
    } else {
      label
    }
  }
  if m.type == "action" {
    withValueIfNeeded(action)
  } else if m.type == "bonus_action" {
    withValueIfNeeded(bonusAction)
  } else if m.type == "reaction" {
    withValueIfNeeded(reaction)
  } else if m.type == "minute" {
    minute(m.value)
  } else if m.type == "hour" {
    hour(m.value)
  } else {
    withValueIfNeeded(m.value)
  }
}

#let castTypeFromSpellbook(m) = {
  let castType = ()

  if m.is_ritual {
    castType.push(ritual)
  }

  if m.with_concentration {
    castType.push(concentration)
  }

  castType.join()
}

#let durationFromSpellbook(m) = {
  if "duration" not in m {
    none
  } else if m.duration == 0 {
    instant
  } else if m.duration < 60 {
    round(m.duration / 6)
  } else if m.duration < 3600 {
    minute(m.duration / 60)
  } else if m.duration < 86400 {
    hour(m.duration / 3600)
  } else {
    day(m.duration / 86400)
  }
}

#let targetFromSpellbook(s) = {
  if s.target == none {
    none
  } else {
    eval(
      s.target,
      scope: (
        self: self,
        touch: touch,
        target: target,
        point: point,
        circle: circle,
        square: square,
        cube: cube,
        sphere: sphere,
        straightLine: straightLine,
        cone: cone,
        sight: sight
      )
    )
  }
}

#let componentsFromSpellbook(s) = {
  s.components.components.join()
}

#let requiredComponentsFromSpellbook(s) = {
  let isRequired = false
  let isConsumed = false

  if s.components.material_required == true {
    isRequired = true
  }
  if s.components.material_consumed == true {
    isConsumed = true
  }

  if isRequired or isConsumed {
    [ *
      #loc(en: " Requires ", ru: " Требует ")
      #s.components.material
      #if isConsumed {
        loc(en: " (consumed)", ru: " (расходуется)")
      }
      *
    ]
  }
}

#let spellFromSpellbook(s, ..etc) = spell(
  s.name,
  castTime: castingTimeFromSpellbook(s.casting_time),
  castType: castTypeFromSpellbook(s),
  duration: durationFromSpellbook(s),
  range: targetFromSpellbook(s),
  components: componentsFromSpellbook(s),
  ..etc,
)[
  #s.short_description\
  #requiredComponentsFromSpellbook(s)
]

#let allSpellsFromSpellbook(class, subclass, lvl) = {
  for lvl in range(lvl) [
    #subsection[#lvl #loc(en: "Level", ru: "Уровень")]
    #spellsTable(
      ..(
        spellbook().filter(
          is_spell_for_class.with(class: class, subclass: subclass)
        ).filter(
          is_spell_at_level.with(level: lvl)
        ).map(
          s => spellFromSpellbook(s, prep: preparing)
        )
      )
    )
  ]
}
