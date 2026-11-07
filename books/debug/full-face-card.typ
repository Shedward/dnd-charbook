#import "/dnd/dnd.typ"
#show: dnd.core.charbook
#let bleed = float(sys.inputs.at("bleed-mm", default: "2")) * 1mm
#set page(width: 200mm / 3 + 2 * bleed, height: 287mm / 3 + 2 * bleed, margin: 0mm, fill: white)
#dnd.core.setLocale("ru")

#let id = sys.inputs.at("spell", default: "nondetection")
#let mode = sys.inputs.at("mode", default: "mask")
#let entry = dnd.data.spellbook().find(s => s.id == id)
#assert(entry != none, message: "Unknown spell: " + id)
#let base = dnd.page.spellFromSpellbook(entry)
#let plate = dnd.core.spellPlate(base, dnd.core.defaultIllustrationSet)
#let scale = float(sys.inputs.at("body-scale", default: str(if plate == none { 1 } else { plate.at("body-scale", default: 1) })))
#let spell = (..base, level: entry.level, body: text(size: scale * 1em, base.body))
#if mode == "front" {
  if "art" in sys.inputs {
    dnd.page.spellCardFullFace(spell, sys.inputs.art, bleed: bleed, scheme: json(bytes(sys.inputs.at("color-scheme", default: "{}"))))
  } else {
    assert(plate != none, message: "No plate for " + id + " in the selected set")
    dnd.page.spellCardFullFace(spell, plate.path, bleed: bleed, artBleed: 2mm,
      textEnd: plate.at("text-end", default: none), scheme: plate.at("color-scheme", default: (:)))
  }
} else {
  assert(mode in ("mask", "overlay"), message: "Expected mask, overlay or front")
  dnd.page.spellCardArtMask(
    spell,
    color: rgb(sys.inputs.at("color", default: "#ff1818")),
    ornamentGuide: sys.inputs.at("ornament-guide", default: "on") == "on",
    transitionWidth: float(sys.inputs.at("band-mm", default: "2")) * 1mm,
    transitionColor: rgb(sys.inputs.at("transition-color", default: "#ffd279")),
    overlay: mode == "overlay",
    bleed: bleed,
  )
}
