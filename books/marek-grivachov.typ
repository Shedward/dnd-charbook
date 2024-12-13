#import "../dnd/dnd.typ"
#import "../dnd/game/game.typ": *

#show: dnd.core.charbook

#setLocale("ru")

#let marek = dnd.game.character(
  level: 2,
  name: "Марек Гривачов",
  class: "Колдун",
  subclass: "Небожитель",
  race: "Человек",
  type: "Гуманоид",
  alignment: "Lawful Good",
  story: "Ученный-затворник",
  spellcasting: spellcasting(
    focus: "Гримуар",
    stat: CHA,
    slots: byLevelMethod(
      (
        "1": ("1": 1),
        "2": ("1": 2),
        "3": ("2": 2),
        "5": ("3": 2),
        "7": ("4": 2),
        "9": ("5": 2),
        "11": ("5": 3),
        "17": ("5": 4),
      )
    ),
    props: (
      (
        caption: "Заг    Закл   Возв",
        content: byLevelMethod(lvl => {
          let cantrips = switchInt(lvl, (
            "1": 2,
            "4": 3,
            "10": 4
          ))

          let spells = switchInt(lvl, (
            "1": 2,
            "2": 3,
            "3": 4,
            "4": 5,
            "5": 6,
            "6": 7,
            "7": 8,
            "8": 9,
            "9": 10,
            "11": 11,
            "13": 12,
            "15": 13,
            "17": 14,
            "19": 15
          ))

          let invocations = switchInt(lvl,
            (
              "1": 1,
              "2": 3,
              "5": 4,
              "7": 5,
              "9": 6,
              "12": 7,
              "15": 8,
              "18": 9
            )
          )
          pad(x: 0.25em, hstack([#cantrips], [#spells], [#invocations]))
        })
      ),
    )
  ),
  stats: (
    STR: 8,
    DEX: 14,
    CON: 12,
    INT: 8,
    WIS: 15,
    CHA: 16
  ),
  skillProffs: (
    persuation,
    perception,
    history,
    nature
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
  maxHp: maxHp(8, 5)
)

#let byLevel(x) = byCharacterLevel(marek, x)

#setCharacter(marek)

#dnd.page.cover(
  marek.name,
  image: image("../resources/images/marek-photo.png", width: 3cm),
  title: "Зачетная книжка студента",
  author: "Факультет разведения",
  caption: [
    Таэр-Валаэстовское училище Коневедения

    пл. Седельников, 9
  ],
  subtitle: "Группа 102-1"
)

#dnd.page.attacks

#dnd.page.charlist(marek)

#dnd.page.inventory

#page(
  header: section[Заклинания]
)[
  #dnd.page.spellcasting(marek)

  #dnd.page.spellSlotsSection(marek)

  #dnd.page.spellsSection(
    level: cantrip,

    spell(
      "Мистический заряд",
      prep: none,
      school: evocation,
      duration: instant,
      range: target(
        120,
        count: byLevel((
          "1": 1,
          "5": 2,
          "11": 3,
          "17": 4
        ))
      ),
      components: "VS",
      source: "Колдун 1ур"
    )[
      #damage("1d10", force, ranged: true, saving: WIS)\
      На 5, 11 и 17 ур - дополнительные лучи.
    ],

    spell(
      "Фокусы",
      prep: none,
      school: transmutation,
      duration: hour(1),
      range: point(10),
      components: "VS",
      source: "Колдун 1ур"
    )[
      Выберите одно из
      - Сенсорный эффект: образ, ощущение, звук, или запах.
      - Зажигаете или тушите свечу, факел или небольшой костер.
      - Чистите или мараете предмет, размерами до 1фт.
      - Остужаете, нагреваете или придаете вкус 1фт неживой материи на 1 час.
      - Создаёте на поверхности образ, существующую 1 час.
      - Вы создаёте безделушку, помещающееся в ладонь, и существующее до конца следующего хода.
      Одновременно можно до 3ех эффектов
    ],

    spell(
      "Свет",
      prep: none,
      school: evocation,
      duration: hour(1),
      range: touch,
      components: "VS",
      source: "Небожитель 1ур"
    )[
      Предмет не больше 10 футов.
      Предмет испускает яркий свет в радиусе 20 футов и тусклый свет в пределах ещё 20 футов.
    ],

    spell(
      "Священное пламя",
      prep: none,
      school: evocation,
      duration: hour(1),
      range: touch,
      components: "VS",
      source: "Небожитель 1ур"
    )[
      #damage("1d8", radiant, saving: DEX), укрытие не работает
    ],
  )
]

