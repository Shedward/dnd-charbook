
#let contentPage(doc) = {
  set page(
    paper: "a5"
  )
  set par(justify: true)
  set text(
    font: "Mookmania",
    size: 9pt
  )
  columns(2, doc)
}
