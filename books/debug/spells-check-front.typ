#import "../../dnd/dnd.typ"

#dnd.core.setLocale("ru")
#dnd.builder.deckOfAllSpells(card: spell => (
  ..dnd.page.spellCard(spell),
  back: [],
))
