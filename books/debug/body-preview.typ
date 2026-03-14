#import "../../dnd/dnd.typ"
#import "../../dnd/game/game.typ": *
#import "../../dnd/page/spells.typ": spellBodyDSLScope

#setLocale("ru")

// Minimal character context so DSL functions that reference MOD/PROF/LVL work
#let previewChar = character(
  name: "Preview",
  level: 10,
  stats: (STR: 10, DEX: 10, CON: 10, INT: 10, WIS: 10, CHA: 20),
  spellcasting: spellcasting(stat: CHA, slots: none),
)
#setCharacter(previewChar)

#set page(width: 120mm, height: auto, margin: 4mm)
#set text(size: 8pt, lang: "ru")

#let body = sys.inputs.at("body", default: "(no body)")
#eval(body, scope: spellBodyDSLScope, mode: "markup")
