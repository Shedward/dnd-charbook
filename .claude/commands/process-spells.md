---
description: Process next unprocessed spells into spellbook.json
allowed-tools: Read, Write, Edit, Bash
---

# Spell Processing Pipeline

## Source files
- `/Users/shed/Projects/dnd-soup/spells.json` — structured data
- `/Users/shed/Projects/dnd-soup/text_spells.json` — Russian display strings
- Output: `/Users/shed/Projects/dnd-charbook/resources/data/spellbook.json`
- Test book: `books/spellbook-test.typ` → `build/spellbook-test.pdf`

## Scripts (pre-approved — no confirmation needed)
All live in `scripts/` relative to the project root.

---

## Batch size

- Levels 0–2: **15 spells** per invocation
- Levels 3–4: **10 spells**
- Levels 5+: **5 spells** (complex mechanics)

Unless the user specifies otherwise.

---

## Workflow

### Step 1 — Find next unprocessed batch

```bash
scripts/spells-pending.sh <N>
```

Returns a JSON array of the first N unprocessed spell IDs.

### Step 2 — Read the batch

```bash
scripts/spells-read.sh <id1> <id2> ...
```

Returns a JSON array with all fields needed: `id`, `level`, `school`, `is_ritual`, `with_concentration`, `duration`, `distance`, `casting_time`, `components`, `classes`, `description`.

When `duration: 0.0` needs verification, read the Russian text source:
```bash
scripts/spells-read.sh --text <id1> <id2> ...
```

### Step 3 — Translate each spell

Apply schema and DSL rules below. Classify complexity as you go:
- **Fast**: direct DSL match (damage + saving throw, heal, simple condition)
- **Medium**: DSL + prose mix, multiple effects
- **Slow**: complex conditional logic, unusual mechanics → `review: true`

### Step 4 — Append batch to spellbook.json

```bash
scripts/spells-append.sh '<json-array>'
```

Pass all new records as a single JSON array argument. Creates the file if it doesn't exist; writes atomically.

### Step 5 — Verify build

```bash
scripts/spells-preview.sh
```

Renders only the last 10 spells — use this to check the current batch.
For full regression after DSL changes: `scripts/spells-preview.sh --full`

Fix any DSL eval errors before reporting.

### Step 6 — Report

For each spell: name, `body`, `review` flag.
Summarise: N processed, M flagged for review, any DSL gaps noticed.

### Step 6.5 — Commit

After a clean build, commit the batch:

```bash
git add resources/data/spellbook.json
git commit -m "Process spells batch N: M level-X spells (first-id through last-id)"
```

Use the same message style as recent commits (see `git log --oneline -5`).

### When a new schema/rendering rule is discovered

If a fix changes how a field should be stored (e.g. stripping redundant text from `material`):
1. Apply the fix to already-processed spells with a targeted `jq` patch
2. Verify with a query that no instances remain
3. Document the rule in the relevant section of this skill
4. Apply the rule to all subsequent batches

---

## DSL extension

Extend the DSL when a pattern appears **3+ times** in upcoming spells and maps cleanly to a Typst primitive.

**Never extend mid-batch.** Finish the batch with prose, then:
1. Add the function to `dnd/game/spells.typ`
2. Add it to `spellBodyDSLScope` in `dnd/page/spells.typ`
3. Add it to the DSL vocabulary section below
4. Run `scripts/spells-preview.sh --full` — must be clean
5. Go back and fix any `review: true` spells the new function unblocks

---

## Output record schema

```json
{
  "id": "kebab-case string",
  "name": "Russian name",
  "original_name": "English name",
  "level": 0,
  "school": "English enum",
  "is_ritual": false,
  "with_concentration": false,
  "casting_time": { "type": "action", "value": 1, "condition": null },
  "duration": 0.0,
  "target": "target(60)",
  "components": {
    "components": ["V", "S"],
    "material": null,
    "material_required": null,
    "material_consumed": null
  },
  "classes": [{ "class": "string" }],
  "description": "full Russian text",
  "body": "typst DSL string or short prose",
  "review": false
}
```

