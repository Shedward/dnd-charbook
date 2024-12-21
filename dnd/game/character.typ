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
  initiative: none,
  baseArmorClass: auto,
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
  initialite: initiative,
  baseArmorClass: baseArmorClass
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

#let statForSkill(skill) = {
  skills.filter(i => i.skill == skill).first().stat
}

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
  props: (),
  stat: none,
  slots: none
) = (
  focus: focus,
  ritualCasting: rutualCasting,
  props: props,
  stat: stat,
  slots: slots
)

#let byCharacterLevel(character, x) = {
  if character.level == none {
    none
  } else if type(x) == "function" {
    x(character.level)
  } else if type(x) == "dictionary" {
    switchInt(character.level, x)
  } else {
    panic("Not supported")
  }
}

#let byLevelMethod(x) = character => byCharacterLevel(character, x)

#let byLevel(x) = resolveForCharacter(byLevelMethod)

#let atLevel(level, body) = resolveForCharacter(c => if c.level == level {
  body
})

#let afterLevel(level, body) = resolveForCharacter(c => if c.level >= level {
  body
})

#let statValue(character, stat) = {
  if stat != none and character.stats != none {
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
  let speed = method(character, c => c.speed)
  if speed != none {
    speed.walking
  }
}

#let hitDices(type) = byLevelMethod(l => hstack(size: (1fr, auto), none, [/#l#type]))

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

#let skillModifier(character, skill) = {
  let proffBonus = method(character, c => c.proffBonus)
  let stat = statForSkill(skill)
  let modifier = statModifier(character, stat)

  if proffBonus != none and modifier != none and character.skillProffs != none {
    let isTrained = character.skillProffs.contains(skill)
    modifier + if isTrained { proffBonus } else { 0 }
  }
}

#let spellcastingStat(character) = {
  if character.spellcasting != none {
    character.spellcasting.stat
  }
}

#let spellAtkBonus(character) = {
  let proffMod = proffBonus(character)
  let stat = spellcastingStat(character)
  let statMod = statModifier(character, stat)

  if proffMod != none and statMod != none {
    proffMod + statMod
  }
}

#let spellDC(character) = {
  let proffMod = proffBonus(character)
  let stat = spellcastingStat(character)
  let statMod = statModifier(character, stat)

  if proffMod != none and statMod != none {
    8 + proffMod + statMod
  }
}

#let statName(stat) = {
  if stat != none {
    (
      STR: loc(en: "STR", ru: "СИЛ"),
      DEX: loc(en: "DEX", ru: "ЛОВ"),
      CON: loc(en: "CON", ru: "ТЕЛ"),
      INT: loc(en: "INT", ru: "ИНТ"),
      WIS: loc(en: "WIS", ru: "МУД"),
      CHA: loc(en: "CHA", ru: "ХАР")
    ).at(stat)
  }
}

#let skillName(skill) = {
  (
    acrobatics: loc(en: "Acrobatics", ru: "Акробатика"),
    animalHandling: loc(en: "Animal H.", ru: "Уход за Жив."),
    arcana: loc(en: "Arcana", ru: "Магия"),
    athletics: loc(en: "Athletics", ru: "Атлетика"),
    deception: loc(en: "Deception", ru: "Обман"),
    history: loc(en: "History", ru: "История"),
    insight: loc(en: "Insight", ru: "Проницательность"),
    intimidation: loc(en: "Intimidation", ru: "Запугивание"),
    investigation: loc(en: "Investigation", ru: "Расследование"),
    medicine: loc(en: "Medicine", ru: "Медицина"),
    nature: loc(en: "Nature", ru: "Природа"),
    perception: loc(en: "Perception", ru: "Восприятие"),
    persuation: loc(en: "Persuation", ru: "Убеждение"),
    performance: loc(en: "Performance", ru: "Выступление"),
    religion: loc(en: "Religion", ru: "Религия"),
    sleighOfHand: loc(en: "Sleigh of Hand", ru: "Ловкость рук"),
    stealth: loc(en: "Stealch", ru: "Скрытность"),
    survival: loc(en: "Survival", ru: "Выживание")

  ).at(skill)
}
