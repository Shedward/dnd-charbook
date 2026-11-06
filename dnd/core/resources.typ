#let icon(name, ..args) = {
    let resolvedArgs = if (args.named().len() == 0) {
      (height: 0.85em, baseline: 0.15em)
    } else {
      args
    }

    box(image("/resources/icons/" + name + ".svg"), ..resolvedArgs)
  }

