#import "../../dnd/dnd.typ"

#dnd.core.setLocale("ru")
#dnd.builder.deckOfAllSpells(card: spell => (
  front: dnd.page.spellCardFront(spell),
  back: [],
))
