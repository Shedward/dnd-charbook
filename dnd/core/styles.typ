#import "dimentions.typ": *

#let fonts = (
  body: "Mookmania",
  header: "Alegreya SC"
)

// Initial style settings.
// Should be `#show: dnd.core.charbook`
// at the top of the document
#let charbook(doc) = {
  set page(
    paper: "a5",
    margin: 18mm
  )
  set par(justify: true)
  set text(
    font: fonts.body,
    size: 9pt
  )

  doc
}

#let charStat(body) = {
  set text(
    font: fonts.body,
    weight: "bold",
    size: 8pt
  )
  body
}

#let propCap(body) = {
  set text(
    font: fonts.header,
    size: 7pt
  )
  smallcaps(body)
}

#let statCaption(body, fill: black) = {
  set text(
    font: fonts.body,
    size: 6pt,
    fill: fill
  )
  body
}

#let spellBody(body) = {
  set text(
    font: fonts.body,
    size: 7pt
  )
  body
}

#let spellCaption(body, fill: black) = {
  set text(
    font: fonts.body,
    size: 5pt,
    fill: fill
  )
  body
}

#let characterName(body) = {
  set text(
    font: fonts.header,
    weight: "bold",
    size: 18pt
  )
  body
}

// Style for book's title at cover
#let bookTitle(body) = {
  set text(
    font: fonts.header,
    weight: "bold",
    size: 22pt
  )
  body
}

#let section(body) = {
  set text(
    font: fonts.header,
    size: 20pt
  )
  body
}

#let subsection(body) = {
  set text(
    font: fonts.header,
    size: 15pt
  )
  body
}

// Style for secondary information at cover
#let bookSubtitle(body) = {
  set text(
    font: fonts.header,
    size: 16pt
  )
  body
}

// Style for table header
#let tableHeader(body) = {
  set text(
    font: fonts.header,
    size: 7pt
  )
  smallcaps(body)
}

// Style for page with text content (ability list, biography, etc.)
#let columned(doc) = {
  [
    #columns(2, gutter: 8mm)[#doc]
    #place(center + horizon)[
      #line(
        angle: 90deg,
        length: 100%,
        stroke: strokes.thin
      )
    ]
  ]
}
