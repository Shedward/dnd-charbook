#import "../core/core.typ": *

#let character(
  name: none,
  class: none,
  subclass: none,
  race: none,
  type: none,
  alignment: none,
  story: none,
  spellcasting: none,
  level: 1
) = (
  name: name,
  class: class,
  subclass: subclass,
  race: race,
  type: type,
  alignment: alignment,
  story: story,
  spellcasting: spellcasting,
  level: level
)

#let STR = loc(en: "STR", ru: "СИЛ")
#let DEX = loc(en: "DEX", ru: "ЛОВ")
#let CON = loc(en: "CON", ru: "ТЕЛ")
#let INT = loc(en: "INT", ru: "ИНТ")
#let WIS = loc(en: "WIS", ru: "МУД")
#let CHA = loc(en: "CHA", ru: "ХАР")

#let stats = (STR, DEX, CON, INT, WIS, CHA)

#let acrobatics = loc(en: "Acrobatics", ru: "Акробатика")
#let animalHandling = loc(en: "Animal H.", ru: "Уход за Жив.")
#let arcana = loc(en: "Arcana", ru: "Магия")
#let athletics = loc(en: "Athletics", ru: "Атлетика")
#let deception = loc(en: "Deception", ru: "Обман")
#let history = loc(en: "History", ru: "История")
#let insight = loc(en: "Insight", ru: "Проницательность")
#let intimidation = loc(en: "Intimidation", ru: "Запугивание")
#let investigation = loc(en: "Investigation", ru: "Расследование")
#let medicine = loc(en: "Medicine", ru: "Медицина")
#let nature = loc(en: "Nature", ru: "Природа")
#let perception = loc(en: "Perception", ru: "Восприятие")
#let performance = loc(en: "Performance", ru: "Выступление")
#let religion = loc(en: "Religion", ru: "Религия")
#let sleighOfHand = loc(en: "Sleigh of Hand", ru: "Ловкость рук")
#let stealth = loc(en: "Stealch", ru: "Скрытность")
#let survival = loc(en: "Survival", ru: "Выживание")

#let skills = (
  (name: acrobatics, stat: DEX),
  (name: animalHandling, stat: WIS),
  (name: arcana, stat: INT),
  (name: athletics, stat: STR),
  (name: deception, stat: CHA),
  (name: history, stat: INT),
  (name: insight, stat: WIS),
  (name: intimidation, stat: INT),
  (name: investigation, stat: INT),
  (name: medicine, stat: WIS),
  (name: nature, stat: INT),
  (name: perception, stat: WIS),
  (name: performance, stat: CHA),
  (name: religion, stat: INT),
  (name: sleighOfHand, stat: DEX),
  (name: stealth, stat: DEX),
  (name: survival, stat: WIS)
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
