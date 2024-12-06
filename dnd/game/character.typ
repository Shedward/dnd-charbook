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
  maxHp: maxHp,
  initialite: initiative
)

#let STR = "STR"
#let DEX = "DEX"
#let CON = "CON"
#let INT = "INT"
#let WIS = "WIS"
#let CHA = "CHA"

#let statName(stat) = {
  (
    STR: loc(en: "STR", ru: "СИЛ"),
    DEX: loc(en: "DEX", ru: "ЛОВ"),
    CON: loc(en: "CON", ru: "ТЕЛ"),
    INT: loc(en: "INT", ru: "ИНТ"),
    WIS: loc(en: "WIS", ru: "МУД"),
    CHA: loc(en: "CHA", ru: "ХАР")
  ).at(stat)
}

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