Fields `casting_time`, `components`, `classes` copied from `spells.json` as-is.

**`duration`** — copy from `spells.json` except:
- If `spells.json` has `duration: null` — the spell is permanent until dispelled. Keep `null`; the renderer shows "Пост." (permanent).
- If `spells.json` has `duration: 0.0` — always verify against `text_spells.json`'s `duration` string. `0.0` can mean instant **or** a real duration that was not encoded (happens for both concentration and non-concentration spells, e.g. animal-messenger has `0.0` but text says "24 часа" → `86400.0`).
  - If `with_concentration: true`, text will read "Концентрация, вплоть до X" — use the X.
  - If `with_concentration: false` and text says "Мгновенная" → keep `0.0` (instant).
  - Conversion table:
    - "вплоть до 1 раунда" → `6.0`
    - "вплоть до 1 минуты" → `60.0`
    - "вплоть до 10 минут" → `600.0`
    - "вплоть до 1 часа" → `3600.0`
    - "вплоть до 8 часов" → `28800.0`
    - "вплоть до 24 часов" / "24 часа" → `86400.0`

**`components.material`** — strip ", расходуемые заклинанием" (and similar) — the renderer already appends "(расходуется)" when `material_consumed: true`.
`target` translated from `spells.json`'s `distance` (see table below).
`description` from either source.
`body` translated compact form (see DSL below).

---

## DSL vocabulary for `body`

Evaluated by Typst: `eval(spell.body, scope: spellBodyDSLScope, mode: "markup")`.

### Damage
```
#damage("1d6", acid)
#damage("8d6", fire, saving: DEX, saved: halfDamage)
#damage("1d10", force, ranged: true)
#damage("1d6+MOD", bludgeoning, ranged: true)
```
Formula tokens: `STR` `DEX` `CON` `INT` `WIS` `CHA` (stat modifiers), `MOD` (spellcasting stat modifier), `PROF` (proficiency bonus), `LVL` (character level).

### Healing
```
#heal("1d8+WIS")
```

### Inline formula value
```
#formula("MOD")
#formula("PROF")
#formula("WIS")
```
Evaluates and displays a formula token as a number. Use when a spell grants a numeric bonus equal to a stat modifier (e.g. temp HP = MOD, bonus = PROF).

### Conditions
```
#effect(charmed, saving: WIS)
#effect(frightened)
```
Valid conditions: `blinded` `charmed` `deafened` `frightened` `grappled` `incapacitated`
`invisible` `paralyzed` `petrified` `poisoned` `prone` `restrained` `stunned` `unconscious`

### Advantage / disadvantage
```
#advantage(STR)
#advantage(attack)
#disadvantage(DEX)
```
Valid targets: any stat token or `attack`.

### Resistance / vulnerability
```
#resist(fire)
#weakness(piercing)
```

### Light
```
#light(bright: 20, dim: 20)
#light(bright: 0, dim: 10)
```

### At higher levels
```
#atHigherLevels[+1к6 за слот выше 1-го]
```

### Shapes (in body or target)
Use to inline geometric areas. Same functions work in both `target` and `body` fields.
```
#circle(20)
#ring(20)           // circle icon for now — TODO: dedicated ring icon
#cube(15)
#sphere(10, range: 60)
#cone(15)
#cylinder(5, 40)
#rectangle(60, 20, 1)
#straightLine(30)
```
All accept an optional `range:` named parameter: `#sphere(20, range: 150)`.

**When to use in body** — shapes in the body that are *not* already shown in the `target` column, or secondary shapes (e.g. a wall that can also form a ring):
```
#rectangle(60, 20, 1) или #ring(20).
```
**When to omit from body** — if the `target` field already shows the same shape, don't repeat it in the body.

### Plain prose fallback
One or two sentences, mechanics only, no flavor. Russian language.
DSL and prose mix freely: `До 3 камней. При попадании — #damage("1d6+MOD", bludgeoning, ranged: true).`

