
// Dimentions constants for template
#let strokes = (
  thin: 0.5pt,
  normal: 1.0pt
)

// Normalized paddings
#let paddings(p) = p * 2mm

#let container(
  fitting: "shrink",
  padding: paddings(1),
  background: (size) => rect(width: size.width, height: size.height),
  body
) = context {
  let bodyWithPadding = if padding > 0pt [
    #pad(padding)[#body]
  ] else [
    #body
  ]

  layout(size => {
    let size = if fitting == "expand" {
      size
    } else if fitting == "shrink" {
      measure(bodyWithPadding)
    } else {
      panic("fitting " + fitting + " is not supported, expected: expand|shrink")
    }

    [
      #block()[
        #background(size)
        #place(center + horizon)[
          #bodyWithPadding
        ]
      ]
    ]
  })
}

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

// Container wrappend in frame.
// Parameters:
// - stroke: Stroke width
#let framed(
  stroke: strokes.thin,
  radius: paddings(1) - 0.1 * paddings(1),
  padding: paddings(1),
  fitting: "shrink",
  body
) = container(
  fitting: fitting,
  padding: padding,
  background: size => frame(
    width: size.width,
    height: size.height,
    stroke: stroke,
    radius: radius
  ),
  body
)
