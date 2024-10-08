#import "../core/core.typ": *

// Cast time
#let action = [A]
#let bonusAction = [B]
#let reaction = [Re]

// Durations
#let instant = [Inst.]
#let round(r) = str(r) + [r]
#let minute(m) = str(m) + [m]
#let hour(h) = str(h) + [h]
#let always = sym.infinity

// Cast type
#let ritual = [R]
#let concentration = [C]

// School
#let abjuration = "Abjuration"
#let conjuration = "Conjuration"
#let necromancy = "Necromancy"
#let evocation = "Evocation"
#let transmutation = "Transmutation"
#let divination = "Divination"
#let enchantment = "Enchantment"
#let illusion = "Illusion"

// Preparation
#let alwaysPrepared = sym.infinity
#let preparing = {
  box(circle(radius: paddings(1), stroke: strokes.thin))
}
#let freePreparation(body, count: 1) = [
  #body\
  #spellCaption[#count free]
]

// Range
#let self = [Self]
#let touch = [Touch]

#let rangeDescr(range) = if (range == 0) [
  #self
] else [
  #(range)ft
]

#let countDescr(count) = if (count>1) [#sym.times#count] else []

#let mile(m) = 5279 * m

#let target(range, count: 1) = [#(rangeDescr(range))#icon("target")#countDescr(count)]
#let point(range, count: 1) = [#(rangeDescr(range))#icon("point")#countDescr(count)]
#let area(iconName) = (size, range: 0) => [#(rangeDescr(range))/#(size)ft#icon(iconName)]

#let circle = area("circle")
#let square = area("square")
#let cube = area("cube")
#let sphere = area("sphere")
#let straightLine = area("arrow-right")

#let volume(size) = [#(size)ft#icon("cube")]

// Sources
#let class = [Class]
#let race = [Race]
#let story = [Story]

#let cantrip = (
  name: subsection[Cantrip],
  slots: none
)

#let spellSlots(count) = box(framed(checkboxes(count), stroke: strokes.normal))

#let spellLevel(
  level,
  slots: none
) = (
  name: subsection[Level #level],
  slots: spellSlots(slots)
)

#let spell(
  name,
  prep: none,
  school: none,
  castTime: action,
  castType: none,
  duration: none,
  range: none,
  components: none,
  source: class,
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
  source: source,
  body: body
)

#let atHigherLevels(body) = emph[(Lvl~up:~#body)]

#let required(body) = [
  Req.: #underline(text(weight: "bold", body))
]
