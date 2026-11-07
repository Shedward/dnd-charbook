#import "../core/core.typ": *
#import "../core/layout.typ": *

#let spellCardLayout(body, outline: false) = framed(
  fitting: expand,
  insets: paddings(2),
  alignment: center + top,
  stroke: strokes.thin + (if outline { black } else { colors.secondary }),
  body,
)

#let spellCardChip(content, alignment: center + horizon) = box(
  width: 100%,
  inset: paddings(0.5),
  align(alignment, if content != none {
    text(font: fonts.header, size: 9pt, smallcaps(content))
  })
)

#let _divider(ink) = line(
  angle: 90deg,
  length: paddings(1),
  stroke: strokes.hairline + ink,
)

#let spellCardDivider = _divider(colors.secondary)

#let _sectionDivider(ink) = {
  let segment = line(length: 100%, stroke: strokes.thin + ink)
  grid(
    columns: (1fr, auto, 1fr),
    align: horizon,
    column-gutter: paddings(0.5),
    segment,
    rhombus(width: 1.5mm, stroke: strokes.thin + ink, fill: ink),
    segment,
  )
}

#let spellCardSectionDivider = _sectionDivider(colors.secondary)

#let spellCardLevelBadge(level) = {
  let label = if level == none {
    []
  } else if level == 0 {
    sym.infinity
  } else {
    roman(level)
  }
  text(font: fonts.ability, size: 18pt, label)
}

#let spellCardResources(spell, divider: spellCardDivider) = pad(x: -paddings(2), grid(
  columns: (1fr, auto, 1fr, auto, 2fr),
  align: center + horizon,
  spellCardChip(spell.components),
  divider,
  spellCardChip(spell.castTime),
  spellCardLevelBadge(spell.at("level", default: none)),
  spellCardChip(spell.castType),
))

#let spellCardTarget(spell, divider: spellCardDivider) = grid(
  columns: (1fr, auto, 1fr),
  align: center + horizon,
  spellCardChip(spell.range),
  divider,
  spellCardChip(spell.duration),
)

// Keep DSL elements (icons, formulas, contextual translations) intact when
// shortening the rich body. Plain text can break at word boundaries.
#let _bodyParts(body) = {
  if body.has("children") {
    body.children.map(_bodyParts).flatten()
  } else if body.func() == text and body.has("text") {
    body.text.matches(regex("\\S+|\\s+")).map(m => [#m.text])
  } else if body.func() == strong or body.func() == emph {
    _bodyParts(body.body).map(part => (body.func())(part))
  } else {
    (body,)
  }
}

#let _fitBodyText(spell, width, height, scale: 1) = {
  let body = spell.body
  let render(value) = align(left, par(justify: true, text(size: scale * 1em, value)))
  let fits(value) = measure(box(width: width, render(value))).height <= height
  if fits(body) { return render(body) }
  let clipped = [#metadata((id: spell.at("id", default: none), name: spell.name)) <clipped-spell-front>]
  if not fits([…]) { return clipped }

  let parts = _bodyParts(body)
  let prefix(n) = [#parts.slice(0, n).join()…]
  let lo = 0
  let hi = parts.len()
  while lo < hi {
    let mid = calc.div-euclid(lo + hi + 1, 2)
    if fits(prefix(mid)) { lo = mid } else { hi = mid - 1 }
  }
  clipped + render(prefix(lo))
}

#let _ink(body, scheme, role) = if role in scheme { text(fill: rgb(scheme.at(role)), body) } else { body }

#let _frontHeader(spell, title, scheme: (:)) = {
  let ink = if "divider" in scheme { rgb(scheme.divider) } else { colors.secondary }
  let divider = _divider(ink)
  (
    _ink(spellCardResources(spell, divider: divider), scheme, "stats"),
    spellCardTitle(_ink(title, scheme, "title")),
    _sectionDivider(ink),
    _ink(spellCardTarget(spell, divider: divider), scheme, "stats"),
  )
}

#let _plainFront(spell) = spellCardLayout(
  outline: true,
  block(width: 100%, height: 100%, vstack(
    size: (auto, auto, auto, auto, 1fr),
    spacing: (paddings(1.5), paddings(1.5), paddings(1.5), paddings(2)),
    .._frontHeader(spell, spell.name),
    layout(size => context _fitBodyText(spell, size.width, size.height)),
  ))
)

