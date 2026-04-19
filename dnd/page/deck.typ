#import "../core/core.typ": *

#let deck(
  data,
  cardSize,
  renderCard,
  paper: "a4",
  margin: 3mm,
  stroke: 0.5pt + gray,
) = {
  show: charbook
  set page(paper: paper, margin: margin)

  context {
    let availW = page.width - 2 * margin
    let availH = page.height - 2 * margin
    let resolve(v, base) = {
      let t = type(v)
      if t == length { v }
      else if t == ratio { v * base }
      else if t == relative { v.length + v.ratio * base }
      else { panic("cardSize components must be length, ratio, or relative; got " + repr(t)) }
    }
    let cw = resolve(cardSize.at(0), availW)
    let ch = resolve(cardSize.at(1), availH)

    let cols = calc.floor(availW / cw)
    let rows = calc.floor(availH / ch)
    assert(cols > 0 and rows > 0, message: "deck: card size exceeds page area")
    let perPage = cols * rows

    let emptyCell = box(width: cw, height: ch)
    let gridOf(cells) = grid(
      columns: (cw,) * cols,
      rows: (ch,) * rows,
      stroke: stroke,
      ..cells,
    )

    let chunkStart = 0
    while chunkStart < data.len() {
      let chunk = data.slice(
        chunkStart,
        calc.min(chunkStart + perPage, data.len()),
      )
      let rendered = chunk.map(renderCard)
      let isLast = chunkStart + perPage >= data.len()

      let frontCells = rendered.map(r => r.front)
      while frontCells.len() < perPage { frontCells.push(emptyCell) }
      gridOf(frontCells)
      pagebreak()

      let backCells = rendered.map(r => r.back)
      while backCells.len() < perPage { backCells.push(emptyCell) }
      let mirrored = ()
      for r in range(rows) {
        mirrored += backCells.slice(r * cols, (r + 1) * cols).rev()
      }
      gridOf(mirrored)

      if not isLast { pagebreak() }
      chunkStart += perPage
    }
  }
}

