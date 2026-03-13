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
    maxHp: maxHp(8, 5),
    profBonus: byLevelMethod((
      "1": 2,
      "5": 3,
      "9": 4,
      "13": 5,
      "17": 6,
    )),
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
    addSpell(cantrip, spell(
      "Мистический заряд",
      prep: none,
      school: evocation,
      duration: instant,
      range: target(120),
      components: "VS",
    )[
      #damage("1d10", force, ranged: true)
    ]),
    addSpell(1, spell(
      "Порча",
      prep: none,
      school: enchantment,
      duration: hour(1),
      range: target(90),
      castType: concentration,
      components: "VSM",
    )[
      Помеха на выбранную характеристику. Дополнительный #damage("1d6", necrotic) при попадании.
    ]),
  ),

  upgrade("Колдун 2ур",
    addAbility("Воззвание: Мучительный взрыв")[
      Добавьте #damage("CHA", force) к урону Мистического заряда.
    ],
  ),

  upgrade("Колдун 4ур — ASI",
    setLevel(4),
    addStatBonus(CHA, 2),
  ),

  upgrade("Небожитель 1ур",
    addSpell(cantrip, spell(
      "Свет",
      prep: none,
      school: evocation,
      duration: hour(1),
      range: touch,
      components: "VS",
    )[
      Предмет испускает яркий свет 20фт и тусклый 20фт.
    ]),
    addSpell(1, spell(
      "Лечение ран",
      prep: none,
      school: evocation,
      duration: instant,
      range: touch,
      components: "VS",
    )[
      #heal("1d8 + CHA")
    ]),
    addAbility("Лечащий свет")[
      У вас есть кости лечения. Бонусным действием потратьте кости, чтобы вылечить существо в 60 футах.
    ],
  ),

  upgrade("Событие: Спасение гоблинки",
    addAbility("Настоящий друг")[
      Вы получаете +1 КД.
    ],
  ),
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
