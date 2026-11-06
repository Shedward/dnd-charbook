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

#let _catalogueDeck(
  spells,
  card: spellCard,
  cardSize: (33.33%, 33.33%),
  paper: "a4",
  margin: 5mm,
  cardPadding: 5mm,
  stroke: (paint: silver, thickness: 0.2mm, dash: "dashed"),
) = {
  let cards = spells.sorted(key: s => s.level)
    .map(s => (..spellFromSpellbook(s), level: s.level))
  deck(cards, cardSize, card, paper: paper, margin: margin,
    cardPadding: cardPadding, stroke: stroke)
}

#let deckOfAllSpells(..options) = _catalogueDeck(spellbook(), ..options)

#let deckOfClassSpells(class, subclass: none, ..options) = {
  let spells = spellbook().filter(s => is_spell_for_class(s, class: class, subclass: subclass))
  _catalogueDeck(spells, ..options)
}
