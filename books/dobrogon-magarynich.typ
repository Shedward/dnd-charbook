#import "../dnd/dnd.typ"

#show: dnd.core.charbook

#let dobrogon = dnd.core.character(
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