// Follow the text reserve, including the notches at the top and divider.
#let _contentFill(width, height, divider, radius, paint) = {
  let r = radius
  let k = 0.552285 * r
  curve(fill: paint, stroke: none,
    curve.move((r, 0pt)), curve.line((width - r, 0pt)),
    curve.cubic((width - r, k), (width - k, r), (width, r)),
    curve.line((width, divider - r)),
    curve.cubic((width - k, divider - r), (width - r, divider - k), (width - r, divider)),
    curve.cubic((width - r, divider + k), (width - k, divider + r), (width, divider + r)),
    curve.line((width, height)), curve.line((0pt, height)), curve.line((0pt, divider + r)),
    curve.cubic((k, divider + r), (r, divider + k), (r, divider)),
    curve.cubic((r, divider - k), (k, divider - r), (0pt, divider - r)),
    curve.line((0pt, r)), curve.cubic((k, r), (r, k), (r, 0pt)), curve.close())
}

// Full-face fronts use the whole cut card, including the deck's usual outer padding.
// The guide and the finished front measure exactly the same typeset content.
#let _fullFace(spell, guide: none, ornamentGuide: false, showText: true, textEnd: none, scheme: (:), margin: 5mm, artClearance: 3mm, transitionWidth: 2mm, transitionColor: rgb("#ffd279")) = layout(size => context {
  let inset = paddings(2)
  let panelWidth = size.width - 2 * margin
  let width = panelWidth - 2 * inset
  let gutter = paddings(1.5)
  assert(margin >= 0pt and width > 0pt, message: "Full-face margin must leave space for text")
  let header = _frontHeader(spell, spell.name, scheme: scheme)
  let stack(items, gaps) = grid(columns: (width,), align: center + top,
    row-gutter: gaps, ..items)
  let heading = stack(header, gutter)
  let heightOf(item) = measure(box(width: width, item)).height
  let headerHeight = heightOf(heading)
  let bodySpace = size.height - 2 * (margin + inset) - headerHeight - paddings(2)
  assert(bodySpace > 0pt, message: "Full-face card is too small for the heading")
  let available = bodySpace
  let scale = 1
  if textEnd != none {
    available = calc.min(bodySpace, textEnd * (size.height + 4mm) - 2mm - 2mm
      - (margin + inset + headerHeight + paddings(2)))
    available = calc.max(0pt, available)
    while scale > 0.78 and heightOf(par(justify: true, text(size: scale * 1em, spell.body))) > available {
      scale = calc.max(0.78, scale - 0.025)
    }
  }
  let body = _ink(_fitBodyText(spell, width, available, scale: scale), scheme, "rules")
  let content = stack((heading, body), paddings(2))
  block(width: size.width, height: size.height, clip: true)[
    #if guide != none or "content-fill" in scheme {
      assert(artClearance >= 0pt, message: "Art clearance must be nonnegative")
      let panelHeight = calc.min(size.height - margin, 2 * inset + heightOf(content) + artClearance)
      let radius = paddings(1)
      let dividerY = margin + inset + heightOf(stack(header.slice(0, 2), gutter)) + gutter + heightOf(header.at(2)) / 2

      if guide == none {
        place(top + left, dx: margin, dy: margin,
          _contentFill(panelWidth, panelHeight, dividerY - margin, radius, rgb(scheme.at("content-fill"))))
      } else {
        assert(transitionWidth >= 0pt, message: "Transition width must be nonnegative")
        // Expand outward so the transition never consumes the white text reserve.
        place(top + left, dx: margin - transitionWidth, dy: margin - transitionWidth,
          rect(width: panelWidth + 2 * transitionWidth, height: panelHeight + 2 * transitionWidth,
            fill: transitionColor, stroke: none))
        place(top + left, dx: margin, dy: margin,
          rect(width: panelWidth, height: panelHeight, fill: white, stroke: none))
        for x in (margin, size.width - margin) {
          for y in (margin, dividerY) {
            place(top + left, dx: x - radius, dy: y - radius, circle(radius: radius, fill: transitionColor, stroke: none))
            if transitionWidth < radius {
              let r = radius - transitionWidth
              place(top + left, dx: x - r, dy: y - r, circle(radius: r, fill: guide, stroke: none))
            }
          }
        }
      }
      if guide != none and ornamentGuide and margin >= 3mm {
        let offset = calc.min(4mm, margin - 0.75mm)
        let pen = (paint: rgb("#7025ad"), thickness: 0.32mm, dash: "dashed")
        let topLength = calc.min(8mm, panelWidth / 3)
        place(top + left, dx: (size.width - topLength) / 2, dy: offset,
          line(length: topLength, stroke: pen))
        // Follow the height of this spell's text, leaving the lower scene open.
        let sideTop = dividerY + radius + 1mm
        let sideSpace = margin + panelHeight - sideTop
        if sideSpace > 4mm {
          let length = calc.min(18mm, sideSpace * 0.55)
          for x in (offset, size.width - offset) {
            place(top + left, dx: x, dy: sideTop + (sideSpace - length) / 2,
              line(length: length, angle: 90deg, stroke: pen))
          }
        }
      }
    }
    #place(top + left, dx: margin + inset, dy: margin + inset,
      box(width: width, if showText { content } else { hide(content) }))
  ]
})

