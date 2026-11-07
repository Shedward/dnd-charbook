#import "../dnd/dnd.typ"

#show: dnd.core.charbook
#set page(paper: "a5", margin: 4mm)
#dnd.core.setLocale("ru")

#let sampleIds = (
  "scrying", "ottos-irresistible-dance",
  "mordenkainens-magnificent-mansion", "spirit-shroud",
  "prismatic-spray", "dominate-beast",
  "knock", "fabricate",
  "nondetection", "acid-splash",
  "wrathful-smite", "insect-plague",
)
#let catalogue = dnd.data.spellbook()
#let sample = sampleIds.map(id => {
  let entry = catalogue.find(spell => spell.id == id)
  assert(entry != none, message: "Unknown spell in illustration sample: " + id)
  (..dnd.page.spellFromSpellbook(entry), level: entry.level)
})
#let sets = json("/resources/illustrations/sets.json")
#let width = 200mm / 3
#let height = 287mm / 3
#let front(spell, setName) = {
  let card = dnd.page.spellCard(spell, illustrationSet: setName)
  block(width: width, height: height, clip: true,
    if card.fullFront { card.front } else { pad(5mm, card.front) })
}

// Each row compares one spell across sets at the deck's actual trim size.
#for spells in sample.chunks(2) {
  for columns in sets.chunks(2) {
    pagebreak(weak: true)
    align(center, grid(
      columns: (width,) * columns.len(),
      column-gutter: 3mm,
      row-gutter: 2mm,
      ..columns.map(name => align(center, text(size: 8pt, name))),
      ..spells.map(spell => columns.map(name => front(spell, name))).flatten(),
    ))
  }
}
