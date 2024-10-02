#let character(
  name: none,
  class: none,
  subclass: none,
  race: none,
  type: none,
  alignment: none,
  story: none,
  level: 1
) = (
  name: name,
  class: class,
  subclass: subclass,
  race: race,
  type: type,
  alignment: alignment,
  story: story,
  level: level
)

#let STR = "STR"
#let DEX = "DEX"
#let CON = "CON"
#let INT = "INT"
#let WIS = "WIS"
#let CHA = "CHA"

#let stats = (STR, DEX, CON, INT, WIS, CHA)

#let acrobatics = "Acrobatics"
#let animalHandling = "Animal H."
#let arcana = "Arcana"
#let athletics = "Athletics"
#let deception = "Deception"
#let history = "History"
#let insight = "Insight"
#let intimidation = "Intimidation"
#let investigation = "Investigation"
#let medicine = "Medicine"
#let nature = "Nature"
#let perception = "Perception"
#let performance = "Performance"
#let religion = "Religion"
#let sleighOfHand = "Sleigh of Hand"
#let stealth = "Stealch"
#let survival = "Survival"

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
