#import "../dnd/dnd.typ"

#dnd.core.setLocale("ru")
#let catalogue = dnd.data.spellbook()
#let sample = (
  "invulnerability", "stinking-cloud", "teleport",
  "jump", "alarm", "prismatic-wall",
).map(id => {
  let entry = catalogue.find(spell => spell.id == id)
  (..dnd.page.spellFromSpellbook(entry), level: entry.level)
})
#dnd.page.deck(sample, (33.33%, 33.33%), dnd.page.spellCard,
  stroke: (paint: silver, thickness: 0.2mm, dash: "dashed"))
