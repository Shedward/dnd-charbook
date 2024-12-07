#import "../core/core.typ": *

#let setCharacter(currentCharacter) = [
  #metadata(currentCharacter) <character>
]

#let resolveForCharacter(fn) = context {
  let characterRecords = query(<character>)
  let currentCharacter = if characterRecords.len() > 0 {
    characterRecords.first().value
  } else {
    panic("Character is not specified")
  }

  fn(currentCharacter)
}

#let character(
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
  skillProffs: none,
  saveProffs: none,
  proffBonus: none,
  speed: none,
  hitDices: none,
  maxHp: none,
  initiative: none
) = (
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
  skillProffs: skillProffs,
  saveProffs: saveProffs,
  proffBonus: proffBonus,
  speed: speed,
  hitDices: hitDices,
  maxHp: maxHp,
  initialite: initiative
)

#let STR = "STR"
#let DEX = "DEX"
#let CON = "CON"
#let INT = "INT"
#let WIS = "WIS"
#let CHA = "CHA"

#let stats = (STR, DEX, CON, INT, WIS, CHA)

#let acrobatics = "acrobatics"
#let animalHandling = "animalHandling"
#let arcana = "arcana"
#let athletics = "athletics"
#let deception = "deception"
#let history = "history"
#let insight = "insight"
#let intimidation = "intimidation"
#let investigation = "investigation"
#let medicine = "medicine"
#let nature = "nature"
#let perception = "perception"
#let persuation = "persuation"
#let performance = "performance"
#let religion = "religion"
#let sleighOfHand = "sleighOfHand"
#let stealth = "stealth"
#let survival = "survival"

#let skills = (
  (skill: athletics, stat: STR),

  (skill: acrobatics, stat: DEX),
  (skill: sleighOfHand, stat: DEX),
  (skill: stealth, stat: DEX),

  (skill: history, stat: INT),
  (skill: arcana, stat: INT),
  (skill: nature, stat: INT),
  (skill: investigation, stat: INT),
  (skill: religion, stat: INT),

  (skill: perception, stat: WIS),
  (skill: survival, stat: WIS),
  (skill: medicine, stat: WIS),
  (skill: insight, stat: WIS),
  (skill: animalHandling, stat: WIS),

  (skill: performance, stat: CHA),
  (skill: intimidation, stat: CHA),
  (skill: deception, stat: CHA),
  (skill: persuation, stat: CHA)
)

#let speed(
  walking: none,
  flying: none,
  swimming: none,
  climbing: none
) = (
  walking: walking,
  flying: flying,
  swimming: swimming,
  climbing: climbing
)

#let spellcasting(
  focus: none,
  rutualCasting: false,
  prepearing: false,
  resources: ()
) = (
  focus: focus,
  ritualCasting: rutualCasting,
  prepearing: false,
  resources: resources
)

#let byLevel(x) = character => {
  if character.level == none {
    none
  } else if type(x) == "function" {
    x(character.level)
  } else if type(x) == "dictionary" {
    let keys = x.keys().map(int).filter(l => l <= character.level)
    if keys.len() > 0 {
      x.at(str(keys.last()))
    }
  } else {
    panic("Not supported")
  }
}

#let statValue(character, stat) = {
  if character.stats != none {
    character.stats.at(stat, default: none)
  }
}

#let statModifier(character, stat) = {
  let value = statValue(character, stat)
  if value != none {
    calc.floor((value - 10) / 2)
  }
}

#let initiativeModifier(character) = {
  statModifier(character, DEX)
}

#let baseArmorClass(character) = {
  10 + statModifier(character, DEX)
}

#let proffBonus(character) = {
  method(character, c => c.proffBonus)
}

#let walkingSpeed(character) = {
  method(character, c => c.speed).walking
}

#let hitDices(type) = byLevel(l => hstack(size: (1fr, auto), none, [/#l#type]))

#let maxHp(firstLevelHp, nextLevelHp) = character => {
  let con = statModifier(character, CON)
  if con != none and character.level != none {
    let firstLevel = firstLevelHp + con
    let nextLevels = (nextLevelHp + calc.min(con, 1)) * (character.level - 1)
    firstLevel + nextLevels
  }
}

#let saveModifier(character, stat) = {
  let proffBonus = method(character, c => c.proffBonus)
  let modifier = statModifier(character, stat)

  if proffBonus != none and modifier != none and character.saveProffs != none {
    let isTrained = character.saveProffs.contains(stat)
    modifier + if isTrained { proffBonus } else { 0 }
  }
}
