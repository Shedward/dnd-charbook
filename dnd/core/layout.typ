#import "dimentions.typ": *
#import "graphics.typ": *
#import "styles.typ": *

// Set of available fittings

// Container shrink around container
#let shrink = "shrink"
// Content expand to all available space
#let expand = "expand"
// Content expand horizontally, but shrink vertically
#let expand-h = "expand-h"
// Content expand vertically, but shrink horizontally
#let expand-v = "expand-v"
// Content tries to keep square form for available space
#let squared = "squared"

// Helper function for building any container.
// - fitting: Declares how layout of container works. Can be shrink, expand, expand-h or expand-v
// - insets: Inner insets around background
// - background: Arbitrary shape to frame content
// - body: Actual content
#let container(
  fitting: shrink,
  insets: paddings(1),
  background: (size) => rect(width: size.width, height: size.height),
  body
) = {
  layout(size => {
    let padArgs = if type(insets) == dictionary {
      insets
    } else {
      (rest: insets)
    }

    let bodyWithPadding = pad(..padArgs)[#body]
    let contentSize = () => {
      measure(block(width: size.width)[#bodyWithPadding])
    }

    let size = if fitting == expand {
      size
    } else if fitting == shrink {
      measure(bodyWithPadding)
    } else if fitting == expand-h {
      (width: size.width, height: contentSize().height)
    } else if fitting == expand-v {
      (width: contentSize().width, height: size.height)
    } else if fitting == squared {
      let minDimention = calc.min(size.width, size.height)
      (width: minDimention, height: minDimention)
    } else {
      panic("fitting " + fitting + " is not supported, expected: shrink|expand|expand-h|expand-v")
    }

    [
      #block(width: size.width, height: size.height)[
        #background(size)
      ]
      #place(center + horizon)[
        #block(width: size.width, height: size.height)[
          #bodyWithPadding
        ]
      ]
    ]
  })
}

// Container wrappend in frame.
// Parameters:
// - stroke: Stroke width
#let framed(
  stroke: strokes.thin,
  radius: paddings(1) - 0.1 * paddings(1),
  insets: paddings(1),
  fitting: shrink,
  body
) = container(
  fitting: fitting,
  insets: insets,
  background: size => frame(
    width: size.width,
    height: size.height,
    stroke: stroke,
    radius: radius
  ),
  body
)


#let propBox(
  shape: frame.with(radius: paddings(1) - 0.1 * paddings(1)),
  dx: 0pt,
  dy: 0pt,
  body
) = container(
  fitting: squared,
  background: size => shape(
    width: size.width,
    height: size.height,
    stroke: strokes.normal
  )
)[
  #box(width: 100%, height: 100%)[
    #place(bottom + center, dx: dx, dy: dy)[
      #propCap[ #body ]
    ]
  ]
]

#let badge(
  caption: none,
  height: auto,
  width: auto,
  alignment: top + right,
  body
) = [
  #box[
    #body
    #place(alignment)[
      #rect(
        width: width,
        height: height,
        fill: white,
        stroke: strokes.normal
      )[
        #propCap(caption)
      ]
    ]
  ]
]
