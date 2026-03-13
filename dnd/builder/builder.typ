#import "../game/game.typ": *
#import "render.typ": charbook

#let _normalizeArray(v) = if v == none { () } else { v }

#let build(..mutations) = {
  let result = mutations.pos().fold(none, (s, mut) => mut(s))
  let (currentSource: _, ..char) = result
  char
}

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
  skillProfs: _normalizeArray(skillProfs),
  skillExpert: _normalizeArray(skillExpert),
  saveProfs: _normalizeArray(saveProfs),
  profBonus: profBonus,
  speed: speed,
  hitDices: hitDices,
  maxHp: maxHp,
  initiative: initiative,
  baseArmorClass: baseArmorClass,
  abilities: (),
  proficiencies: (),
  spells: (cantrips: (), byLevel: (:)),
  currentSource: none,
)

#let upgrade(name, ..mutations) = (state) => {
  let s = (..state, currentSource: name)
  mutations.pos().fold(s, (s2, mut) => mut(s2))
}

// Scalar

#let setLevel(n) = (state) => (..state, level: n)

#let setSpellcasting(sc) = (state) => (..state, spellcasting: sc)

// Stats

#let addStatBonus(stat, amount) = (state) => {
  let stats = state.stats
  stats.insert(stat, stats.at(stat) + amount)
  (..state, stats: stats)
}

// Skills / saves

#let addSkillProfs(..skills) = (state) => {
  (..state, skillProfs: state.skillProfs + skills.pos())
}

#let addExpertise(..skills) = (state) => {
  (..state, skillExpert: state.skillExpert + skills.pos())
}

#let addSaveProfs(..stats) = (state) => {
  (..state, saveProfs: state.saveProfs + stats.pos())
}

// Abilities

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

// Proficiencies

#let addProficiency(prof) = (state) => {
  let patched = (..prof, source: state.currentSource)
  (..state, proficiencies: state.proficiencies + (patched,))
}

// Spells

#let addSpell(level, sp) = (state) => {
  let patched = (..sp, source: state.currentSource)
  let spells = state.spells
  if type(level) == int {
    let key = str(level)
    let existing = spells.byLevel.at(key, default: ())
    spells.byLevel.insert(key, existing + (patched,))
  } else {
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