#page(
  header: section[Заклинания]
)[
  // Открыть на 3 ур.
  // #dnd.page.spellsSection(
  //   level: cantrip,

  //   spell(
  //     "Magic hand",
  //     prep: alwaysPrepared,
  //     school: "Вызов",
  //     duration: minute(1),
  //     range: point(30),
  //     components: "VS",
  //     source: "Книга теней"
  //   )[
  //     Призывает магическую руку.
  //     Она может существовать в пределах 30фт
  //     Может взаимодействовать с предметами и двигать вещи менее 10фт (4кг)
  //   ],

  //   spell(
  //     "Shape water",
  //     prep: alwaysPrepared,
  //     school: "Преобразование",
  //     duration: hour(1),
  //     range: point(30),
  //     components: "VS",
  //     source: "Книга теней"
  //   )[
  //     Призывает магическую руку.
  //     Она может существовать в пределах 30фт
  //     Может взаимодействовать с предметами и двигать вещи менее 10фт (4кг)
  //   ],

  //   spell(
  //     "Guidance",
  //     prep: alwaysPrepared,
  //     school: "Преобразование",
  //     duration: minute(1),
  //     range: touch,
  //     components: "VS",
  //     source: "Книга теней"
  //   )[
  //     Вы касаетесь одного согласного существа.
  //     Один раз, пока заклинание активно, цель может бросить 1к4 и добавить выпавшее число
  //     к одной проверке характеристики на свой выбор. Эту кость можно бросить до или после совершения проверки.
  //     После этого заклинание оканчивается.
  //   ],
  // )

  #dnd.page.spellsSection(
    level: spellLevel(1),

    spell(
      "Порча",
      prep: none,
      school: enchantment,
      duration: hour(1),
      range: target(90),
      castType: concentration,
      components: "VSM",
      source: "Колдун 1ур"
    )[
      Дополнительно #damage("1d6", necrotic) при попадании.
      Помеха на выбранную характеристику.

      Если цель умирает - можно выбрать другую цель бонусным действием
    ],

    spell(
      "Защита от добра и зла",
      prep: none,
      school: abjuration,
      duration: minute(10),
      range: touch,
      castType: concentration,
      components: "VSM",
      source: "Колдун 1ур"
    )[
      Существо защищено от Аберрации, Исчадия, Небожители, Нежить, Феи и Элементали.
      Помеха на броски атаки, цель не может быть очарована, испугана или одержима.
      Или получает приемущество на броски против эффекта
    ],

    spell(
      "Лечение ран",
      prep: none,
      school: evocation,
      duration: instant,
      range: touch,
      components: "VS",
      source: "Небожитель 1ур"
    )[
      #heal("1d8 + CHA")
    ],

    spell(
      "Направляющий снаряд",
      prep: none,
      school: evocation,
      duration: round(1),
      range: target(120),
      components: "VS",
      source: "Небожитель 1ур"
    )[
      #damage("4d6", radiant, ranged: true) + приемущ. на следующий бросок атаки
    ],

    spell(
      "Разговор с животным",
      prep: alwaysPrepared,
      school: divination,
      duration: minute(10),
      components: "VS",
      source: "Воззвание: Животная речь"
    )[
      Пока заклинание активно, вы получаете возможность понимать Зверей и общаться с ними устно.
      Знание и сознание многих Зверей ограничено их интеллектом,
      но они как минимум могут дать информацию о ближайших местах и чудовищах,
      включая тех, кого они видели за последний день.
      На усмотрение Мастера, вы можете попытаться убедить Зверя оказать вам небольшую помощь.
    ],

    spell(
      "Вызов страха",
      prep: none,
      school: necromancy,
      duration: minute(1),
      range: target(60),
      castType: concentration,
      components: "V",
      source: "Колдун 2ур"
    )[
      *МУД или испугано*, кроме конструктов и нежити
    ],

    spell(
      "Безмолвный образ",
      prep: alwaysPrepared,
      school: illusion,
      duration: minute(10),
      range: point(60),
      components: "VS",
      castType: concentration,
      source: "Воззвание: Туманные видения"
    )[
      Вы создаете визуальный образ предмета до 15фт.
      Действием образ можно переместить и менять.
    ]
  )
]

#dnd.page.abilities(
  ability("Потусторонний покровитель", source: "Колдун 1ур")[
    Вы заключили договор с единорогом Беложопкой
  ],

  ability("Магия договора", source: "Колдун 1ур")[
    Характеристика - ХАР

    $"Cл. сп." = 8 + "Бон. маст." + "ХАР"$
    $"Мод. бр. атаки" = "Бон. маст." + "ХАР"$
  ],

  ability("Лечащий свет", source: "Небожитель 1ур")[
    У вас есть кости лечения
    #abilityCountSlot[#(marek.level + 1)d6]

    Бонусным действием потратьте кости чтобы вылечить существо которое вы можете видеть в 60 футах.
    За раз можно потратить *до #statModifier(marek, CHA)* костей.
    Все кости восстанавливаются после продолжительного отдыха.
  ],

  ability("Доступ к библиотеке", source: "Ученый-затворник")[
    Вы можете запросить информацию из библиотек королевства
  ],

  ability("Адепт таинств", source: "Черта человека")[
    +1 воззвание
  ],

  ability("Воззвание:\nЖивотная речь", source: "Адепт таинств")[
    Вы можете неограниченно накладывать Разговор с животным
    не тратя ячеек заклинания.
  ],

  ability("Воззвание:\nМучительный взрыв", source: "Колдун 2ур")[
    Добавьте #damage("CHA", force) к урону Мистического снаряда
  ],

  ability("Воззвание:\nТуманные видения", source: "Колдун 2ур")[
    Вы можете неограниченно накладывать Безмолвный образ
  ],
)

