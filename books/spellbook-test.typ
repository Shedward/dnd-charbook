#import "../dnd/dnd.typ"
#import "../dnd/game/game.typ": *

#show: dnd.core.charbook
#setLocale("ru")

// Minimal character: CHA caster, level 5, so MOD and cantrip scaling work
#let testChar = dnd.game.character(
  level: 5,
  name: "Тест",
  class: "Тест",
  stats: (STR: 10, DEX: 14, CON: 12, INT: 10, WIS: 10, CHA: 18),
  spellcasting: spellcasting(stat: CHA, slots: none),
  profBonus: 3,
)
#setCharacter(testChar)

= Тест Заклинаний

#dnd.page.spellsSection(..dnd.data.spellbook().map(dnd.page.spellFromSpellbook))
