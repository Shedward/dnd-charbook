#import "dimensions.typ": *

// Renders rectangle with corners rounded inside
// Parameters:
// - width: Outer width of frame
// - height: Outer height of frame
// - stroke: Stroke width, use values from dimenstions.stroke
// - radius: Inner radius of frame
#let frame(
  width: 100%,
  height: 100%,
  stroke: strokes.thin,
  fill: none,
  radius: paddings(1) - 0.1 * paddings(1)
) = {
  let z = 0pt
  let r = radius
  let hr = 0.5 * radius
  let w = width - 2.0 * r
  let h = height - 2.0 * r
  curve(
    stroke: stroke,
    fill: fill,
    // ---
    curve.move((radius, 0pt)),
    curve.cubic((z, hr), (-hr, r), (-r, r), relative: true),
    curve.line((z, h), relative: true),
    curve.cubic((hr, z), (r, hr), (r, r), relative: true),
    curve.line((w, z), relative: true),
    curve.cubic((z, -hr), (hr, -r), (r, -r), relative: true),
    curve.line((z, -h), relative: true),
    curve.cubic((-hr, z), (-r, -hr), (-r, -r), relative: true),
    curve.close(mode: "straight")
  )
}

#let heart(width: 100%, height: 100%, stroke: strokes.thin, fill: none) = {
  let xCenter = 0.5 * width
  let yTopRuler = 0.1 * height
  let yBottomRuler = 0.75 * height
  let xLeftRuler = 0.1 * width
  let xRightRuler = width - xLeftRuler

  let topHanger = 0.125 * height
  let bottomHanger = topHanger

  // path() anchor format: (point, handle-in, handle-out)
  // curve.cubic(ctrl1, ctrl2, end) uses absolute coordinates
  // ctrl1 = prev-point + prev-handle-out, ctrl2 = next-point + next-handle-in
  let p0 = (xCenter, width)
  let p1 = (xLeftRuler, yBottomRuler)
  let p2 = (xLeftRuler, yTopRuler)
  let p3 = (xCenter, yTopRuler)
  let p4 = (xRightRuler, yTopRuler)
  let p5 = (xRightRuler, yBottomRuler)

  curve(
    stroke: stroke,
    fill: fill,
    curve.move(p0),
    // p0 handle-out: (-topHanger, -topHanger), p1 handle-in: (bottomHanger, bottomHanger)
    curve.cubic(
      (p0.at(0) - topHanger, p0.at(1) - topHanger),
      (p1.at(0) + bottomHanger, p1.at(1) + bottomHanger),
      p1
    ),
    // p1 has no handle-out (implicit straight), p2 handle-in: (-topHanger, topHanger)
    curve.cubic(
      p1,
      (p2.at(0) - topHanger, p2.at(1) + topHanger),
      p2
    ),
    // p2 has no handle-out, p3 handle-in: (-topHanger, -topHanger)
    curve.cubic(
      p2,
      (p3.at(0) - topHanger, p3.at(1) - topHanger),
      p3
    ),
    // p3 handle-out: (topHanger, -topHanger), p4 handle-in: (-topHanger, -topHanger)
    curve.cubic(
      (p3.at(0) + topHanger, p3.at(1) - topHanger),
      (p4.at(0) - topHanger, p4.at(1) - topHanger),
      p4
    ),
    // p4 has no handle-out, p5 handle-in: (bottomHanger, -bottomHanger)
    curve.cubic(
      p4,
      (p5.at(0) + bottomHanger, p5.at(1) - bottomHanger),
      p5
    ),
    // p5 has no handle-out, p0 handle-in: (topHanger, -topHanger)
    curve.cubic(
      p5,
      (p0.at(0) + topHanger, p0.at(1) - topHanger),
      p0
    ),
    curve.close(mode: "straight")
  )
}


#let shield(width: 100%, height: 100%, stroke: strokes.thin, fill: none) = {
  let xCenter = 0.5 * width
  let leftRuller = 0pt
  let rightRuller = width

  let topRuller = 0pt
  let yCenter = 0.66 * height
  let bottomRuller = height

  let topAnchorPadding = 0.10 * height
  let topAnchorSidePadding = 0.33 * width
  let topLeftAnchor = (leftRuller + topAnchorSidePadding, topAnchorPadding + topRuller)
  let topRightAnchor = (rightRuller - topAnchorSidePadding, topAnchorPadding + topRuller)

  let bottomAnchorRuller = 0.80 * height
  let bottomLeftAnchor = (0pt, bottomAnchorRuller)
  let bottomRightAnchor = (width, bottomAnchorRuller)

  curve(
    fill: fill,
    stroke: stroke,
    // ---
    curve.move((xCenter, topRuller)),
    curve.cubic(topRightAnchor, topRightAnchor, (rightRuller, topRuller)),
    curve.cubic(bottomRightAnchor, bottomRightAnchor, (xCenter, bottomRuller)),
    curve.cubic(bottomLeftAnchor, bottomLeftAnchor, (leftRuller, topRuller)),
    curve.cubic(topLeftAnchor, topLeftAnchor, (xCenter, topRuller)),
    curve.close(mode: "straight")
  )
}

#let rhombus(
  width: 100%,
  stroke: strokes.thin,
  fill: none
) = {
  let h = 0.5 * width
  curve(
    stroke: stroke,
    fill: fill,
    // ---
    curve.move((h, 0pt)),
    curve.line((width, h)),
    curve.line((h, width)),
    curve.line((0pt, h)),
    curve.close()
  )
}

#let checkboxes(count, size: 4mm, padding: 25%, shape: rhombus) = if (count == 1) {
  shape(width: size, stroke: strokes.normal)
} else {
  grid(
    columns: (auto,) * count,
    column-gutter: padding * size,
    ..((shape(width: size, stroke: strokes.normal),) * count)
  )
}
