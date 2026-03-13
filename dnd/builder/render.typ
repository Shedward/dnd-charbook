// Top-level book renderer for builder-API characters.
//
// Usage:
//   #charbook(char)
//
// or with options:
//   #charbook(char,
//     locale: "ru",
//     cover: (title: "...", author: "...", image: image(...)),
//     biography: [ #backstory[...] #personality[...] ],
//   )

#import "../core/core.typ"
#import "../game/game.typ": *
#import "../page/page.typ"

// Renders a complete standard character book from a builder character dict.
//
// Parameters:
//   char      — character dict produced by build(...)
//   locale    — "ru" or "en" (default: "ru")
//   cover     — optional named-args dict passed to page.cover(); if none, cover is skipped
//   biography — optional content block for biography pages
//   quests    — number of quest pages to append (default: 0)
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

  // Cover
  if cover != none {
    page.cover(char.name, ..cover)
  }

  // Character stats sheet
  page.charlist(char)

  // Attacks (empty form, always included)
  page.attacks

  // Inventory (empty form, always included)
  page.inventory

  // Spells (if char has spells from builder API)
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

  // Abilities (if non-empty)
  let abilities = char.at("abilities", default: ())
  if abilities.len() > 0 {
    page.abilities(..abilities)
  }

  // Proficiencies (if non-empty)
  let proficiencies = char.at("proficiencies", default: ())
  if proficiencies.len() > 0 {
    page.proficiencies(..proficiencies)
  }

  // Biography
  if biography != none {
    biography
  }

  // Quests
  for _ in range(quests) {
    page.quests
  }
}
