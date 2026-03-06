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

All reusable code lives under `dnd/`, which is split into four modules re-exported by `dnd/dnd.typ`:

- **`dnd/core/`** — Layout primitives, styling, graphics utilities, localization (`loc`), dimensions, and resource helpers. Import as `dnd.core.*`.
- **`dnd/game/`** — D&D data model: `character()` constructor, stat/skill constants and calculations (modifiers, spell DC, proficiency bonus), spell definitions and helper functions, abilities, proficiencies, and biography structures.
- **`dnd/page/`** — Page layout components that compose game data into rendered pages: cover, attacks, spells, abilities, proficiencies, inventory, quests, biography, and character list pages.
- **`dnd/data/`** — Data loading (wraps `resources/data/spells.json`) and spellbook filtering utilities.

### Character book pattern

Each file in `books/` follows this structure:

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

**Localization:** All user-facing strings use `loc(en: "...", ru: "...")`. The active locale is set once per book with `#setLocale("en"|"ru")` and resolved via Typst's `context` + metadata query system.

**Character context:** `setCharacter()` stores the character dict as metadata; page components retrieve it via `resolveForCharacter()`. This avoids passing the character dict to every function call.

**Level-dependent values:** `byLevelMethod(dict)` takes a dictionary keyed by level strings (threshold-based, e.g. `"1": 2, "4": 3`) and returns a function that resolves to the correct value for the character's current level. Used for spell slots, cantrip counts, etc.

**Formulas:** `roll("2d6+STR")` and `formula("PROF+DEX")` evaluate expressions using the current character's stats. `STR`, `DEX`, `CON`, `INT`, `WIS`, `CHA`, `PROF`, and `LVL` are substituted automatically.

**Resources:** Icons are in `resources/icons/`, spell data in `resources/data/spells.json`.
