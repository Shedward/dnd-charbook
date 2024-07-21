#let frame(
  body,
  radius: 1.8mm,
  padding: 2mm
) = context {
  let bodyWithPadding = pad(padding)[
    #body
  ]
  let size = measure(bodyWithPadding)
  [
    #block()[
      #place(center + horizon)[
        #bodyWithPadding
      ]
      #pad(x: 0pt)[
          #path(
            closed: true,
            stroke: 0.5pt,

            (radius, 0pt),
            ((size.width - radius, 0pt), (0pt, 0pt), (0pt, 0.5 * radius)),
            ((size.width, radius), (-0.5 * radius, 0pt), (0pt, 0pt)),
            ((size.width, size.height - radius), (0pt, 0pt), (-0.5 * radius, 0pt)),
            ((size.width - radius, size.height), (0pt, -0.5 * radius), (0pt, 0pt)),
            ((radius, size.height), (0pt, 0pt), (0pt, -0.5 * radius)),
            ((0pt, size.height - radius), (0.5 * radius, 0pt), (0pt, 0pt)),
            ((0pt, radius), (0pt, 0pt), (0.5 * radius, 0pt)),
            ((radius, 0pt), (0pt, 0.5 * radius), (0pt, 0pt))
          )
      ]
    ]
  ]
}
