#import "../core/core.typ"

#let tool = "tool"
#let weapon = "weapon"
#let armor = "armor"
#let music = "music"
#let stat = "stat"
#let skill = "skill"

#let toolsProficiency(
  title,
  source: none,
  items: (),
  actions: (),
  skillsEffects: ()
) = (
  class: tool,
  title: title,
  source: source,
  items: items,
  actions: actions,
  skillsEffects: skillsEffects
)

#let any = "~"

#let toolsAction(
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

#let simpleProficiency(title, source: none) = (
  class: none,
  title: title,
  source: source
)

#let weaponProficiency(title, source: none) = (
  class: weapon,
  title: title,
  source: source
)

#let armorProficiency(title, source: none) = (
  class: armor,
  title: title,
  source: source
)

#let musicProficiency(title, source: none) = (
  class: music,
  title: title,
  source: source
)

#let savingProficiency(stat, source: none) = (
  class: stat,
  title: [Спас. по #stat],
  source: source
)

#let skillProficiency(skill, source: none) = (
  class: stat,
  title: skill,
  source: source
)
