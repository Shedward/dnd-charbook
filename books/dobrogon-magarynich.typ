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
