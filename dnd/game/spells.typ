#import "../core/core.typ": *
#import "character.typ": stats, statName, statModifier, resolveForCharacter

// Cast time
#let action = loc(en: [A], ru: [Де])
#let bonusAction = loc(en: [B], ru: [Бо])
#let reaction = loc(en: [Re], ru: [Ре])

// Durations
#let instant = loc(en: [Inst.], ru: [Момен.])
#let round(r) = str(r) + loc(en: [r], ru: [р])
#let minute(m) = str(m) + loc(en: [m], ru: [мин])
#let hour(h) = str(h) + loc(en: [h], ru: [ч])
#let day(d) = str(d) + loc(en: [day], ru: [дн])
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

#let acid = "acid"
#let bludgeoning = "bludgeoning"
#let frost = "frost"
#let fire = "fire"
#let force = "force"
#let lightning = "lightning"
#let necrotic = "necrotic"
#let piercing = "piercing"
#let poison = "poison"
#let psychic = "psychic"
#let radiant = "radiant"
#let slashing = "slashing"
#let thunder = "thunder"

#let damageTypeName(type) = {
  (
      acid: loc(en: "Acid", ru: "Кислотный"),
      bludgeoning: loc(en: "Bludgeoning", ru: "Дробящий"),
      frost: loc(en: "Frost", ru: "Холодом"),
      fire: loc(en: "Fire", ru: "Огнем"),
      force: loc(en: "Force", ru: "Силовой"),
      lightning: loc(en: "Lightning", ru: "Электричеством"),
      necrotic: loc(en: "Necrotic", ru: "Некротический"),
      piercing: loc(en: "Piercing", ru: "Колющий"),
      poison: loc(en: "Poison", ru: "Ядом"),
      psychic: loc(en: "Psychic", ru: "Психический"),
      radiant: loc(en: "Radiant", ru: "Лучистый"),
      slashing: loc(en: "Slashing", ru: "Рубящий"),
      thunder: loc(en: "Thunder", ru: "Звуковой"),
  ).at(type)
}

#let damageTypeShortName(type) = {
  (
      acid: loc(en: "acid", ru: "кисл."),
      bludgeoning: loc(en: "bludg.", ru: "дроб."),
      frost: loc(en: "frost", ru: "хол."),
      fire: loc(en: "fire", ru: "огн."),
      force: loc(en: "force", ru: "сил."),
      lightning: loc(en: "light.", ru: "элект."),
      necrotic: loc(en: "necro.", ru: "некр."),
      piercing: loc(en: "pierc.", ru: "кол."),
      poison: loc(en: "pois.", ru: "отрав."),
      psychic: loc(en: "psych.", ru: "псих."),
      radiant: loc(en: "rad.", ru: "луч."),
      slashing: loc(en: "slash.", ru: "руб."),
      thunder: loc(en: "thund.", ru: "звук."),
  ).at(type)
}

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
  name: subsection(loc(en: [Level #level], ru: [Уровень #roman(level)])),
  slots: if slots != none { spellSlots(slots) }
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

#let atHigherLevels(body) = emph(loc(en: [(Lvl~up:~#body)], ru: [Выс.~ур.:~#body]))

#let required(body) = [
  #loc(en: "Req.", ru: "Обяз."): #underline(text(weight: "bold", body))
]

#let characterRoll(character, formula) = {
  let e = formula

  let varianceMin(n, max) = n
  let varianceMax(n, max) = max * n

  e = e.replace(
    regex("(\d+)d(\d+)"),
    g => "variance("+ g.captures.at(0) + "," + g.captures.at(1) + ")"
  )
  for stat in stats {
    e = e.replace(stat, str(statModifier(character, stat)))
  }

  let evalVariance(variance) = eval(
    e.replace("variance", variance),
    scope: (
      min: varianceMin,
      max: varianceMax
    )
  )

  [#formula #caption[(#evalVariance("min") - #evalVariance("max"))]]
}

#let characterFormula(character, formula) = {
  let e = formula

  for stat in stats {
    e = e.replace(stat, str(statModifier(character, stat)))
  }

  if character.level != none {
    e = e.replace("LVL", str(character.level))
  }

  let proffBonus = method(character, c => c.proffBonus)
  if proffBonus != none {
    e = e.replace("PROF", str(proffBonus))
  }

  eval(e)
}

#let roll(formula) = resolveForCharacter(c => characterRoll(c, formula))

#let formula(formula) = resolveForCharacter(c => characterFormula(c, formula))

#let dc(dcFormula) = [ #loc(en: [DC], ru: [СЛ]) #formula(dcFormula)]

#let noDamage = "noDamage"
#let halfDamage = "halfDamage"

#let damage(formula, damageType, ranged: false, saving: none, saved: halfDamage, upgraded: none) = [
  *
  #if ranged [
    #loc(en: [Ranged], ru: [Дальн.]),
  ]
  #if saving != none [
    #statName(saving) #loc(en: [or], ru: [или])
  ]
  #roll(formula) #damageTypeShortName(damageType)
  *
]

#let heal(formula) = [
  *#loc(en: [Heal], ru: [Лечит]) #roll(formula) #loc(en: [HP], ru: [ОЗ])*
]