**Stat abbreviations in prose** — use Russian short forms:
| English | Russian prose |
|---------|--------------|
| STR | СИЛ |
| DEX | ЛОВ |
| CON | ТЕЛ |
| INT | ИНТ |
| WIS | МУД |
| CHA | **ХАР** (not СХА) |

### Combining effects
Separate with `\` (Typst line break):
```
#damage("3d6", cold, saving: CON)\ #effect(restrained, saving: CON)
```

### Movement
```
#move(toYou, distance: 10)
#move(fromYou, distance: 10, saving: STR)
```

### NOT YET IMPLEMENTED — use prose

When a pattern appears 3+ times, add it to the DSL (see extension process above).

---

## Typst markup pitfalls

- **`if/else` must be on one line** — in markup mode, `#if cond [...]\nelse [...]` renders `else` as literal text. Always write `#if cond [...] else [...]` on a single line.
- **Escape quotes in body strings** — inner double quotes must be `\"`, e.g. `#damage(\"1d6\", fire)`.

---

## Translation rules

1. Strip all flavor text — keep only mechanical effects
2. Map primary effect to DSL if a clean match exists
3. Remaining effects: condense to 1–2 sentences of prose
4. Set `"review": true` only when a human decision is genuinely needed:
   - Mechanic has no DSL or prose equivalent (too dynamic, too conditional)
   - Uncertain about saving throw stat
   - Complex multi-stage or choose-one-of-N logic
   - **Not** for wordiness — prose handles that

---

## Cantrip scaling

Most damage cantrips scale identically (+1dX at levels 5, 11, 17):
```
#atHigherLevels[+1к6 на уровнях 5, 11 и 17]
```

---

## `target` field — from `distance` in spells.json

| `distance` in spells.json | `target` string |
|---|---|
| `{"type":"range","distance":N}` | `"target(N)"` |
| `{"type":"touch"}` | `"touch"` |
| `{"type":"self"}` | `"self"` |
| `{"type":"self","shape":{"type":"radius","size":N}}` | `"circle(N)"` |
| `{"type":"self","shape":{"type":"cone","size":N}}` | `"cone(N)"` |
| range + sphere | `"sphere(R, range: N)"` |
| range + cone | `"cone(S, range: N)"` |
| range + cube | `"cube(S, range: N)"` |
| range + cylinder | `"cylinder(radius, height, range: N)"` |
| range + rectangle (wall/line) | `"rectangle(x, y, z, range: N)"` |
| self + radius (moves with caster) | `"circle(N)"` |
| ring (radius) | `"ring(N, range: N)"` |
| sight | `"sight"` |
| unlimited | `"unlimited"` |

**Use `target(N)` only for single-target spells.** For any area-of-effect, use the matching shape function.

Eval'd with: `target`, `point`, `circle`, `ring`, `square`, `sphere`, `cone`, `cube`, `cylinder`, `rectangle`, `straightLine`, `touch`, `self`, `sight`, `unlimited` in scope.

---

## Examples

| Spell | body | review |
|-------|------|--------|
| Acid Splash | `#damage("1d6", acid, saving: DEX)\ #atHigherLevels[+1к6 на уровнях 5, 11 и 17]` | — |
| Sword Burst | `#damage("1d6", force, saving: DEX)\ #atHigherLevels[+1к6 на уровнях 5, 11 и 17]` | — |
| Magic Stone | `До 3 камней (60 фт). При попадании — #damage("1d6+MOD", bludgeoning, ranged: true).` | — |
| Mage Hand | `Призрачная рука манипулирует предметами до 10 фунтов (4,5 кг). Не атакует и не активирует магические предметы.` | — |
| Control Flames | Prose — 4 utility options, no DSL equivalent | ✓ |
| Charm Person | prose until `#effect` is implemented | — |
| Fireball | `#damage("8d6", fire, saving: DEX)\ #atHigherLevels[+1к6 за слот выше 3-го]` | — |
| Cure Wounds | `#heal("1d8+WIS")` | — |
