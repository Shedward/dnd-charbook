#import "../core/core.typ": *

#let ability(title, source: none, body) = (
  title: title,
  source: source,
  body: body
)

#let abilityCharges(count) = figure(box(framed(checkboxes(count))))

#let abilityRequirement(body) = [
  #set text(top-edge: 0.5em)
  #set par(first-line-indent: 0em)

  #emph(body)
]

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
