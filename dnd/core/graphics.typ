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
) = path(
  closed: true,
  stroke: stroke,
  fill: fill,
  // ---
  (radius, 0pt),
  ((width - radius, 0pt), (0pt, 0pt), (0pt, 0.5 * radius)),
  ((width, radius), (-0.5 * radius, 0pt), (0pt, 0pt)),
  ((width, height - radius), (0pt, 0pt), (-0.5 * radius, 0pt)),
  ((width - radius, height), (0pt, -0.5 * radius), (0pt, 0pt)),
  ((radius, height), (0pt, 0pt), (0pt, -0.5 * radius)),
  ((0pt, height - radius), (0.5 * radius, 0pt), (0pt, 0pt)),
  ((0pt, radius), (0pt, 0pt), (0.5 * radius, 0pt)),
  ((radius, 0pt), (0pt, 0.5 * radius), (0pt, 0pt))
)

#let heart(width: 100%, height: 100%, stroke: strokes.thin, fill: none) = {
  let xCenter = 0.5 * width
  let yTopRuler = 0.1 * height
  let topHanger = 0.125 * height
  let bottomHanger = topHanger
  let yBottomRuler = 0.75 * height
  let xLeftRuler = 0.1 * width
  let xRightRuler = width - xLeftRuler

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
  let yTopRuler = 0pt
  let topHanger = 0.125 * height
  let bottomHanger = topHanger
  let yBottomRuler = 0.75 * height
  let xLeftRuler = 0.055 * width
  let xRightRuler = width - xLeftRuler

  path(
    closed: true,
    stroke: stroke,
    fill: fill,
    // ---
    ((xCenter, width), (topHanger, -topHanger), (-topHanger, -topHanger)),
    ((xLeftRuler, yBottomRuler), (bottomHanger, bottomHanger)),

    (xLeftRuler, yTopRuler),
    ((xCenter, yTopRuler), (-topHanger, topHanger), (topHanger, topHanger)),
    (xRightRuler, yTopRuler),

    ((xRightRuler, yBottomRuler), (bottomHanger, -bottomHanger))
  )
}

#let rhombus(
  width: 100%,
  stroke: strokes.thin,
  fill: none
) = {
  let h = 0.5 * width
  path(
    closed: true,
    stroke: stroke,
    fill: fill,
    // ---
    (h, 0pt), (width, h), (h, width), (0pt, h)
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
