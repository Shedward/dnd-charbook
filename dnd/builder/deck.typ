#import "../game/character.typ": setCharacter
#import "../page/deck.typ": deck
#import "../page/spellCard.typ": spellCard
#import "../page/spells.typ": spellFromSpellbook
#import "../data/spellbook.typ": spellbook, is_spell_for_class

#let deckOfSpells(
  char,
  card: spellCard,
  cardSize: (33.33%, 33.33%),
  paper: "a4",
  margin: 5mm,
  cardPadding: 5mm,
  stroke: (paint: silver, thickness: 0.2mm, dash: "dashed")
) = {
  setCharacter(char)
  let spells = char.at("spells", default: (cantrips: (), byLevel: (:)))
  let all = spells.cantrips.map(s => (..s, level: 0))
  for lvl in spells.byLevel.keys().map(int).sorted() {
    all += spells.byLevel.at(str(lvl)).map(s => (..s, level: lvl))
  }
  deck(
    all,
    cardSize,
    card,
    paper: paper,
    margin: margin,
    cardPadding: cardPadding,
    stroke: stroke,
  )
}

#let deckOfClassSpells(
  class,
  subclass: none,
  card: spellCard,
  cardSize: (33.33%, 33.33%),
  paper: "a4",
  margin: 5mm,
  cardPadding: 5mm,
  stroke: (paint: silver, thickness: 0.2mm, dash: "dashed"),
) = {
  let filtered = spellbook()
    .filter(s => is_spell_for_class(s, class: class, subclass: subclass))
  let all = ()
  for lvl in range(10) {
    all += filtered
      .filter(s => s.level == lvl)
      .map(s => (..spellFromSpellbook(s), level: lvl))
  }
  deck(
    all,
    cardSize,
    card,
    paper: paper,
    margin: margin,
    cardPadding: cardPadding,
    stroke: stroke,
  )
}
