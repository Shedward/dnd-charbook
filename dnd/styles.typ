
#let prelude(doc) = {
  set page(
    paper: "a5"
  )
  set par(justify: true)
  set text(
    font: "Mookmania",
    size: 9pt
  )

  doc
}

#let bookTitle(body) = {
  set text(
    font: "Alegreya SC",
    weight: "bold",
    size: 22pt
  )
  body
}

#let bookSubtitle(body) = {
  set text(
    font: "Alegreya SC",
    size: 16pt
  )
  body
}

#let contentPage(doc) = {
  columns(2, doc)
}
