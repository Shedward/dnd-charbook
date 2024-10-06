#import "../core/core.typ": *

#let biographyPage(body) = {
  set page(header: section[Biography])
  set text(hyphenate: false)
  show par: set block(spacing: 0.75em)

  page(body)
}

#let backstory(body) = {
  biographyPage[
    #set par(first-line-indent: 1em, justify: true)
    #framed(fitting: expand, insets: paddings(2))[
      #align(left)[
        #columned[
          #abilityHeader[Backstory]

          #body
        ]
      ]
    ]
  ]
}

#let personality(body) = {
  biographyPage[
      #columned(body, withSeparator: false)
  ]
}
