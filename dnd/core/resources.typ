#let icon(name, ..args) = {
    let resolvedArgs = if (args.named().len() == 0) {
      (height: 0.85em, baseline: 0.15em)
    } else {
      args
    }

    let path = "/resources/icons/" + name + ".svg"
    context {
      let ink = text.fill
      if type(ink) == color and ink != black {
        let svg = read(path).replace("#000000", ink.to-hex())
        box(image(bytes(svg), format: "svg"), ..resolvedArgs)
      } else {
        box(image(path), ..resolvedArgs)
      }
    }
  }

#let defaultIllustrationSet = sys.inputs.at("illustration-set", default: "none")

#let spellPlate(spell, setName) = {
  if setName == none or setName == "none" { return none }
  let directory = "/resources/illustrations/" + setName + "/"
  let id = spell.at("id", default: none)
  let entries = json(directory + "index.json")
  if type(id) == str and id in entries { (..entries.at(id), path: directory + id + ".png") }
}

// A book uses the pixel window recorded when the vignette was placed on its plate.
#let bookSpellIllustration(spell) = {
  let plate = spellPlate(spell, sys.inputs.at("book-illustration-set", default: "none"))
  if plate == none or "crop" not in plate { return none }
  let (x, y, w, h) = plate.crop
  layout(size => {
    let width = calc.min(size.width, 48.58mm)
    let plateWidth = width / w
    let plateHeight = plateWidth * ((287mm / 3 + 4mm) / (200mm / 3 + 4mm))
    align(center, block(width: width, height: h * plateHeight, clip: true,
      place(top + left, dx: -x * plateWidth, dy: -y * plateHeight,
        image(plate.path, width: plateWidth, height: plateHeight, fit: "stretch", alt: none))))
  })
}
