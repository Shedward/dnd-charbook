#import "../dnd/dnd.typ"
#import "../dnd/game/game.typ": *
#import "../dnd/builder/builder.typ": *

#let char = build(
  introduce(
    name: "Тест Билдер",
    stats: (STR: 8, DEX: 14, CON: 12, INT: 10, WIS: 13, CHA: 18),
  ),

  upgrade("Человек",
    setRace("Человек"),
    setType("Гуманоид"),
    setAlignment("Законопослушный добрый"),
    setSpeed(movementSpeed(walking: 30)),
    addStatBonus(STR, 1),
    addStatBonus(DEX, 1),
    addStatBonus(CON, 1),
    addStatBonus(INT, 1),
    addStatBonus(WIS, 1),
    addStatBonus(CHA, 1),
    addProficiency(languageProficiency("Общий")),
    addProficiency(languageProficiency("Эльфийский")),
  ),

  upgrade("Учёный-затворник",
    setStory("Учёный-затворник"),
    addSkillProfs(history, nature),
    addAbility("Доступ к библиотеке")[
      Вы можете запросить информацию из библиотек королевства.
    ],
  ),

  upgrade("Колдун 1ур",
    setClass("Колдун"),
    setLevel(1),
    addHP(9),
    setHitDice(hitDices[k8]),
    setSpellcasting(spellcasting(
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
    )),
    addSaveProfs(WIS, CHA),
    addSkillProfs(persuasion, deception),
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

  upgrade("Небожитель",
    setSubclass("Небожитель"),
    addSpellFromSpellbook("light"),
    addSpellFromSpellbook("cure-wounds"),
    addAbility("Лечащий свет")[
      У вас есть кости лечения. Бонусным действием потратьте кости, чтобы вылечить существо в 60 футах.
    ],
  ),

  upgrade("Колдун 2ур",
    setLevel(2),
    addHP(6),
    addAbility("Воззвание: Мучительный взрыв")[
      Добавьте #damage("CHA", force) к урону Мистического заряда.
    ],
  ),

  upgrade("Колдун 3ур",
    setLevel(3),
    addHP(6),
  ),

  upgrade("Колдун 4ур — ASI",
    setLevel(4),
    addHP(6),
    addStatBonus(CHA, 2),
  ),

  upgrade("Колдун 5ур",
    setLevel(5),
    addHP(6),
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
