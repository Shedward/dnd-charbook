#import "../dnd/dnd.typ"
#import "../dnd/game/game.typ": *
#import "../dnd/builder/builder.typ": *

#let char = build(
  introduce(
    name: "Тест Билдер",
    class: "Колдун",
    subclass: "Небожитель",
    race: "Человек",
    type: "Гуманоид",
    alignment: "Lawful Good",
    story: "Учёный-затворник",
    level: 4,
    stats: (STR: 8, DEX: 14, CON: 12, INT: 10, WIS: 13, CHA: 18),
    speed: movementSpeed(walking: 30),
    hitDices: hitDices[k8],
    spellcasting: spellcasting(
      stat: CHA,
      focus: "Гримуар",
      slots: byLevelMethod((
        "1": ("1": 1),
        "2": ("1": 2),
        "3": ("2": 2),
        "5": ("3": 2),
        "7": ("4": 2),
        "9": ("5": 2),
      )),
    ),
  ),

  upgrade("Колдун 1ур",
    addHP(9),
    addSkillProfs(persuasion, deception),
    addSaveProfs(WIS, CHA),
    addProficiency(armorProficiency("Лёгкая броня")),
    addProficiency(weaponProficiency("Простое оружие")),
    addAbility("Потусторонний покровитель")[
      Вы заключили договор с Беложопкой.
      #abilityRequirement[Требуется: принять договор]
    ],
    addAbility("Магия договора")[
      Характеристика заклинаний — ХАР.

      $"Сл. сп." = 8 + "Бон. маст." + "ХАР"$
    ],
    addSpellFromSpellbook("eldritch-blast"),
    addSpellFromSpellbook("hex"),
  ),

  upgrade("Колдун 2ур",
    addHP(6),
    addAbility("Воззвание: Мучительный взрыв")[
      Добавьте #damage("CHA", force) к урону Мистического заряда.
    ],
  ),

  upgrade("Колдун 3ур",
    addHP(6),
  ),

  upgrade("Колдун 4ур — ASI",
    addHP(6),
    setLevel(4),
    addStatBonus(CHA, 2),
  ),

  upgrade("Небожитель 1ур",
    addSpellFromSpellbook("light"),
    addSpellFromSpellbook("cure-wounds"),
    addAbility("Лечащий свет")[
      У вас есть кости лечения. Бонусным действием потратьте кости, чтобы вылечить существо в 60 футах.
    ],
  ),

  upgrade("Колдун 5ур",
    addHP(6),
    setLevel(5),
    addSpellFromSpellbook("acid-splash"),
    addSpellFromSpellbook("fireball"),
  ),

  upgrade("Событие: Спасение гоблинки",
    addAbility("Настоящий друг")[
      Вы получаете +1 КД.
    ],
  ),

  upgrade("Конец события: Спасение гоблинки",
    removeAbility("Настоящий друг"),
  )
)

#charbook(char,
  locale: "ru",
  biography: [
    #dnd.page.backstory[
      Тест-персонаж для проверки builder API.
      Здесь должна быть предыстория персонажа.
    ]
  ],
)
