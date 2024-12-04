#import "../core/core.typ": *

// Cast time
#let action = loc(en: [A], ru: [Де])
#let bonusAction = loc(en: [B], ru: [Бо])
#let reaction = loc(en: [Re], ru: [Ре])

// Durations
#let instant = loc(en: [Inst.], ru: [Момен.])
#let round(r) = str(r) + loc(en: [r], ru: [р])
#let minute(m) = str(m) + loc(en: [m], ru: [мин])
#let hour(h) = str(h) + loc(en: [h], ru: [ч])
#let always = sym.infinity

// Cast type
#let ritual = loc(en: [R], ru: [Рит.])
#let concentration = loc(en: [C], ru: [Кон.])

// School
#let abjuration = loc(en: "Abjuration", ru: "Ограждение")
#let conjuration = loc(en: "Conjuration", ru: "Вызов")
#let necromancy = loc(en: "Necromancy", ru: "Некромантия")
#let evocation = loc(en: "Evocation", ru: "Воплощение")
#let transmutation = loc(en: "Transmutation", ru: "Преобразование")
#let divination = loc(en: "Divination", ru: "Прорицание")
#let enchantment = loc(en: "Enchantment", ru: "Очарование")
#let illusion = loc(en: "Illusion", ru: "Иллюзия")

// Preparation
#let alwaysPrepared = sym.infinity
#let preparing = {
  box(circle(radius: paddings(1), stroke: strokes.thin))
}
#let freePreparation(body, count: 1) = [
  #body\
  #spellCaption[#count #loc(en: "free", ru: "бесп.")]
]

// Range
#let self = loc(en: [Self], ru: [Себя])
#let touch = loc(en: [Touch], ru: [Касание])

#let rangeDescr(range) = if (range == 0) [
  #self
] else [
  #(range)#loc(en: "ft", ru: "фт")
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
  name: subsection(loc(en: [Cantrip], ru: [Заговор])),
  slots: none
)

#let spellSlots(count) = box(framed(checkboxes(count), stroke: strokes.normal))

#let spellLevel(
  level,
  slots: none
) = (
  name: subsection(loc(en: [Level #level], ru: [Уровень #level])),
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

#let atHigherLevels(body) = emph(loc(en: [(Lvl~up:~#body)], ru: [Ур.:~#body]))

#let required(body) = [
  #loc(en: "Req.", ru: "Обяз."): #underline(text(weight: "bold", body))
]
