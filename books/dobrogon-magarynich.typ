#import "../dnd/dnd.typ"

#show: dnd.core.charbook

#let dobrogon = dnd.game.character(
  name: "Dobrogon Magarynich",
  class: "Artificer",
  subclass: "Alchemist",
  race: "Autognome",
  type: "Construct",
  alignment: "Chaotic Neutral",
  story: "Failed Merchant"
)

#dnd.page.cover(
  dobrogon.name,
  author: "Batya M.",
  title: "User manual",
  caption: [
    Document number: 8001-004-01-e \
    Revision: 3.0B
  ],
  subtitle: "DM1043/S843"
)

#dnd.page.attacks

#dnd.page.charlist(
  dobrogon
)

#dnd.page.inventory

#import "../dnd/page/spells.typ": *

#dnd.page.spellsSection(
  level: cantrip,

  spell(
    "Mending",
    prep: alwaysPrepared,
    school: transmutation,
    castTime: minute(1),
    duration: instant,
    range: touch,
    components: "VSM"
  )[
    *Repair* small tear or *Heal self HD(1d8) + CON* (min 1)
  ],

  spell(
    "Create Bonfire",
    prep: alwaysPrepared,
    school: conjuration,
    castType: concentration,
    duration: minute(1),
    range: cube(5, range: 60),
    components: "VS"
  )[
    Create area, DEX or *Fire 2d8* on enter or stay
  ],

  spell(
    "Fire Bolt",
    prep: alwaysPrepared,
    school: evocation,
    duration: instant,
    range: target(120),
    components: "VS"
  )[
    Ranged, *Frost 2d8, Slow 10ft*
  ],

  spell(
    "Ray of Frost",
    prep: alwaysPrepared,
    school: evocation,
    duration: instant,
    range: target(60),
    components: "VS"
  )[
    Ranged, *Frost 2d8 + Slow 10ft*
  ]
)

#dnd.page.spellsSection(
  level: spellLevel(1, slots: 4),

  spell(
    "Healing Word",
    prep: alwaysPrepared,
    school: evocation,
    castTime: bonusAction,
    duration: instant,
    range: target(60),
    components: "V"
  )[
    *Heal 1d4 + Int*
    #atHigherLevels[+1d4]
  ],

  spell(
    "Ray of Sickness",
    prep: alwaysPrepared,
    school: conjuration,
    castTime: action,
    duration: instant,
    range: target(60),
    components: "VS"
  )[
    Ranged, *Poison 2d8*, CON or Poisoned
    #atHigherLevels[+1d8]
  ],

  spell(
    "Tasha's Hideous Laughter",
    prep: freePreparation(alwaysPrepared),
    school: evocation,
    castTime: action,
    castType: concentration,
    duration: minute(1),
    range: target(30),
    components: "VSM"
  )[
    WIS or *Prone and Incapacitated*, works only INT > 4
  ],

  spell(
    "Absorb Elements",
    prep: preparing,
    school: abjuration,
    castTime: reaction,
    duration: round(1),
    range: self,
    components: "S"
  )[
    Element *Resist*, next meele atack gain +1d6
    #atHigherLevels[+1d6]
  ],

  spell(
    "Alarm",
    prep: preparing,
    school: abjuration,
    castTime: minute(1),
    castType: ritual,
    duration: hour(8),
    range: cube(20, range: 30),
    components: "VSM"
  )[
    *Detect* intruder audibly~(60ft) or mentally~(1mile)
  ],

  spell(
    "Catapult",
    prep: preparing,
    school: transmutation,
    castTime: action,
    duration: instant,
    range: straightLine(90, range: 60),
    components: "V"
  )[
    DEX or *Bludg. 3d8*, you need an object 1-5lb to throw
    #atHigherLevels[+1d8,+5lb]
  ],
)

#pagebreak()

