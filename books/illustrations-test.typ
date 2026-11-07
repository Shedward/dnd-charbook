#import "../dnd/dnd.typ"

#show: dnd.core.charbook
#set page(width: auto, height: auto, margin: 5mm)
#dnd.core.setLocale("ru")

#let sampleIds = (
  "scrying", "ottos-irresistible-dance",
  "mordenkainens-magnificent-mansion", "spirit-shroud",
  "prismatic-spray", "dominate-beast",
  "knock", "fabricate",
  "nondetection", "acid-splash",
  "wrathful-smite", "insect-plague",
  "silence", "heat-metal",
  "water-walk", "arcane-lock",
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
#let bleed = 2mm
#let mark = 3mm
#let gutter = 1mm
#let plateWidth = width + 2 * bleed
#let plateHeight = height + 2 * bleed
#let front(spell, setName) = {
  let pen = 0.25pt + gray
  let offset = mark + gutter
  block(width: plateWidth + 2 * offset, height: plateHeight + 2 * offset)[
    #place(top + left, dx: offset, dy: offset,
      block(width: plateWidth, height: plateHeight,
        dnd.page.spellCardFront(spell, illustrationSet: setName, bleed: bleed)))
    #let veil = white.transparentize(34%)
    #for y in (offset, offset + bleed + height) {
      place(top + left, dx: offset, dy: y,
        rect(width: plateWidth, height: bleed, fill: veil, stroke: none))
    }
    #for x in (offset, offset + bleed + width) {
      place(top + left, dx: x, dy: offset + bleed,
        rect(width: bleed, height: height, fill: veil, stroke: none))
    }
    #place(top + left, dx: offset + bleed, dy: offset + bleed,
      rect(width: width, height: height, fill: none, stroke: 0.3pt + rgb("#aaaaaa")))
    #for x in (offset + bleed, offset + bleed + width) {
      for y in (0mm, offset + plateHeight + gutter) {
        place(top + left, dx: x, dy: y, line(length: mark, angle: 90deg, stroke: pen))
      }
    }
    #for y in (offset + bleed, offset + bleed + height) {
      for x in (0mm, offset + plateWidth + gutter) {
        place(top + left, dx: x, dy: y, line(length: mark, stroke: pen))
      }
    }
  ]
}

// Keep all styles of one spell on a single sheet at the deck's trim size.
#for spell in sample {
  pagebreak(weak: true)
  grid(
    columns: (plateWidth + 2 * (mark + gutter),) * sets.len(),
    column-gutter: 3mm,
    row-gutter: 2mm,
    ..sets.map(name => align(center, text(size: 8pt, name))),
    ..sets.map(name => front(spell, name)),
  )
}
