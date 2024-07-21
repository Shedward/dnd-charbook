#import "../dnd.typ"

#let padding = dnd.paddings(1.5)

#let cover(
  author: none,
  title: none,
  name,
  subtitle: none,
  caption: none
) = dnd.framed(
  stroke: dnd.strokes.normal,
  padding: padding,
  fitting: "expand"
)[
  #dnd.framed(
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
        #dnd.bookSubtitle[
          #title
        ] \
        #dnd.bookTitle[
          #name
        ] \
        #v(8mm)
        #dnd.bookSubtitle[
          #set text(18pt)
          #subtitle
        ] \
      ]
    ]
  ]
]
