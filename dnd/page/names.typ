#import "../core/core.typ": *

#let statName(stat) = {
  (
    STR: loc(en: "STR", ru: "СИЛ"),
    DEX: loc(en: "DEX", ru: "ЛОВ"),
    CON: loc(en: "CON", ru: "ТЕЛ"),
    INT: loc(en: "INT", ru: "ИНТ"),
    WIS: loc(en: "WIS", ru: "МУД"),
    CHA: loc(en: "CHA", ru: "ХАР")
  ).at(stat)
}

#let skillName(skill) = {
  (
    acrobatics: loc(en: "Acrobatics", ru: "Акробатика"),
    animalHandling: loc(en: "Animal H.", ru: "Уход за Жив."),
    arcana: loc(en: "Arcana", ru: "Магия"),
    athletics: loc(en: "Athletics", ru: "Атлетика"),
    deception: loc(en: "Deception", ru: "Обман"),
    history: loc(en: "History", ru: "История"),
    insight: loc(en: "Insight", ru: "Проницательность"),
    intimidation: loc(en: "Intimidation", ru: "Запугивание"),
    investigation: loc(en: "Investigation", ru: "Расследование"),
    medicine: loc(en: "Medicine", ru: "Медицина"),
    nature: loc(en: "Nature", ru: "Природа"),
    perception: loc(en: "Perception", ru: "Восприятие"),
    persuation: loc(en: "Persuation", ru: "Убеждение"),
    performance: loc(en: "Performance", ru: "Выступление"),
    religion: loc(en: "Religion", ru: "Религия"),
    sleighOfHand: loc(en: "Sleigh of Hand", ru: "Ловкость рук"),
    stealth: loc(en: "Stealch", ru: "Скрытность"),
    survival: loc(en: "Survival", ru: "Выживание")

  ).at(skill)
}
