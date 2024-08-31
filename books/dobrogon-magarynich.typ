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

#page(
  header: section[Spellcasting]
)[
  #dnd.page.spellcasting(dobrogon)

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
  )
]

#page[
  #dnd.page.spellsSection(
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
]

#page[
  #dnd.page.spellsSection(
    level: spellLevel(2, slots: 2),

    spell(
      "Aid",
      prep: preparing,
      school: abjuration,
      castTime: action,
      duration: hour(8),
      range: target(30, count: 3),
      components: "VSM"
    )[
      *Max/Cur HP +5*
      #atHigherLevels[+5HP]
    ],

    spell(
      "Aid",
      prep: preparing,
      school: abjuration,
      castTime: action,
      duration: hour(8),
      range: target(30),
      components: "VSM"
    )[
      *Max/Cur HP +5* for 3 creatures
      #atHigherLevels[+5HP]
    ],

    spell(
      "Air Bubble",
      prep: preparing,
      school: divination,
      castTime: action,
      duration: hour(24),
      range: target(60),
      components: "VSM"
    )[
      Allow 1 creature to *breath*
      #atHigherLevels[+2 target]
    ],

    spell(
      "Alter Self",
      prep: preparing,
      school: transmutation,
      castTime: action,
      castType: concentration,
      duration: hour(1),
      range: self,
      components: "VS"
    )[
      *Shapeshift*,
      - Aquatic - you can breath and sweam fast
      - Appearance - change except size and form
      - Weapon - Grow weapon, magic, *Bludg 1d6*
    ],

    spell(
      "Arcane Lock",
      prep: preparing,
      school: abjuration,
      castTime: action,
      duration: always,
      range: touch,
      components: "VSM"
    )[
      *Lock* a chest or passage.
      Open for people or password.
      Supressed by Knock. *Break +10DC*
      #required[consume gold dust 25gp]
    ],

    spell(
      "Blur",
      prep: preparing,
      school: evocation,
      castTime: action,
      castType: concentration,
      duration: minute(1),
      range: self,
      components: "V"
    )[
      *Attack disadvantage against*, if relies on eyesight
    ],

    spell(
      "Continual Flame",
      prep: preparing,
      school: necromancy,
      castTime: action,
      duration: always,
      range: touch,
      components: "VSM"
    )[
      *Infinite Light*
      #required[consume ruby dust 50gp]
    ],

    spell(
      "Darkvision",
      prep: preparing,
      school: transmutation,
      castTime: action,
      duration: minute(1),
      range: touch,
      components: "VSM"
    )[
      *Darkvision* for 60ft
    ],

    spell(
      "Enhance Ability",
      prep: preparing,
      school: conjuration,
      castTime: action,
      duration: hour(1),
      range: touch,
      components: "VSM"
    )[
      *Advantage for check* for selected stat, additionally
      - CON: +2d6 Temp HP.
      - STR: 2#(sym.times)Carrying Capacity
      - DEX: No fall damage  < 20ft
    ],

    spell(
      "Enlarge/Reduce",
      prep: preparing,
      school: divination,
      castTime: action,
      duration: minute(1),
      range: target(30),
      components: "VSM"
    )[
      CON or
      - Enlarge - Size#(sym.times)2, STR Adv., +1d4 attacks
      - Reduce - Size#(sym.times)0.5, STR Dis., -1d4 attacks
    ],

    spell(
      "Heat Metal",
      prep: preparing,
      school: transmutation,
      castTime: action,
      castType: concentration,
      duration: minute(1),
      range: target(60),
      components: "VSM"
    )[
      *On metal object*, any touch - *Fire 2d8*,
      CON to drop or *Disadv.*.
      Use BA to damage again
      #atHigherLevels[+2 targets]
    ],

    spell(
      "Invisibility",
      prep: preparing,
      school: illustion,
      castTime: action,
      castType: concentration,
      duration: hour(1),
      range: touch,
      components: "VSM"
    )[
      Become *Invisible*
    ],
  )
]