#dnd.page.spellsSection(
  spell(
    "Cure Wounds",
    prep: preparing,
    school: evocation,
    castTime: action,
    duration: instant,
    range: touch,
    components: "VS"
  )[
    *Heal 1d8* + INT
    #atHigherLevels[+1d8]
  ],

  spell(
    "Detect Magic",
    prep: preparing,
    school: evocation,
    castTime: action,
    castType: concentration + ritual,
    duration: instant,
    range: sphere(30),
    components: "VS"
  )[
    *Detect presence*, spend 1A to see auraaround object
    that bears magic and detect it's school
  ],

  spell(
    "Disguise Self",
    prep: preparing,
    school: abjuration,
    castTime: action,
    duration: hour(1),
    range: self,
    components: "VS"
  )[
    *Shapeshift*, #(sym.plus.minus)1ft height. Testing by *Investigation*
  ],

  spell(
    "Expeditious Retreat",
    prep: preparing,
    school: transmutation,
    castTime: bonusAction,
    castType: concentration,
    duration: minute(10),
    range: self,
    components: "VS"
  )[
    You can *Dash*
  ],

  spell(
    "Faerie Fire",
    prep: preparing,
    school: necromancy,
    castTime: action,
    castType: concentration,
    duration: minute(1),
    range: cube(20, range: 60),
    components: "V"
  )[
    DEX or *Advantage againts*, light 10ft, no invisibility
  ],

  spell(
    "False Life",
    prep: preparing,
    school: evocation,
    castTime: action,
    duration: hour(1),
    range: self,
    components: "VSM"
  )[
    Add *Temp. HP 1d4+4*
    #atHigherLevels[+5HP]
  ],

  spell(
    "Feather Fall",
    prep: preparing,
    school: transmutation,
    castTime: reaction,
    duration: minute(1),
    range: target(60),
    components: "VM"
  )[
    *Slow falling speed by 60ft*
  ],

  spell(
    "Grease",
    prep: preparing,
    school: conjuration,
    castTime: action,
    duration: minute(1),
    range: square(10, range: 60),
    components: "VSM"
  )[
    Create area, DEX or *Prone*
  ],

  spell(
    "Identify",
    prep: preparing,
    school: divination,
    castTime: minute(1),
    duration: instant,
    range: square(10, range: 60),
    components: "VSM"
  )[
    *Identify* items and spells.
    #required[pearl 100gp]
  ],

  spell(
    "Jump",
    prep: preparing,
    school: transmutation,
    castTime: action,
    duration: minute(1),
    range: touch,
    components: "VSM"
  )[
    *Jump* distance #sym.times 3
  ],

  spell(
    "Longstrider",
    prep: preparing,
    school: transmutation,
    castTime: action,
    duration: hour(1),
    range: touch,
    components: "VSM"
  )[
    *Speed* +10ft
    #atHigherLevels[+1 target]
  ],

  spell(
    "Purify Food and Drink",
    prep: preparing,
    school: transmutation,
    castTime: action,
    duration: instant,
    range: sphere(5, range: 10),
    components: "VS"
  )[
    *Clean poison and disease* in non-magical food
  ],

  spell(
    "Sanctuary",
    prep: preparing,
    school: abjuration,
    castTime: bonusAction,
    duration: minute(1),
    range: target(30),
    components: "VS"
  )[
    *Protection*, enemy: WIS or change target or skip
  ],

  spell(
    "Snare",
    prep: preparing,
    school: abjuration,
    castTime: minute(1),
    duration: hour(8),
    range: circle(5),
    components: "VSM"
  )[
    *Trap*, INT or *Entangled*
    #required[consume 25ft rope]
  ],

  spell(
    "Tasha's Caustic Brew",
    prep: preparing,
    school: conjuration,
    castTime: action,
    castType: concentration + ritual,
    duration: minute(1),
    range: straightLine([30x5]),
    components: "VSM"
  )[
    DEX or *Acid 2d4* each start,
    target can spend 1A to clean
    #atHigherLevels[+2d4]
  ],
)
