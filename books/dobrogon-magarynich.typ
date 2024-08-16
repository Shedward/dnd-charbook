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

#dnd.page.spells(
  spell(
    prep: alwaysPrepared,
    name: "Mending",
    school: "Transmutation",
    castTime: minute(1),
    duration: instant,
    range: touch,
    components: components("VSM")
  )[
    *Repair* small tear or *Heal self HD(1d8) + CON* (min 1)
  ],
  spell(
    prep: alwaysPrepared,
    name: "Create Bonfire",
    school: "Conjuration",
    castType: concentration,
    duration: minute(1),
    range: cube(5, range: 60),
    components: components("VS")
  )[
    Create area, DEX or *Fire 2d8* on enter or stay
  ],
  spell(
    prep: alwaysPrepared,
    name: "Fire Bolt",
    school: "Evocation",
    duration: instant,
    range: target(120),
    components: components("VS")
  )[
    Ranged, *Frost 2d8, Slow 10ft*
  ],
  spell(
    prep: alwaysPrepared,
    name: "Ray of Frost",
    school: "Evocation",
    duration: instant,
    range: target(60),
    components: components("VS")
  )[
    Ranged, *Frost 2d8 + Slow 10ft*
  ]
)
