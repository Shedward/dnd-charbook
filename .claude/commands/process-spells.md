---
description: Process next unprocessed spell into spellbook.json
allowed-tools: Read, Write, Edit, Bash
---

# Spell Processing Pipeline

## Source files
- `/Users/shed/Projects/dnd-soup/spells.json` — structured data
- `/Users/shed/Projects/dnd-soup/text_spells.json` — Russian display strings
- Output: `/Users/shed/Projects/dnd-charbook/resources/data/spellbook.json`

## Workflow (one spell per invocation)

### Step 1 — Find next unprocessed spell

Extract just the ID list from spells.json (no record bodies):
```bash
jq '[.[].id]' /Users/shed/Projects/dnd-soup/spells.json
```

Extract already-processed IDs from output file:
```bash
jq '[.[].id]' /Users/shed/Projects/dnd-charbook/resources/data/spellbook.json 2>/dev/null || echo "[]"
```

Find the first ID in source that is not in output. That is the target spell.

### Step 2 — Read only that one spell

```bash
jq '.[] | select(.id == "TARGET_ID")' /Users/shed/Projects/dnd-soup/spells.json
jq '.[] | select(.id == "TARGET_ID")' /Users/shed/Projects/dnd-soup/text_spells.json
```

### Step 3 — Translate to output record

Produce one JSON record using the schema and DSL rules below.

### Step 4 — Append to spellbook.json

If spellbook.json does not exist, create it as `[<record>]`.
Otherwise use `jq '. + [<record>]'` to append and write back.

### Step 5 — Report

Print: spell name, `body` field, and whether `review: true` was set.

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

Fields `casting_time`, `components`, `classes` come from `spells.json` as-is.
`target` is a Typst DSL string translated from `spells.json`'s `distance` field (see table below).
`description` is the full text from either source.
`body` is the translated compact form (see DSL below).

---

## DSL vocabulary for `body`

Evaluated by Typst with `eval(spell.body, scope: dsl_scope, mode: "markup")`.

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

### Conditions
```
#effect(charmed, saving: WIS)
#effect(frightened)
```
Valid conditions: blinded, charmed, deafened, frightened, grappled, incapacitated,
invisible, paralyzed, petrified, poisoned, prone, restrained, stunned, unconscious

### Advantages / disadvantages
```
#advantage(CHA)
#disadvantage(attack)
```

### Resistance / vulnerability
```
#resist(fire)
#weakness(piercing)
```

### At higher levels
```
#atHigherLevels[+1d6 per slot above 1st]
```

### Light
```
#light(bright: 20, dim: 20)
```

### Movement
```
#move(fromYou, distance: 10)
#move(toYou, distance: 10)
```

### Plain prose fallback
One or two sentences, mechanics only, no flavor. Russian language.

### Combining effects
Separate with `\` (Typst line break):
```
#damage("3d6", cold, saving: CON)\ #effect(restrained, saving: CON)
```

---

## Translation rules

1. Strip all flavor text — keep only mechanical effects
2. Map primary effect to DSL if a clean match exists
3. Remaining effects: condense to 1-2 sentences of prose
4. DSL and prose can mix freely — e.g. `"До 3 камней. При попадании — #damage(\"1d6+MOD\", bludgeoning, ranged: true)."`
5. Set `"review": true` only when a human decision is genuinely needed:
   - Unusual mechanic with no DSL equivalent (dynamic values, multi-step conditionals)
   - Uncertain about saving throw stat
   - Complex multi-target or conditional logic
   - Do NOT set `review: true` just because the spell is wordy — prose handles that

## Cantrip scaling

Most damage cantrips scale identically: +1d6 at levels 5, 11, 17. Use:
```
#atHigherLevels[+1к6 на уровнях 5, 11 и 17]
```

## `target` field — translating from `distance` in spells.json

| `distance` in spells.json | `target` string |
|---|---|
| `{"type":"range","distance":N}` | `"target(N)"` |
| `{"type":"touch"}` | `"touch"` |
| `{"type":"self"}` | `"self"` |
| `{"type":"self","shape":{"type":"radius","size":N}}` | `"circle(N)"` |
| `{"type":"range","distance":N,"shape":{"type":"sphere","size":R}}` | `"sphere(R, range: N)"` |
| `{"type":"range","distance":N,"shape":{"type":"cone","size":S}}` | `"cone(S, range: N)"` |
| `{"type":"range","distance":N,"shape":{"type":"cube","size":S}}` | `"cube(S, range: N)"` |

The string is `eval()`'d by Typst with `target`, `point`, `circle`, `sphere`, `cone`, `cube`, `cylinder`, `rectangle`, `touch`, `self`, `sight`, `unlimited` in scope.

---

## Examples

| Spell | body | review |
|-------|------|--------|
| Acid Splash | `#damage("1d6", acid, saving: DEX)\ #atHigherLevels[+1к6 на уровнях 5, 11 и 17]` | — |
| Sword Burst | `#damage("1d6", force, saving: DEX)\ #atHigherLevels[+1к6 на уровнях 5, 11 и 17]` | — |
| Magic Stone | `До 3 камней (60 фт). При попадании — #damage("1d6+MOD", bludgeoning, ranged: true).` | — |
| Mage Hand | `Призрачная рука манипулирует предметами до 10 фунтов (4,5 кг). Не атакует и не активирует магические предметы.` | — |
| Control Flames | Prose describing 4 utility options | ✓ |
| Charm Person | `#effect(charmed, saving: WIS)` | — |
| Fireball | `#damage("8d6", fire, saving: DEX)\ #atHigherLevels[+1к6 за слот выше 3-го]` | — |
| Cure Wounds | `#heal("1d8+WIS")` | — |
| Dancing Lights | `#light(bright: 0, dim: 10) Четыре источника; можно объединять.` | — |
