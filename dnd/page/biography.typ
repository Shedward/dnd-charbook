#import "../core/core.typ": *

#let biographyPage(body) = {
  set page(header: section(loc(en: [Biography], ru: [Биография])))
  set text(hyphenate: false)
  set par(spacing: 1em)

  page(body)
}

#let backstory(body) = {
  biographyPage[
    #set par(first-line-indent: 1em, justify: true)
    #framed(fitting: expand, insets: paddings(2))[
      #align(left)[
        #columned[
          #abilityHeader(loc(en: [Backstory], ru: [Предыстория]))

          #body
        ]
      ]
    ]
  ]
}

#let personality(body) = {
  biographyPage[
      #columned(body, separator: false, gutter: paddings(2))
  ]
}
