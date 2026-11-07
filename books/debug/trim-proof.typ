#import "/dnd/dnd.typ"

#show: dnd.core.charbook
#set page(width: auto, height: auto, margin: 3mm)
#dnd.core.setLocale("ru")

#let id = sys.inputs.at("spell", default: "scrying")
#let setName = sys.inputs.at("illustration-set", default: "woodcut-frames")
#let entry = dnd.data.spellbook().find(s => s.id == id)
#assert(entry != none, message: "Unknown spell: " + id)
#let spell = (..dnd.page.spellFromSpellbook(entry), level: entry.level)
#assert(dnd.core.spellPlate(spell, setName) != none, message: "No plate for " + id + " in " + setName)

#let width = 200mm / 3
#let height = 287mm / 3
#let bleed = 2mm
#let sheet = block(width: width + 2 * bleed, height: height + 2 * bleed,
  dnd.page.spellCardFront(spell, illustrationSet: setName, bleed: bleed))
#let crop(dx, dy) = block(width: width, height: height, clip: true,
  place(top + left, dx: -bleed - dx, dy: -bleed - dy, sheet))

#grid(columns: (width, width), gutter: 2mm,
  ..(-bleed, bleed).map(dy => (-bleed, bleed).map(dx => stack(
    dir: ttb, spacing: 1mm,
    align(center, text(size: 8pt)[#if dx < 0mm [← 2 мм] else [→ 2 мм] · #if dy < 0mm [↑ 2 мм] else [↓ 2 мм]]),
    crop(dx, dy),
  ))).flatten())
