---
description: Create a new spellbook.json entry from a spell description
allowed-tools: Read, Write, Bash
---

# Create Spell

Takes a spell description provided by the user and produces a complete, ready-to-use `spellbook.json` record following all DSL and style rules.

---

## Workflow

### Step 1 — Parse the input

The user provides a spell description. Extract or ask for:
- English name (used as `id` in kebab-case and `original_name`)
- Russian name (`name`)
- Level (0–9)
- School (`abjuration` `conjuration` `divination` `enchantment` `evocation` `illusion` `necromancy` `transmutation`)
- Ritual? concentration?
- Casting time, duration, range/area, components, classes
- Full mechanical description

If any required field is missing and cannot be inferred, ask before proceeding.

### Step 2 — Build the record

Produce a JSON object matching the schema below. Apply all DSL and style rules.

### Step 3 — Verify the body renders

```bash
scripts/spells-render-body.sh 'body string here'
```

Check the output for missing `\` separators, wrong structure, or unexpected text.

### Step 4 — Output the record

Print the final JSON. Then ask: **"Append to spellbook.json?"**

If yes:
```bash
scripts/spells-append.sh '[<record>]'
scripts/spells-preview.sh --full
```

Fix any build errors before confirming.

---

## Output record schema

```json
{
  "id": "kebab-case-english-name",
  "name": "Русское название",
  "original_name": "English Name",
  "level": 0,
  "school": "evocation",
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
  "classes": [{ "class": "wizard" }],
  "body": "typst DSL string or short prose"
}
```

### Field rules

**`id`** — kebab-case of the English name. Lowercase, hyphens only.

**`duration`** — seconds as a float:
- Instant → `0.0`
- 1 round → `6.0`
- 1 minute → `60.0`
- 10 minutes → `600.0`
- 1 hour → `3600.0`
- 8 hours → `28800.0`
- 24 hours → `86400.0`
- Permanent until dispelled → `null`

**`target`** — derived from range/area:

| Range/area | target string |
|---|---|
| Single target, N ft | `"target(N)"` |
| Touch | `"touch"` |
| Self only | `"self"` |
| Self + radius N ft | `"circle(N)"` |
| Self + cone N ft | `"cone(N)"` |
| Sphere radius R at range N | `"sphere(R, range: N)"` |
| Cube side S at range N | `"cube(S, range: N)"` |
| Cylinder radius R, height H at range N | `"cylinder(R, H, range: N)"` |
| Rectangle X×Y×Z at range N | `"rectangle(X, Y, Z, range: N)"` |
| Line length L | `"straightLine(L)"` |
| Sight | `"sight"` |
| Unlimited | `"unlimited"` |

Use `target(N)` **only** for single-target spells. Always use a shape function for area-of-effect.

**`components.material`** — strip ", расходуемые заклинанием" and similar suffixes; the renderer appends "(расходуется)" when `material_consumed: true`.

---

## Body DSL

Evaluated by Typst: `eval(spell.body, scope: spellBodyDSLScope, mode: "markup")`.

### Damage
```
#damage("1d6", acid)
#damage("8d6", fire, saving: DEX, saved: halfDamage)
#damage("2d10", force, saved: noDamage)
#damage("1d6+MOD", bludgeoning, ranged: true)
```
- Default `saved:` is `halfDamage` — **must** write `saved: noDamage` for spells that deal no damage on a successful save (the majority).
- `ranged: true` only for ranged spell attacks. Never on melee attacks.
- Formula tokens: `STR` `DEX` `CON` `INT` `WIS` `CHA` (stat modifiers), `MOD` (spellcasting modifier), `PROF` (proficiency bonus), `LVL` (character level).

### Healing
```
#heal("1d8+WIS")
#heal("70")
```

### Conditions
```
#effect(charmed, saving: WIS)
#effect(prone)
```
- Always add `saving: STAT` when the target makes a save to resist the condition.
- Automatic (no-save) effects omit `saving:`.

Valid conditions: `blinded` `charmed` `deafened` `frightened` `grappled` `incapacitated` `invisible` `paralyzed` `petrified` `poisoned` `prone` `restrained` `stunned` `unconscious`

### Curing conditions
```
#cure(blinded, poisoned, disease)
```
Variadic — combine into one call. Use `disease` constant for disease removal.

### Resistance / vulnerability / immunity
```
#resist(bludgeoning, piercing, slashing)
#weakness(fire)
#immune(fire, cold)
#immuneEffect(charmed, frightened)
```
`#immune` = damage type immunity. `#immuneEffect` = condition immunity.

### Movement
```
#move(toYou, distance: 10)
#move(fromYou, distance: 10, saving: STR)
```

### Movement speed
```
#speed(40, flying)
#speed(30, swimming)
#speed(20, climbing)
#speed(20, burrowing)
#speed("÷2")
#speed("+10")
```
Integer auto-appends "фт". String displays as-is (use for modifiers). Omit type for base walking speed.

### Advantage / disadvantage
```
#advantage(attack)
#advantage(STR)
#disadvantage(DEX)
```

### Light
```
#light(bright: 20, dim: 20)
#light(bright: 0, dim: 10)
```

### Shapes (secondary areas in body)
```
#circle(N)    #sphere(N, range: M)
#cube(N)      #cone(N)
#cylinder(r, h)   #rectangle(x, y, z)
#straightLine(N)
```
Use **only** for shapes NOT already encoded in the `target` field.