#dnd.page.proficiencies(
  weaponProficiency("Простое оружие", source: "Колдун 1ур"),
  armorProficiency("Лёгкая броня", source: "Колдун 1ур"),
  savingProficiency(WIS, source: "Колдун 1ур"),
  savingProficiency(CHA, source: "Колдун 1ур"),
  skillProficiency(persuation, source: "Колдун 1ур"),
  skillProficiency(perception, source: "Колдун 1ур"),
  skillProficiency(history, source: "Учённый-затворник"),
  skillProficiency(nature, source: "Учённый-затворник")
)

#dnd.page.backstory[
  Марек родился в маленькой деревушке недалеко от Таэр-Валаэста в семье, разводившей лошадей.
  Любовь к этим животным сопровождала его с самого детства.
  Волею случая он поступил на бюджет в Таэр-Валаэстовское училище на конюха.
  Учеба давалась легко, но отношения с горделивыми эльфами-одногруппниками складывались трудно.

  Однажды Марек заметил белоснежную лошадь необычайной красоты, выбегающую из стойла.
  Решив, что животное сбежало, он попытался её остановить, но лошадь оттолкнула его, и в его голове раздался голос:
  — Оседлать меня сможет лишь достойный.

  Разглядев белоснежный рог на лбу, Марек понял, что перед ним единорог.
  Завороженный, он поклялся отказаться от ругательств, алкоголя и плотских утех.

  — Зови меня Беложопка, — произнесло существо и склонилось перед ним.

  Когда Марек коснулся рога, из здания выбежал богато одетый эльф, громко крича:

  — Вор!

  Беложопка тревожно заржал, ударил копытами и исчез во вспышке света.
  Эльф обрушил на Марека ослепительную магию, и тот потерял сознание.

  Очнувшись, он обнаружил себя привязанным к стулу.
  Перед ним стояли ректор училища, преподаватель Сириэль и тот самый эльф — главный конюх города,
  обвинявший Марека в краже.

  — Либо он найдет и вернет единорога в течение года, либо его отчислят,
  посадят в тюрьму, а семью лишат всего, — настаивал эльф.

  Незавершенный договор с Беложопкой наделил Марека магическими способностями,
  но лишил его возможности нарушить данную клятву. Сириэль предположил,
  что если единорога вернуть, связь можно будет разорвать.

  Так Марек отправился в путь. Последние слухи о “сияющем жеребце” приходили из Земель Скорби.

]

#dnd.page.personality[
  #biographySection("Черты")[
    #biographySubsection("Любовь к лошадям")[
      Я люблю все что связано с лошадьми
    ]
    #biographySubsection("Зануда")[
      Я очень дотошен к фактам и правилам.
      Будет следовать любым надписям и инструкции.
    ]
  ]

  #biographySection("Связи")[
    #biographySubsection("Родители")[
      Марек очень любит своих родителей
    ]
    #biographySubsection("Беложопка")[
      То ли дело в магическом договоре, то-ли в божественной красоте,
      но Марек был очарован Беложопкой
    ]
    #biographySubsection("Сириэль Ан’Валаэсса")[
      Преподаватель разведения в техникуме.
      Всегда хорошо относилась к Мареку
    ]
  ]

  #biographySection("Идеалы")[
    #biographySubsection("Правильность")[
      Марек стремится делать все максимально дотошно и правильно
    ]
  ]

  #colbreak()

  #biographySection("Цели")[
    #biographySubsection("Отыскать Беложопку")[
      Нужно отыскать и вернуть в город Беложопку чтобы разорвать договор
    ]
    #biographySubsection("Стать главным конюхом города")[
      Любой уважающий себя коневод в Таэр-Валаэст мечтает
      стать главным конюхом.
    ]
  ]

  #biographySection("Слабости")[
    #biographySubsection("Лошади, кони и пони")[
      Моя любовь к лошадям настолько велика что
      в разговоре я буду вставлять неуместные факты о лошадях,
      увидев лошадь обязательно к ней подойду,
      а в бою меня легко отвлечь лошадинным ржанием.
    ]

    #biographySubsection("Договор с единорогом")[
      Марек не может пить алкоголь, ругаться или флиртовать.
      Алкоголь в его руках превращается в теплое молоко,
      ругательства - в случайные слова, а флиртовать с ним
      и так никто не флиртовал.
    ]
  ]
]

#dnd.page.quests
#dnd.page.quests
