#import "dimentions.typ": *

// Renders rectangle with corners rounded inside
// Parameters:
// - width: Outer width of frame
// - height: Outer height of frame
// - stoke: Stroke width, use values from dimenstions.stroke
// - radius: Inner radius of frame
#let frame(
  width: 100%,
  height: 100%,
  stroke: strokes.thin,
  radius: paddings(1) - 0.1 * paddings(1)
) = [
  #path(
    closed: true,
    stroke: stroke,

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
]
