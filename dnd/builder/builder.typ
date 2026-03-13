// Character Builder API
//
// Usage:
//   #import "../dnd/builder/builder.typ": *
//
//   #let char = build(
//     introduce(name: "...", level: 5, stats: (...), ...),
//     upgrade("Class 1",
//       addSkillProfs(persuasion, deception),
//       addAbility("Feature")[...],
//       addSpell(cantrip, spell("...", ...)[...]),
//     ),
//     upgrade("Event: Gift",
//       addAbility("Gift")[...],
//     ),
//   )
//   #setCharacter(char)

#import "../game/game.typ": *
#import "render.typ": charbook

// --- Internal helpers ---

#let _normalizeArray(v) = if v == none { () } else { v }

// --- Build engine ---

// Runs all mutations in sequence; first mutation (introduce) creates the state.
#let build(..mutations) = {
  let result = mutations.pos().fold(none, (s, mut) => mut(s))
  // Strip builder-only field before returning
  let (currentSource: _, ..char) = result
  char
}

// Creates the initial character state. Mirrors character() constructor params.
#let introduce(
  name: none,
  class: none,
  subclass: none,
  race: none,
  type: none,
  alignment: none,
  story: none,
  spellcasting: none,
  level: 1,
  stats: none,
  skillProfs: none,
  skillExpert: (),
  saveProfs: none,
  profBonus: none,
  speed: none,
  hitDices: none,
  maxHp: none,
  initiative: none,
  baseArmorClass: auto,
) = (_state) => (
  // Standard character fields
  name: name,
  class: class,
  subclass: subclass,
  race: race,
  type: type,
  alignment: alignment,
  story: story,
  spellcasting: spellcasting,
  level: level,
  stats: stats,
  // Normalize collections so add* mutations always append to arrays
  skillProfs: _normalizeArray(skillProfs),
  skillExpert: _normalizeArray(skillExpert),
  saveProfs: _normalizeArray(saveProfs),
  profBonus: profBonus,
  speed: speed,
  hitDices: hitDices,
  maxHp: maxHp,
  initiative: initiative,
  baseArmorClass: baseArmorClass,
  // Builder-only fields
  abilities: (),
  proficiencies: (),
  spells: (cantrips: (), byLevel: (:)),
  currentSource: none,
)

// Groups mutations under a named source. All items added within automatically
// get source set to `name`.
#let upgrade(name, ..mutations) = (state) => {
  let s = (..state, currentSource: name)
  mutations.pos().fold(s, (s2, mut) => mut(s2))
}

// --- Scalar mutations ---

#let setLevel(n) = (state) => (..state, level: n)

#let setSpellcasting(sc) = (state) => (..state, spellcasting: sc)

// --- Stat mutations ---

#let addStatBonus(stat, amount) = (state) => {
  let stats = state.stats
  stats.insert(stat, stats.at(stat) + amount)
  (..state, stats: stats)
}

// --- Collection mutations: skills / saves ---

#let addSkillProfs(..skills) = (state) => {
  (..state, skillProfs: state.skillProfs + skills.pos())
}

#let addExpertise(..skills) = (state) => {
  (..state, skillExpert: state.skillExpert + skills.pos())
}

#let addSaveProfs(..stats) = (state) => {
  (..state, saveProfs: state.saveProfs + stats.pos())
}

// --- Ability mutations ---

#let addAbility(title, body) = (state) => {
  let ab = ability(title, source: state.currentSource, body)
  (..state, abilities: state.abilities + (ab,))
}

#let removeAbility(title) = (state) => {
  (..state, abilities: state.abilities.filter(a => a.title != title))
}

#let replaceAbility(title, newTitle, body) = (state) => {
  let source = state.currentSource
  (..state, abilities: state.abilities.map(a => {
    if a.title == title {
      ability(newTitle, source: source, body)
    } else {
      a
    }
  }))
}

// --- Proficiency mutations ---

#let addProficiency(prof) = (state) => {
  let patched = (..prof, source: state.currentSource)
  (..state, proficiencies: state.proficiencies + (patched,))
}

// --- Spell mutations ---

// level: cantrip (the dict constant) or an int 1–9
#let addSpell(level, sp) = (state) => {
  let patched = (..sp, source: state.currentSource)
  let spells = state.spells
  if type(level) == int {
    let key = str(level)
    let existing = spells.byLevel.at(key, default: ())
    spells.byLevel.insert(key, existing + (patched,))
  } else {
    // cantrip (or any non-int level)
    spells.cantrips = spells.cantrips + (patched,)
  }
  (..state, spells: spells)
}

#let removeSpell(name) = (state) => {
  let spells = state.spells
  spells.cantrips = spells.cantrips.filter(s => s.name != name)
  for (lvl, spellList) in spells.byLevel {
    spells.byLevel.insert(lvl, spellList.filter(s => s.name != name))
  }
  (..state, spells: spells)
}
