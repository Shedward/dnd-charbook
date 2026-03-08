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
# All source IDs (no bodies)
jq '[.[].id]' /Users/shed/Projects/dnd-soup/spells.json

# Already processed IDs
jq '[.[].id]' /Users/shed/Projects/dnd-charbook/resources/data/spellbook.json 2>/dev/null || echo "[]"
```

Take the first N IDs from source that are not in output.

### Step 2 — Read the batch

Read all fields in one query — **include `classes`** or you'll need a second patch pass:
```bash
jq '.[] | select(.id | IN("id1","id2",...)) | {id, level, school, is_ritual, with_concentration, duration, distance, casting_time, components, classes, description}' /Users/shed/Projects/dnd-soup/spells.json
```

Only read `text_spells.json` when needed (concentration spell with `duration: 0.0` → look up actual duration).

### Step 3 — Translate each spell

Apply schema and DSL rules below. Classify complexity as you go:
- **Fast**: direct DSL match (damage + saving throw, heal, simple condition)
- **Medium**: DSL + prose mix, multiple effects
- **Slow**: complex conditional logic, unusual mechanics → `review: true`

### Step 4 — Append batch to spellbook.json

Append all records at once:
```bash
jq '. + [<record1>, <record2>, ...]' /Users/shed/Projects/dnd-charbook/resources/data/spellbook.json > /tmp/sb.json \
  && mv /tmp/sb.json /Users/shed/Projects/dnd-charbook/resources/data/spellbook.json
```

If spellbook.json does not exist yet, create it as `[<record1>, ...]`.

### Step 5 — Verify build

```bash
typst compile books/spellbook-preview.typ --root . build/spellbook-preview.pdf
```

`spellbook-preview.typ` renders only the last 10 spells — use this to check the current batch.
`spellbook-test.typ` renders all spells — use this for full regression after DSL changes.

Fix any DSL eval errors before reporting.

### Step 6 — Report

For each spell: name, `body`, `review` flag.
Summarise: N processed, M flagged for review, any DSL gaps noticed.

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
4. Run `./scripts/buildAll.sh` — must be clean
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
- If `with_concentration: true` and `spells.json` has `duration: 0.0`, read the actual max from `text_spells.json`'s `duration` string and convert:
  - "вплоть до 1 раунда" → `6.0`
  - "вплоть до 1 минуты" → `60.0`
  - "вплоть до 10 минут" → `600.0`
  - "вплоть до 1 часа" → `3600.0`
  - "вплоть до 8 часов" → `28800.0`
  - "вплоть до 24 часов" → `86400.0`

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

### Plain prose fallback
One or two sentences, mechanics only, no flavor. Russian language.
DSL and prose mix freely: `До 3 камней. При попадании — #damage("1d6+MOD", bludgeoning, ranged: true).`

**Stat abbreviations in prose** — use Russian short forms:
| English | Russian prose |
|---------|--------------|
| STR | СИЛ |
| DEX | ЛОВ |
| CON | КОН |
| INT | ИНТ |
| WIS | МДР |
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
| sight | `"sight"` |
| unlimited | `"unlimited"` |

Eval'd with: `target`, `point`, `circle`, `sphere`, `cone`, `cube`, `cylinder`, `rectangle`, `touch`, `self`, `sight`, `unlimited` in scope.

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
