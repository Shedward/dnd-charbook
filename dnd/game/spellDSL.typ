#import "../core/core.typ": *
#import "spellConstants.typ": *
#import "character.typ": stats, statName, statModifier, spellcastingStat, resolveForCharacter, STR, DEX, CON, INT, WIS, CHA

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

  let spellStat = spellcastingStat(character)
  if spellStat != none {
    e = e.replace("MOD", str(statModifier(character, spellStat)))
  }

  let evalVariance(variance) = eval(
    e.replace("variance", variance),
    scope: (
      min: varianceMin,
      max: varianceMax
    )
  )

  let minVal = evalVariance("min")
  let maxVal = evalVariance("max")
  if minVal == maxVal {
    [#formula]
  } else {
    [#formula #caption[(#minVal - #maxVal)]]
  }
}

#let characterFormula(character, formula) = {
  let e = formula

  for stat in stats {
    e = e.replace(stat, str(statModifier(character, stat)))
  }

  let spellStat = spellcastingStat(character)
  if spellStat != none {
    e = e.replace("MOD", str(statModifier(character, spellStat)))
  }

  if character.level != none {
    e = e.replace("LVL", str(character.level))
  }

  let profBonus = method(character, c => c.profBonus)
  if profBonus != none {
    e = e.replace("PROF", str(profBonus))
  }

  eval(e)
}

#let roll(formula) = resolveForCharacter(c => characterRoll(c, formula))

#let formula(formula) = resolveForCharacter(c => characterFormula(c, formula))

#let dc(dcFormula) = [ #loc(en: [DC], ru: [СЛ]) #formula(dcFormula)]

#let damage(formula, damageType, ranged: false, saving: none, saved: halfDamage, upgraded: none) = [
  *
  #if ranged [
    #loc(en: [Ranged], ru: [Дальн.]),
  ]
  #if saving != none [
    #statName(saving)
    #if saved == halfDamage {
      [(½)]
    }
    #loc(en: [or], ru: [или])
  ]
  #roll(formula) #damageTypeShortName(damageType)
  *
]

#let heal(formula) = [
  *#loc(en: [Heal], ru: [Лечит]) #roll(formula) #loc(en: [HP], ru: [ОЗ])*
]

#let effect(condition, saving: none) = [
  *#if saving != none [#statName(saving) #loc(en: [or], ru: [или])]
  #conditionName(condition)*
]

// Advantage / disadvantage
#let rollTargetName(t) = if t == attack {
  loc(en: "Attack", ru: "Атака")
} else {
  statName(t)
}

#let advantage(on) = [
  *#loc(en: [Adv.], ru: [Преим.]): #rollTargetName(on)*
]

#let disadvantage(on) = [
  *#loc(en: [Disadv.], ru: [Помеха]): #rollTargetName(on)*
]

// Resistance / vulnerability / immunity
#let resist(..types) = [
  *#loc(en: [Resist.], ru: [Сопр.]): #types.pos().map(damageTypeShortName).join[, ]*
]

#let weakness(..types) = [
  *#loc(en: [Vuln.], ru: [Уязв.]): #types.pos().map(damageTypeShortName).join[, ]*
]

#let immune(..types) = [
  *#loc(en: [Immune], ru: [Иммун.]): #types.pos().map(damageTypeShortName).join[, ]*
]

#let immuneEffect(..conditions) = [
  *#loc(en: [Immune], ru: [Иммун.]): #conditions.pos().map(conditionName).join[, ]*
]

// Curing conditions / diseases
#let cure(..items) = [
  *#loc(en: [Cures], ru: [Снимает]): #items.pos().map(cureName).join[, ]*
]

// Movement speed
#let speed(value, ..rest) = {
  let movType = rest.pos().at(0, default: walking)
  let val = if type(value) == int or type(value) == float {
    [#value #loc(en: [ft], ru: [фт])]
  } else {
    [#value]
  }
  let label = (
    flying:   loc(en: "Fly",    ru: "Полёт"),
    swimming: loc(en: "Swim",   ru: "Плавание"),
    climbing: loc(en: "Climb",  ru: "Лазание"),
    burrowing: loc(en: "Burrow", ru: "Рытьё"),
    walking:  loc(en: "Speed",  ru: "Скорость"),
  ).at(movType)
  [*#label: #val*]
}

// Light
#let light(bright: 0, dim: 0) = [
  *#loc(en: [Light], ru: [Свет]): #bright/#dim #loc(en: [ft], ru: [фт])*
]

// Forced movement
#let move(direction, distance: 0, saving: none) = [
  *#if saving != none [#statName(saving) #loc(en: [or], ru: [или])]
  #if direction == toYou [#loc(en: [Pull], ru: [Притяг.])] else [#loc(en: [Push], ru: [Оттал.])]
  #distance #loc(en: [ft], ru: [фт])*
]

// DSL evaluation scope for spell body strings.
// Defined here so it stays in sync with the functions above automatically.
#let spellBodyDSLScope = (
  damage: damage,
  heal: heal,
  formula: formula,
  atHigherLevels: atHigherLevels,
  acid: acid, bludgeoning: bludgeoning, cold: cold, frost: frost, fire: fire,
  force: force, lightning: lightning, necrotic: necrotic,
  piercing: piercing, poison: poison, psychic: psychic,
  radiant: radiant, slashing: slashing, thunder: thunder,
  STR: STR, DEX: DEX, CON: CON, INT: INT, WIS: WIS, CHA: CHA,
  halfDamage: halfDamage, noDamage: noDamage,
  effect: effect,
  blinded: blinded, charmed: charmed, deafened: deafened,
  frightened: frightened, grappled: grappled, incapacitated: incapacitated,
  invisible: invisible, paralyzed: paralyzed, petrified: petrified,
  poisoned: poisoned, prone: prone, restrained: restrained,
  stunned: stunned, unconscious: unconscious,
  advantage: advantage, disadvantage: disadvantage,
  attack: attack,
  resist: resist, weakness: weakness, immune: immune, immuneEffect: immuneEffect,
  cure: cure, disease: disease,
  light: light,
  speed: speed, flying: flying, swimming: swimming, climbing: climbing, burrowing: burrowing,
  move: move, toYou: toYou, fromYou: fromYou,
  target: target, touch: touch, self: self, point: point, sight: sight, unlimited: unlimited,
  circle: circle, ring: ring, square: square, cube: cube, sphere: sphere,
  straightLine: straightLine, cone: cone, cylinder: cylinder, rectangle: rectangle,
)
