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

#let stats = ("STR", "DEX", "CON", "INT", "WIS", "CHA")

#let skills = (
  (name: "Acrobatics", stat: "DEX"),
  (name: "Animal H.", stat: "WIS"),
  (name: "Arcana", stat: "INT"),
  (name: "Athletics", stat: "STR"),
  (name: "Deception", stat: "CHA"),
  (name: "History", stat: "INT"),
  (name: "Insight", stat: "WIS"),
  (name: "Intimidation", stat: "INT"),
  (name: "Investigation", stat: "INT"),
  (name: "Medicine", stat: "WIS"),
  (name: "Nature", stat: "INT"),
  (name: "Perception", stat: "WIS"),
  (name: "Performance", stat: "CHA"),
  (name: "Religion", stat: "INT"),
  (name: "Sleigh of Hand", stat: "DEX"),
  (name: "Stealth", stat: "DEX"),
  (name: "Survival", stat: "WIS")
)
