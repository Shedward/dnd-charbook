#import "../core/core.typ": *

// Cast time
#let action = [A]
#let bonusAction = [B]
#let reaction = [Re]

// Durations
#let instant = [Inst.]
#let round(r: 1) = str(r) + [R]
#let minute(m) = str(m) + [m]
#let hour(h) = str(h) + [h]

// Cast type
#let ritual = [R]
#let concentration = [C]

// Range
#let self = [Self]
#let touch = [Touch]

// Preparation
#let alwaysPrepared = sym.infinity
#let preparing = {
  box(circle(radius: paddings(1), stroke: strokes.thin))
}
#let freePreparation(body, count: 1) = [
  #body\
  #spellCaption[#count free]
]

#let rangeDescr(range) = if (range == 0) [#self] else [#(range)ft]
#let countDescr(count) = if (count>1) [#sym.times#count] else []

#let target(range, count: 1) = [#(rangeDescr(range))#icon("target")#countDescr(count)]
#let point(range, count: 1) = [#(rangeDescr(range))#icon("point")#countDescr(count)]
#let circle(range: 0, radius) = [#(rangeDescr(range))/#(radius)ft#icon("circle")]
#let square(range: 0, width) = [#(rangeDescr(range))/#(width)ft#icon("square")]
#let cube(range: 0, width) = [#(rangeDescr(range))/#(width)ft#icon("cube")]
#let sphere(range: 0, width) = [#(rangeDescr(range))/#(width)ft#icon("sphere")]

#let components(components, required: none) = (
  components: components,
  required: required
)

#let spell(
  prep: preparing,
  name: none,
  school: none,
  castTime: action,
  castType: none,
  duration: none,
  range: none,
  components: components(none),
  body
) = (
  prep: prep,
  name: name,
  school: school,
  castTime: castTime,
  castType: castType,
  duration: duration,
  range: range,
  components: components,
  body: body
)
