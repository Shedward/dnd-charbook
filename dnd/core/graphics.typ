#import "dimentions.typ": *

// Renders rectangle with corners rounded inside
// Parameters:
// - width: Outer width of frame
// - height: Outer height of frame
// - stroke: Stroke width, use values from dimenstions.stroke
// - radius: Inner radius of frame
#let frame(
  width: 100%,
  height: 100%,
  stroke: strokes.thin,
  fill: none,
  radius: paddings(1) - 0.1 * paddings(1)
) = {
  let z = 0pt
  let r = radius
  let hr = 0.5 * radius
  let w = width - 2.0 * r
  let h = height - 2.0 * r
  curve(
    stroke: stroke,
    fill: fill,
    // ---
    curve.move((radius, 0pt)),
    curve.cubic((z, hr), (-hr, r), (-r, r), relative: true),
    curve.line((z, h), relative: true),
    curve.cubic((hr, z), (r, hr), (r, r), relative: true),
    curve.line((w, z), relative: true),
    curve.cubic((z, -hr), (hr, -r), (r, -r), relative: true),
    curve.line((z, -h), relative: true),
    curve.cubic((-hr, z), (-r, -hr), (-r, -r), relative: true),
    curve.close(mode: "straight")
  )
}

#let heart(width: 100%, height: 100%, stroke: strokes.thin, fill: none) = {
  let xCenter = 0.5 * width
  let yTopRuler = 0.1 * height
  let yBottomRuler = 0.75 * height
  let xLeftRuler = 0.1 * width
  let xRightRuler = width - xLeftRuler

  let topHanger = 0.125 * height
  let bottomHanger = topHanger


  path(
    closed: true,
    stroke: stroke,
    fill: none,
    // ---
    ((xCenter, width), (topHanger, -topHanger), (-topHanger, -topHanger)),
    ((xLeftRuler, yBottomRuler), (bottomHanger, bottomHanger)),
    ((xLeftRuler, yTopRuler), (-topHanger, topHanger)),
    ((xCenter, yTopRuler), (-topHanger, -topHanger), (topHanger, -topHanger)),
    ((xRightRuler, yTopRuler), (-topHanger, -topHanger)),
    ((xRightRuler, yBottomRuler), (bottomHanger, -bottomHanger))
  )
}


#let shield(width: 100%, height: 100%, stroke: strokes.thin, fill: none) = {
  let xCenter = 0.5 * width
  let leftRuller = 0pt
  let rightRuller = width

  let topRuller = 0pt
  let yCenter = 0.66 * height
  let bottomRuller = height

  let topAnchorPadding = 0.10 * height
  let topAnchorSidePadding = 0.33 * width
  let topLeftAnchor = (leftRuller + topAnchorSidePadding, topAnchorPadding + topRuller)
  let topRightAnchor = (rightRuller - topAnchorSidePadding, topAnchorPadding + topRuller)

  let bottomAnchorRuller = 0.80 * height
  let bottomLeftAnchor = (0pt, bottomAnchorRuller)
  let bottomRightAnchor = (width, bottomAnchorRuller)

  curve(
    fill: fill,
    stroke: stroke,
    // ---
    curve.move((xCenter, topRuller)),
    curve.cubic(topRightAnchor, topRightAnchor, (rightRuller, topRuller)),
    curve.cubic(bottomRightAnchor, bottomRightAnchor, (xCenter, bottomRuller)),
    curve.cubic(bottomLeftAnchor, bottomLeftAnchor, (leftRuller, topRuller)),
    curve.cubic(topLeftAnchor, topLeftAnchor, (xCenter, topRuller)),
    curve.close(mode: "straight")
  )
}

#let rhombus(
  width: 100%,
  stroke: strokes.thin,
  fill: none
) = {
  let h = 0.5 * width
  curve(
    stroke: stroke,
    fill: fill,
    // ---
    curve.move((h, 0pt)),
    curve.line((width, h)),
    curve.line((h, width)),
    curve.line((0pt, h)),
    curve.close()
  )
}

#let checkboxes(count, size: 4mm, padding: 25%, shape: rhombus) = if (count == 1) {
  shape(width: size, stroke: strokes.normal)
} else {
  grid(
    columns: (auto,) * count,
    column-gutter: padding * size,
    ..((shape(width: size, stroke: strokes.normal),) * count)
  )
}
