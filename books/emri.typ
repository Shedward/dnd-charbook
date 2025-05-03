#import "../dnd/dnd.typ"
#import "../dnd/game/game.typ": *

#show: dnd.core.charbook

#setLocale("ru")

#let emri = dnd.game.character(
  level: 5,
  name: "Эмри",
  class: "Жрец",
  subclass: "Кузни",
  race: "Кованый",
  type: "Конструкт",
  alignment: "Хаотично-нейтральный",
  story: "Солдат",
  spellcasting: spellcasting(
    focus: "Священный символ",
    stat: WIS,
    slots: byLevelMethod(
      (
        "1": ("1": 2),
        "2": ("1": 3),
        "3": ("1": 4, "2": 2),
        "4": ("1": 4, "2": 3),
        "5": ("1": 4, "2": 3, "3": 2),
        "6": ("1": 4, "2": 3, "3": 3),
        "7": ("1": 4, "2": 3, "3": 3, "4": 1),
        "8": ("1": 4, "2": 3, "3": 3, "4": 2),
        "9": ("1": 4, "2": 3, "3": 3, "4": 3, "5": 1),
        "10": ("1": 4, "2": 3, "3": 3, "4": 3, "5": 2),
        "11": ("1": 4, "2": 3, "3": 3, "4": 3, "5": 2, "6": 1),
        "13": ("1": 4, "2": 3, "3": 3, "4": 3, "5": 2, "6": 1, "7": 1),
        "15": ("1": 4, "2": 3, "3": 3, "4": 3, "5": 2, "6": 1, "7": 1, "8": 1),
        "17": ("1": 4, "2": 3, "3": 3, "4": 3, "5": 2, "6": 1, "7": 1, "8": 1, "9": 1),
        "18": ("1": 4, "2": 3, "3": 3, "4": 3, "5": 3, "6": 1, "7": 1, "8": 1, "9": 1),
        "19": ("1": 4, "2": 3, "3": 3, "4": 3, "5": 3, "6": 2, "7": 1, "8": 1, "9": 1),
        "20": ("1": 4, "2": 3, "3": 3, "4": 3, "5": 3, "6": 2, "7": 2, "8": 1, "9": 1),
      ),
    ),
    props: (
      (
        caption: "Заг.",
        content: byLevelMethod((
          "1": 2,
          "2": 3,
          "3": 4,
          "10": 5
        ))
      ),
    ),
  ),
  stats: (
    STR: 14,
    DEX: 10,
    CON: 18,
    INT: 8,
    WIS: 16,
    CHA: 8
  ),
  skillProffs: (
    athletics,
    stealth,
    perception,
    medicine,
    insight,
    intimidation,
  ),
  skillExpert: (
    perception
  ),
  saveProffs: (
    WIS, CHA
  ),
  proffBonus: byLevelMethod(
    (
      "1": 2,
      "5": 3,
      "9": 4,
      "13": 5,
      "17": 6
    )
  ),
  speed: speed(walking: 30),
  hitDices: hitDices[k8],
  maxHp: 54
)

#let byLevel(x) = byCharacterLevel(emri, x)

#setCharacter(emri)

#dnd.page.cover(
  emri.name,
)

#dnd.page.attacks
#dnd.page.charlist(emri)
#dnd.page.inventory

#page(
  header: section[Заклинания]
)[
  #dnd.page.spellcasting(emri)

  #dnd.page.spellSlotsSection(emri)

  #inputGrid(19)
]

#page(
  header: section[Заклинания]
)[
    #inputGrid(29)
]

#page(
  header: section[Заклинания]
)[
    #inputGrid(29)
]
