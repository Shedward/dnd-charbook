# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

A [Typst](https://typst.app/) document system for generating D&D 5e character books as PDFs. Each character gets their own `.typ` file in `books/` that produces a formatted A5 PDF.

## Commands

**Build all character books:**
```sh
./scripts/buildAll.sh
```

**Build and watch a single book** (opens in Skim.app):
```sh
./scripts/watch.sh <book-name>
# e.g.: ./scripts/watch.sh marek-grivachov
```

**Build a single book manually:**
```sh
typst compile books/<book-name>.typ --root . build/<book-name>.pdf
```

Requires [Typst](https://typst.app/) to be installed.

## Architecture

### Module structure

All reusable code lives under `dnd/`, which is split into five modules re-exported by `dnd/dnd.typ`:

- **`dnd/core/`** — Layout primitives, styling, graphics utilities, localization (`loc`), dimensions, and resource helpers. Import as `dnd.core.*`.
- **`dnd/game/`** — D&D data model: `character()` constructor, stat/skill constants and calculations (modifiers, spell DC, proficiency bonus), spell definitions and helper functions, abilities, proficiencies, and biography structures.
- **`dnd/page/`** — Page layout components that compose game data into rendered pages: cover, attacks, spells, abilities, proficiencies, inventory, quests, biography, and character list pages.
- **`dnd/data/`** — Data loading (wraps `resources/data/spellbook.json`) and spellbook filtering utilities.

- **`dnd/builder/`** — Character progression, standard book assembly and printable decks. See the [README](README.md) for runnable examples.

### Builder API and decks

Use `books/marek-grivachov.typ` as the reference for a new book. Import `dnd/builder/builder.typ` for mutations and renderers, and `dnd/game/game.typ` for stats and game helpers. Start `build(...)` with `introduce(...)` (default level 0). Mutations run in order. `upgrade(source, ..mutations)` groups changes and labels added abilities, proficiencies and spells with their source. Increment the level explicitly with `levelUp()`. Use `addSpellById(id)` for one catalogue spell and `addClassSpells(class, level)` for a class at one spell level. The result contains cantrips and spells grouped by level.

`charbook(char, locale: "ru")` applies A5 styling, sets the character and locale, and renders the standard pages. Spell, ability, proficiency and biography sections depend on the supplied data.

For cards, set the locale in the deck document. `deckOfSpells(char)` registers the character and prints their spells. `deckOfClassSpells(class, subclass: none)` selects catalogue entries by their stored class/subclass names. Both use `page/deck.typ` for pagination and mirrored backs. Defaults are A4 with a 3 × 3 grid. Override `paper`, `cardSize`, `margin`, `cardPadding` or `stroke` for print layout. The `card` callback returns a dictionary with `front` and `back`; the default in `page/spellCard.typ` fits the description to the back and truncates overflowing text with an ellipsis.

### Manual page composition

Older books compose individual pages directly:

```typ
#import "../dnd/dnd.typ"
#import "../dnd/game/game.typ": *

#show: dnd.core.charbook        // Apply global A5 page styles
#setLocale("ru")                // or "en" — sets language for all loc() calls

#let myChar = dnd.game.character(
  level: 5,
  name: "...",
  stats: (STR: 10, DEX: 14, ...),
  spellcasting: spellcasting(stat: CHA, slots: ...),
  ...
)

#setCharacter(myChar)           // Register character for context-sensitive lookups

// Then compose pages using dnd.page.* components
```

### Key patterns

**Localization:** Shared UI labels use `loc("key", subs: (:))` with entries in `resources/data/localization.json`. English is the fallback. The active locale is set once per book with `#setLocale("en"|"ru")` and resolved via Typst's `context` + metadata query system.

**Character context:** `setCharacter()` stores the character dict as metadata; page components retrieve it via `resolveForCharacter()`. This avoids passing the character dict to every function call.

**Level-dependent values:** `byLevelMethod(dict)` takes a dictionary keyed by level strings (threshold-based, e.g. `"1": 2, "4": 3`) and returns a function that resolves to the correct value for the character's current level. Used for spell slots, cantrip counts, etc.

**Formulas:** `roll("2d6+STR")` and `formula("PROF+DEX")` use stat modifiers from the current character. Both support stat names and the casting modifier `MOD`; `formula` also resolves `PROF` and `LVL`. Without character context they display the expression.

**Resources:** Icons are in `resources/icons/`, spell data in `resources/data/spellbook.json`.

**Resource paths:** Use `/resources/...` (root-relative) not `../../resources/...`. Typst resolves `/` from `--root .` which is the project root. Relative paths break if file depth changes.

### Spellbook

Spell data lives in `resources/data/spellbook.json` (505 spells). Each record has:

```json
{
  "id": "fireball",
  "name": "Огненный шар",
  "original_name": "Fireball",
  "level": 3,
  "school": "evocation",
  "is_ritual": false,
  "with_concentration": false,
  "casting_time": { "type": "action", "value": 1, "condition": null },
  "duration": 0.0,
  "target": "sphere(20, range: 150)",
  "components": { "components": ["V","S","M"], "material": "...", "material_required": true, "material_consumed": false },
  "classes": [{ "class": "wizard" }],
  "body": "#damage(\"8d6\", fire, saving: DEX, saved: halfDamage)\\ #atHigherLevels[+1к6 за слот выше 3-го]"
}
```

`duration` is seconds as a float (`0.0` = instant, `null` = permanent). `target` is a DSL string evaluated by the target parser in `dnd/page/spells.typ`. The card back uses the separate `description` field.

### Spell body DSL

`body` is evaluated via `eval(s.body, scope: spellBodyDSLScope, mode: "markup")` in `dnd/page/spells.typ`. Available functions:

```
#damage("Xd6", type, saving: STAT, saved: halfDamage/noDamage, ranged: true)
#heal("Xd8+MOD")
#cure(condition, ...)          — removes conditions; use disease constant for disease removal
#effect(condition, saving: STAT)
#immune(type, ...)             — damage type immunity
#immuneEffect(condition, ...)  — condition immunity
#resist(type, ...)
#weakness(type, ...)
#advantage(STAT/attack)   #disadvantage(STAT/attack)
#speed(N, flying/swimming/climbing/burrowing)   — spell movement speed effect
#move(toYou/fromYou, distance: N, saving: STAT)
#light(bright: N, dim: N)
#formula("TOKEN")              — renders a stat/formula token as a number
#atHigherLevels[text]          — always last, always preceded by \
Shapes: #circle(N) #sphere(N, range: M) #cube(N) #cone(N) #cylinder(r,h) #rectangle(x,y,z) #straightLine(N)
```

Stat tokens: `STR DEX CON INT WIS CHA MOD PROF LVL`
Damage types: `acid bludgeoning cold fire force lightning necrotic piercing poison psychic radiant slashing thunder`
Conditions: `blinded charmed deafened frightened grappled incapacitated invisible paralyzed petrified poisoned prone restrained stunned unconscious`

Use `/create-spell` to generate a new spell record following all DSL and style rules.

### Typst gotchas

**Spacing:** Use `#v(X)` at the start of block content for entry gaps — Typst suppresses leading vertical space at the top of a column/page, so the first entry gets no gap automatically. Avoid `block(above: X)` as a drop-in replacement: if you also remove a trailing `\`, you silently lose spacing (`\` after a block contributes ~line-height of vertical space).

**Paragraph wrapping:** Never wrap block content in `par()` — it generates "parbreak/block may not occur inside of a paragraph" warnings (one call can produce 20+). Use `block[#set par(...) #body]` to apply paragraph settings, or `#set par(...)` directly inside table cell content.

**Verification:** `buildAll.sh` covers top-level books only. For builder or spell catalogue changes, also compile `books/debug/char-builder-test.typ` or `books/debug/spellbook-test.typ` with `--root .`. For card layout, compile `books/deck-test.typ` and inspect both sides. CI compiles `main.typ`, which includes the Edna book. The spell preview scripts still reference older paths under `books/`; use the debug files directly.

**Checking warnings:** `tail -10` hides most build warnings. Always check: `./scripts/buildAll.sh 2>&1 | grep -i warning`
