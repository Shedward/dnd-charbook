#import "../core/core.typ"

#let toolsProficiency(
  title,
  source: none,
  items: (),
  actions: (),
  skillsEffects: ()
) = (
  title: title,
  source: source,
  items: items,
  actions: actions,
  skillsEffects: skillsEffects
)

#let any = "~"

#let action(
  name,
  dc: none,
  ..args
) = (
  name: name,
  dc: dc,
  body: if args.pos().len() > 0 {
    args.pos().last()
  } else {
    none
  }
)

#let skillEffect(..skills, body) = (
  skills: skills,
  body: body
)