// A bleed export receives the sheet size. The inner card keeps its original
// measure so line breaks and the protected text area match the trimmed deck.
#let _fullFaceSheet(card, bleed: 0mm, guide: none, art: none, artBleed: auto) = layout(size => {
  let artBleed = if artBleed == auto { bleed } else { artBleed }
  assert(bleed >= 0mm and artBleed >= bleed)
  let w = size.width - 2 * bleed
  let h = size.height - 2 * bleed
  block(width: size.width, height: size.height, clip: true)[
    #if guide != none {
      place(top + left, rect(width: size.width, height: size.height, fill: guide, stroke: none))
    } else if art != none {
      place(top + left, dx: bleed - artBleed, dy: bleed - artBleed,
        image(art, width: w + 2 * artBleed, height: h + 2 * artBleed, fit: "stretch", alt: none))
    }
    #place(top + left, dx: bleed, dy: bleed, block(width: w, height: h, card))
    #if guide != none and bleed > 0mm {
      for (inset, dash) in ((bleed, "dashed"), (bleed + 2mm, "dotted")) {
        place(top + left, dx: inset, dy: inset, rect(width: size.width - 2 * inset,
          height: size.height - 2 * inset, stroke: (paint: rgb("#184461"), thickness: 0.28mm, dash: dash)))
      }
    }
  ]
})

#let spellCardArtMask(spell, color: red, overlay: false, margin: 5mm, artClearance: 3mm,
  transitionWidth: 2mm, transitionColor: rgb("#ffd279"), bleed: 0mm, ornamentGuide: true) = _fullFaceSheet(
  bleed: bleed,
  guide: color,
  _fullFace(spell, guide: color, showText: overlay, ornamentGuide: ornamentGuide,
    margin: margin, artClearance: artClearance,
    transitionWidth: transitionWidth, transitionColor: transitionColor),
)

#let spellCardFullFace(spell, art, margin: 5mm, bleed: 0mm, artBleed: auto, textEnd: none, titleColor: none, scheme: (:)) = _fullFaceSheet(
  bleed: bleed, art: art, artBleed: artBleed,
  _fullFace(spell, margin: margin, textEnd: textEnd, scheme: (if titleColor == none { (:) } else { (title: titleColor) }) + scheme),
)

#let _tightenDescription(s) = s.replace(
  regex("([^.!?:\n])\n+"),
  m => m.captures.at(0) + " ",
)

#let _renderDescription(s) = par(
  justify: true,
  spellCardDescription(_tightenDescription(s)),
)

#let _fitDescription(rawText) = layout(size => context {
  let full = _renderDescription(rawText)
  if measure(box(width: size.width, full)).height <= size.height {
    return align(left, full)
  }

  let clusters = rawText.clusters()
  let n = clusters.len()
  let lo = 0
  let hi = n
  while lo < hi {
    let mid = calc.div-euclid(lo + hi + 1, 2)
    let candidate = _renderDescription(
      clusters.slice(0, mid).join("") + "…"
    )
    let fits = measure(box(width: size.width, candidate)).height <= size.height
    if fits { lo = mid } else { hi = mid - 1 }
  }

  let i = lo
  while i > 0 and clusters.at(i - 1) != " " and clusters.at(i - 1) != "\n" {
    i = i - 1
  }
  let prefix = clusters.slice(0, i).join("").trim()
  align(left, _renderDescription(prefix + "…"))
})

#let spellCardBack(spell) = {
  let original = spell.at("originalName", default: none)
  let title = if original != none and original != spell.name [
    *#spell.name* #text(size: 0.8em)[(#original)]
  ] else [
    *#spell.name*
  ]
  spellCardLayout(block(width: 100%, height: 100%, grid(
    columns: 1fr,
    rows: (auto, 1fr, auto),
    row-gutter: paddings(1.5),
    align(left, spellCardDescriptionTitle(title)),
    _fitDescription(spell.description),
    align(right, spellCaption(spell.school)),
  )))
}

#let _plateFront(spell, plate) = {
  if plate == none { return _plainFront(spell) }
  let scale = plate.at("body-scale", default: 1)
  spellCardFullFace((..spell, body: text(size: scale * 1em, spell.body)), plate.path,
    artBleed: 2mm, textEnd: plate.at("text-end", default: none), scheme: plate.at("color-scheme", default: (:)))
}

#let spellCardFront(spell, illustrationSet: defaultIllustrationSet) = _plateFront(spell, spellPlate(spell, illustrationSet))

#let spellCard(spell, illustrationSet: defaultIllustrationSet) = {
  let plate = spellPlate(spell, illustrationSet)
  (front: _plateFront(spell, plate), back: spellCardBack(spell), fullFront: plate != none)
}
