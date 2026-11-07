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
#let previewStyle = if "face-style" in sys.inputs { json(sys.inputs.face-style) } else { (:) }
#let family = previewStyle.at("font", default: if plate != none { plate.at("font", default: none) })
#let scheme = previewStyle.at("color-scheme", default: (:)) + (if plate != none { plate.at("color-scheme", default: (:)) } else { (:) }) + json(bytes(sys.inputs.at("color-scheme", default: "{}")))
#let scale = float(sys.inputs.at("body-scale", default: str(if plate == none { 1 } else { plate.at("body-scale", default: 1) })))
#let spell = dnd.page.spellPlateTypography((..base, level: entry.level), (if plate == none { (:) } else { plate }) + previewStyle, scale)
#if mode == "front" {
  if "art" in sys.inputs {
    dnd.page.spellCardFullFace(spell, sys.inputs.art, bleed: bleed, family: family, scheme: scheme)
  } else {
    assert(plate != none, message: "No plate for " + id + " in the selected set")
    dnd.page.spellCardFullFace(spell, plate.path, bleed: bleed, artBleed: 2mm,
      textEnd: plate.at("text-end", default: none), scheme: scheme, family: family)
  }
} else {
  assert(mode in ("mask", "overlay"), message: "Expected mask, overlay or front")
  dnd.page.spellCardArtMask(
    spell,
    family: family, scheme: scheme,
    color: rgb(sys.inputs.at("color", default: "#ff1818")),
    ornamentGuide: sys.inputs.at("ornament-guide", default: "on") == "on",
    transitionWidth: float(sys.inputs.at("band-mm", default: "2")) * 1mm,
    transitionColor: rgb(sys.inputs.at("transition-color", default: "#ffd279")),
    overlay: mode == "overlay",
    bleed: bleed,
  )
}
