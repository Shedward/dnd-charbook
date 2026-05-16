#import "../dnd/dnd.typ"
#import "../dnd/builder/builder.typ": *

#dnd.core.setLocale("ru")

#let char = build(
  introduce(
    name: "Test",
    class: "Cleric",
    level: 20,
    stats: (STR: 10, DEX: 10, CON: 10, INT: 10, WIS: 16, CHA: 10),
    spellcasting: spellcasting(stat: WIS),
  ),
  addClassSpells("жрец", cantrip),
  addClassSpells("жрец", 1),
  addClassSpells("жрец", 2),
  addClassSpells("жрец", 3),
  addClassSpells("жрец", 4),
  addClassSpells("жрец", 5),
  addClassSpells("жрец", 6),
  addClassSpells("жрец", 7),
  addClassSpells("жрец", 8),
  addClassSpells("жрец", 9),
)

#deckOfSpells(char)
