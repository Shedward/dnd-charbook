#import "../core/core.typ": *

#let ability(title, source: none, body) = (
  title: title,
  source: source,
  body: body
)

#let abilityCharges(count) = figure(box(framed(checkboxes(count))))

#let inputGrid(lines, lineHeight: paddings(3), width: 100%) = {
  let gridBox(body) = box(width: width, height: lines * lineHeight, body)
  let gridLine(y) = line(start: (0%, y), length: 100%, stroke: strokes.thin)

  if lines == auto {

  } else if lines == 0 {
    none
  } else if lines == 1 {
    gridBox[
      #gridLine(lineHeight)
    ]
  } else {
    gridBox[
      #for lineNumber in range(1, lines) {
        place(center, gridLine(lineHeight * lineNumber))
      }
    ]
  }
}

#let abilitySlot(lines) = figure(
  box(
    framed(
      fitting: expand-h,
      insets: (
        x: paddings(2),
        y: if lines == 1 { paddings(1) } else { 0pt }
      )
    )[
      #inputGrid(lines)
    ]
  )
)
