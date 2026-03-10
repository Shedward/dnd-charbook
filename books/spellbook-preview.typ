#import "../dnd/dnd.typ"
#import "../dnd/game/game.typ": *

#show: dnd.core.charbook
#setLocale("ru")

#let testChar = dnd.game.character(
  level: 5,
  name: "Тест",
  class: "Тест",
  stats: (STR: 10, DEX: 14, CON: 12, INT: 10, WIS: 10, CHA: 18),
  spellcasting: spellcasting(stat: CHA, slots: none),
  profBonus: 3,
)
#setCharacter(testChar)

// Show only the current batch (count passed via --input count=N, default 5)
#let count = int(sys.inputs.at("count", default: "5"))
#let sb = dnd.data.spellbook()
#let batch = sb.slice(sb.len() - count)

= Предпросмотр партии

#dnd.page.spellsSection(..batch.map(dnd.page.spellFromSpellbook))
