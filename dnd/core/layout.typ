#import "dimentions.typ": *
#import "graphics.typ": *

// Set of available fittings

// Container shrink around container
#let shrink = "shrink"
// Content expand to all available space
#let expand = "expand"
// Content expand horizontally, but shrink vertically
#let expand-h = "expand-h"
// Content expand vertically, but shrink horizontally
#let expand-v = "expand-v"

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
    let bodyWithPadding = pad(insets)[#body]
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
    } else {
      panic("fitting " + fitting + " is not supported, expected: shrink|expand|expand-h|expand-v")
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
