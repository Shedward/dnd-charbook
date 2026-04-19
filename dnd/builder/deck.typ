#import "../game/character.typ": setCharacter
#import "../page/deck.typ": deck
#import "../page/spellCard.typ": spellCard

#let deckOfSpells(
  char,
  card: spellCard,
  cardSize: (25%, 25%),
  paper: "a4",
  margin: 0mm,
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
    stroke: stroke
  )
}
