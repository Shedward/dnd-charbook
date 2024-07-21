#import "../core/core.typ"

#let padding = core.paddings(2)

#let cover(
  author: none,
  title: none,
  name,
  subtitle: none,
  caption: none
) = core.framed(
  stroke: core.strokes.normal,
  padding: padding,
  fitting: "expand"
)[
  #core.framed(
    padding: padding,
    fitting: "expand"
  )[
    #box(width: 100%, height: 100%)[
      #if author != none [
        #place(top + right)[
          Author: #author
        ]
      ]
      #place(bottom + left)[
        #caption
      ]
      #place(center + horizon)[
        #core.bookSubtitle[
          #title
        ] \
        #core.bookTitle[
          #name
        ] \
        #v(8mm)
        #core.bookSubtitle[
          #set text(18pt)
          #subtitle
        ] \
      ]
    ]
  ]
]
