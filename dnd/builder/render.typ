#import "../core/core.typ"
#import "../game/game.typ": *
#import "../page/page.typ"

#let charbook(
  char,
  locale: "ru",
  cover: none,
  biography: none,
  quests: 0,
) = {
  show: core.charbook
  core.setLocale(locale)
  setCharacter(char)

  if cover != none {
    page.cover(char.name, ..cover)
  }

  page.charlist(char)
  page.attacks
  page.inventory

  let charSpells = char.at("spells", default: none)
  if charSpells != none {
    let hasSpells = (
      charSpells.cantrips.len() > 0
      or charSpells.byLevel.values().any(list => list.len() > 0)
    )
    if hasSpells {
      page.spellPages(char)
    }
  }

  let abilities = char.at("abilities", default: ())
  if abilities.len() > 0 {
    page.abilities(..abilities)
  }

  let proficiencies = char.at("proficiencies", default: ())
  if proficiencies.len() > 0 {
    page.proficiencies(..proficiencies)
  }

  if biography != none {
    biography
  }

  for _ in range(quests) {
    page.quests
  }
}
