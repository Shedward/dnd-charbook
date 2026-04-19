#import "../dnd/dnd.typ"
#import "../dnd/builder/builder.typ": *

#dnd.core.setLocale("ru")

#let char = build(
  introduce(
    name: "Test",
    class: "Wizard",
    level: 5,
    stats: (STR: 10, DEX: 10, CON: 10, INT: 16, WIS: 10, CHA: 10),
    spellcasting: spellcasting(stat: INT),
  ),
  addSpellById("fire-bolt"),
  addSpellById("light"),
  addSpellById("mage-hand"),
  addSpellById("magic-missile"),
  addSpellById("shield"),
  addSpellById("scorching-ray"),
  addSpellById("mirror-image"),
  addSpellById("fireball"),
  addSpellById("counterspell"),
)

#deckOfSpells(char)