### Inline formula
```
#formula("MOD")   #formula("PROF")   #formula("WIS")
```
Use when a spell grants a numeric bonus equal to a stat (e.g. `#formula("MOD") врем. ОЗ`).

### Higher levels
```
#atHigherLevels[+1к6 за слот выше 1-го]
```
Always last. Always preceded by `\`.

### Combining effects
Separate distinct effects with `\` (Typst line break):
```
#damage("3d6", cold, saving: CON, saved: noDamage)\ #effect(restrained, saving: CON)
```

### Damage types
`acid` `bludgeoning` `cold` `fire` `force` `lightning` `necrotic` `piercing` `poison` `psychic` `radiant` `slashing` `thunder`

---

## Body style rules

### Structure order
1. Primary effect DSL macro (`#damage`, `#heal`, `#effect`)
2. Secondary effects
3. Prose exceptions / conditions
4. `#atHigherLevels[…]` — always last

### Content rules

1. **Coverage** — all mechanically important details present. Nothing relevant for play omitted.

2. **No duplication of visible columns** — do NOT restate: casting time, duration, range/area, component letters. They appear in other columns.
   - Exception: early-termination conditions ("оканчивается при выходе из купола") are fine.
   - Exception: target count qualifier ("до 6 существ") stays if not visible elsewhere.

3. **No target-field duplication** — if `target` encodes the shape (`circle(15)`, `cube(20, range: 60)`, etc.), do NOT repeat that shape in `body`. If `target` is `target(N)` (point range only), the area shape IS useful in body.

4. **No duration duplication** — remove "на 8 ч" / "на X мин" from body when it matches the duration field. Keep early-termination conditions.

5. **No internal repetition** — each fact stated once.

6. **Readable lists** — multiple distinct effects use `\` line breaks, not comma-run-on sentences.

7. **Length** — 1–3 lines max. Cut all flavor. Cut re-statements of other fields.

8. **Language** — all prose must be Russian. DSL tokens inside `#macro(…)` are exempt.

9. **No forbidden symbols:**
   - `≤` / `≥` → use prose: "3-го ур. и ниже", "4-го ур. и выше", "не более 1 атаки"
   - `→` → use "—" or rewrite as prose

### Separator rules

- `\` required between a DSL macro and following prose (new sentence or distinct effect).
- `\` required before `#atHigherLevels` when preceded by anything.
- No trailing period/comma before `\`: `. \` → ` \`
- Short inline qualifiers modifying the preceding macro are fine without `\`: `#advantage(attack) на следующую атаку`

### Saving throw rules

- Default `saved:` is `halfDamage` — explicitly write `saved: noDamage` for the majority of spells.
- Use `saved: halfDamage` only when the description says "половина при успехе" or "half on a success".
- Secondary condition on failed save: prefix with "При провале —", don't restate the stat:
  `#damage("2d6", cold, saving: CON, saved: noDamage)\ При провале — #effect(restrained, saving: CON)`

### Prose style

- Stats in prose: **СИЛ ЛОВ ТЕЛ ИНТ МУД ХАР** (ХАР not СХА). `MOD` only inside `#damage("…+MOD", …)`.
- Lightning damage type in prose: "электричество", not "молния".
- "Heavily obscured" → "сильно заслонённая местность" (not "тяжело заслоняет").
- Avoid obscure words: "тактильного" → "физического".
- Prose before macro when prose qualifies the target count:
  "До 6 существ: #heal(\"1d4+MOD\")" — not "#heal(\"1d4+MOD\") до 6 существ".
- Weapon attack spells: lead with "Рукопашная атака оружием." not the damage macro.
- Cantrip scaling: always `#atHigherLevels[+1кX на уровнях 5, 11 и 17]`, not inline prose.
  Exception: weapon-attack cantrips with complex scaling (booming-blade, etc.) — use prose inside `#atHigherLevels[…]`.
- No `+#damage(...)` syntax — never prefix macros with `+`.

---

## Typst pitfalls

- **`if/else` must be on one line** — in markup mode, a newline before `else` renders "else" as literal text.
- **Escape quotes inside body** — inner `"` must be `\"`: `#damage(\"1d6\", fire)`.
- **`#square()` does not exist** — use prose "Квадрат N фт" instead.
- **`#ring()` is not a distinct shape yet** — use prose or `#circle()`.

---

## Examples

| Spell | body |
|-------|------|
| Acid Splash | `#damage("1d6", acid, saving: DEX, saved: noDamage)\ #atHigherLevels[+1к6 на уровнях 5, 11 и 17]` |
| Fireball | `#damage("8d6", fire, saving: DEX, saved: halfDamage)\ #atHigherLevels[+1к6 за слот выше 3-го]` |
| Cure Wounds | `#heal("1d8+WIS")\ #atHigherLevels[+1к8 за слот выше 1-го]` |
| Hold Person | `#effect(paralyzed, saving: WIS) повторяет в конце хода` |
| Thunderwave | `#damage("2d8", thunder, saving: CON, saved: noDamage)\ При провале — #move(fromYou, distance: 10, saving: CON)` |
| Bless | `До 3 существ: #advantage(attack) и спасброски.\ #atHigherLevels[+1 существо за слот выше 1-го]` |
| Misty Step | `Бонусное действие. Телепортация в видимое свободное место.` |
| Mage Armor | `КД = 13 + ЛОВ (только без доспехов).` |