#page[
  #dnd.page.spellsSection(
    spell(
      "Kinetic Jaunt",
      prep: preparing,
      school: transmutation,
      castTime: bonusAction,
      castType: concentration,
      duration: minute(1),
      range: self,
      components: "VSM"
    )[
      *Speed +10ft*, *No provoking*, *You can go through creatures*,
      if you end up in creature - move away and take Force Field 1d8
    ],

    spell(
      "Lesser Restoration",
      prep: preparing,
      school: abjuration,
      castTime: action,
      duration: instant,
      range: touch,
      components: "VS"
    )[
      *Clean disease*, blind., deaf., paral. or poisoned
    ],

    spell(
      "Levitate",
      prep: preparing,
      school: transmutation,
      castTime: action,
      castType: concentration,
      duration: minute(10),
      range: [#target(60), \<500lb],
      components: "VSM"
    )[
      CON or *Levitate up to 20ft*, you can use Move
      to change self #(sym.plus.minus)20ft, or Action
      to move others
    ],

    spell(
      "Magic Mouth",
      prep: preparing,
      school: illustion,
      castTime: minute(1),
      castType: ritual,
      duration: always,
      range: point(60),
      components: "VSM"
    )[
      Implant a *voice message*, choose a trigger (max 30ft distance)
      #required[consume jade dust 10gp]
    ],

    spell(
      "Magic Weapon",
      prep: preparing,
      school: transmutation,
      castTime: bonusAction,
      castType: concentration,
      duration: hour(1),
      range: touch,
      components: "VS"
    )[
      Non magical weapon become magical
      *+1 to attack and damage rolls*
      #atHigherLevels[+2 bonus]
    ],

    spell(
      "Melf's Acid Arrow",
      prep: preparing,
      school: evocation,
      castTime: action,
      duration: instant,
      range: target(90),
      components: "VSM"
    )[
      Ranged,
      - on hit - *Acid 4d4* + *Acid 2d4* end of turn
      - on miss - *Acid 4d4* / 2
    ],

    spell(
      "Protection from Poison",
      prep: preparing,
      school: abjuration,
      castTime: action,
      duration: hour(1),
      range: touch,
      components: "VS"
    )[
      *Neutralize poisoning* (known or random)
      Target gain advantage agains being poisoned
    ],

    spell(
      "Pyrotechnichs",
      prep: preparing,
      school: transmutation,
      castTime: action,
      duration: instant,
      range: square(20, range: 60),
      components: "VS"
    )[
      Choose non-magical fire, distinguish and choose:
      - Smoke - covers 20ft area heavily obscure, lasts 1m, heavy wind ends it
      - Fireworks - 10ft range, CON or *Blinded*
    ],

    spell(
      "Rope Trick",
      prep: preparing,
      school: transmutation,
      castTime: action,
      duration: hour(1),
      range: touch,
      components: "VSM"
    )[
      Rope rises into the air and creates *extradimentional space*
      for up to 8 Medium creatures to *hide*.
      You can lift rope so it becomes invisible.
      Attacks or spells can't cross this space, but you can
      see what's outside
      #required[rope < 60ft]
    ],

    spell(
      "See Invisible",
      prep: preparing,
      school: illustion,
      castTime: action,
      duration: hour(1),
      range: self,
      components: "VSM"
    )[
      *See Invisible*, *See Ethereal Plane*
    ],

    spell(
      "Skywrite",
      prep: preparing,
      school: transmutation,
      castTime: action,
      castType: concentration + ritual,
      duration: hour(1),
      range: [Sight],
      components: "VS"
    )[
      *Write up to 10 words* in the sky.
      Heavy wind can end this spell early.
    ],

    spell(
      "Spider Climb",
      prep: preparing,
      school: transmutation,
      castTime: action,
      duration: hour(1),
      range: touch,
      components: "VSM"
    )[
      Allow target to *walk on walls and ceilings*
    ],
  )
]

#page[
  #dnd.page.spellsSection(

    spell(
      "Vortex Warp",
      prep: preparing,
      school: conjuration,
      castTime: action,
      duration: instant,
      range: target(90),
      components: "VSM"
    )[
      CON or be *Teleported*
      #atHigherLevels[+30ft]
    ],

    spell(
      "Web",
      prep: preparing,
      school: conjuration,
      castTime: action,
      castType: concentration,
      duration: hour(1),
      range: cube(20, range: 60),
      components: "VSM"
    )[
      Create web, which is *difficult terrain and lightly obscured*,
      Creaters end in web DEX or *Restrained*.
      Web is *flammable*, burn in 1r with *Fire 2d4*
    ],

    spell(
      "Flaming Sphere",
      prep: preparing,
      school: conjuration,
      castTime: action,
      castType: concentration,
      duration: minute(1),
      range: sphere(5, range: 60),
      components: "VSM"
    )[
      Creates sphere, create that ends its turn within 5ft of it
      DEX or *Fire 2d6*
      Bonus Action: Move to 30ft
    ],
  )
]
