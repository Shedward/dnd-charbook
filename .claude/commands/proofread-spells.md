---
description: Proofread existing spellbook.json entries for style and correctness
allowed-tools: Read, Write, Bash
---

# Spell Proofreading Pipeline

## Source files
- `/Users/shed/Projects/dnd-charbook/resources/data/spellbook.json` — records to proofread
- `/Users/shed/Projects/dnd-soup/text_spells.json` — authoritative Russian descriptions
- Test book: `books/spellbook-test.typ` → `build/spellbook-test.pdf`

## Scripts (pre-approved — no confirmation needed)
All live in `scripts/` relative to the project root.

---

## Batch size

**20 spells** per invocation, unless the user specifies otherwise.

---

## Workflow

### Step 1 — Find next batch

```bash
scripts/spells-pending-proofread.sh 20
```

Returns a JSON array of the first 20 spell IDs without `"proofread": true`.
If it returns `[]` — all spells are done.

### Step 2 — Read current records from spellbook.json

```bash
jq '[.[] | select(.id | IN("id1","id2",...))] | map({id, target, body, description})' resources/data/spellbook.json
```

Always fetch `target` alongside `body` and `description` — you need `target` to know what's already shown in the target column (and therefore what NOT to duplicate in `body`).

The `description` field is always populated. Only fall back to `scripts/spells-read.sh --text id …` if a description looks wrong or truncated.

### Step 3 — Review each spell

Compare `body` against the full description and the `target` field. Apply the style checklist and common-issues list below.
Set `"proofread": true` and `"review": false` on every spell regardless of whether it was changed.

### Step 3.5 — Optional: check how a body renders

When uncertain how a body actually looks rendered:

```bash
scripts/spells-render-body.sh 'body string here'
```

Outputs a plain-text Russian line showing what will appear in the spell table.
Useful for catching missing `\` separators and structure issues.

**Reading the output** — damage type abbreviations: псих. некр. огн. кисл. хол. элект. яд. сил. грм. изл. дроб. кол. руб.
Saving throws show as e.g. `МУД или`. Movement shows as e.g. `СИЛ или Притяг. 10 фт`. Scaling shows as `Выс. ур.: …`

### Step 4 — Apply all changes via jq

Use `jq --arg` to patch spellbook.json directly:

```bash
TMP=$(mktemp)
jq \
  --arg spell1_body 'new body for spell1' \
  --arg spell2_body 'new body for spell2' \
  'map(
    if .id == "spell1" then . + {"body": $spell1_body, "review": false, "proofread": true}
    elif .id == "spell2" then . + {"body": $spell2_body, "review": false, "proofread": true}
    elif (.id | IN("spell3","spell4","spell5")) then . + {"review": false, "proofread": true}
    else . end
  )' resources/data/spellbook.json > "$TMP" && mv "$TMP" resources/data/spellbook.json
```

**Escaping rules for `--arg` values (bash single quotes):**
- Single-quoted strings preserve `\` and `"` literally — no escaping needed
- A Typst line break `\` becomes a literal `\` in the value; jq JSON-encodes it as `\\` automatically
- Inner `"` in DSL calls (e.g. `#damage("1d6", ...)`) are preserved as-is

**Group unchanged spells** into a single `IN(...)` branch — avoids repeating `.+ {"review": false, "proofread": true}` per spell.

### Step 5 — Verify build

```bash
scripts/spells-preview.sh --full
```

Fix any DSL eval errors before committing.

### Step 6 — Report

List each changed spell: name + what was fixed.
Summary line: "N reviewed, M changed."

### Step 7 — Commit

```bash
git add resources/data/spellbook.json
git commit -m "Proofread spells batch N: level X (first-id through last-id)"
```

---

## Style checklist

Apply to every spell. Check each point:

1. **Coverage** — `body` contains all mechanically important details from the description. Nothing relevant for actual play omitted.

2. **No duplication of visible fields** — Do NOT restate: casting time, duration, range/area, component letters. These are shown in other columns.
   - Exception: early-termination conditions are fine ("оканчивается при выходе из купола").
   - Exception: target count or key qualifier ("до 6 существ") can stay if it's not visible elsewhere.

3. **No duplication of the `target` field** — if the `target` field already encodes the shape (e.g. `cylinder(40, 20, range: 150)`, `circle(15)`, `cube(20, range: 60)`), do NOT restate that shape in `body`. If `target` is just `target(N)` (a single point), the area shape IS useful in `body` (e.g. "Куб 40 фт").

4. **No internal repetition** — each mechanical fact stated exactly once.

5. **Readable lists** — multiple distinct options must use `\` line breaks, not a comma-run-on sentence.

6. **Length** — 1–3 lines max. Cut all flavor text. Cut re-statements of other fields.

7. **Abbreviations** — use only clear universal ones:
   - Stats: СИЛ ЛОВ ТЕЛ ИНТ МУД ХАР
   - Common: ОЗ КД фт мин ч к4 к6 к8 к10 к12 к20
   - Spacing: always "10 фт" (space before фт), "р. 10 фт" (space after р.)
   - Avoid anything a player might not immediately recognize

8. **Language** — all prose must be Russian. DSL tokens inside `#macro(…)` are exempt (they render to icons/labels, not raw text).

9. **Coherent structure** — consistent order across all spells:
   - DSL macro for the primary effect first (`#damage`, `#heal`, `#effect`)
   - Secondary effects after
   - Prose exceptions/conditions last
   - `#atHigherLevels[…]` always last

10. **`review` flag** — always set to `false`. Proofreading is the final pass.

---

## Common issues (found across batches 1–12)

### Separators

- **Missing `\` between a DSL macro and following prose** — the most common issue.
  `#damage("3d8", radiant, saving: WIS)\ Тип — некрот. если заклинатель злой.`
- **Missing `\` before `#atHigherLevels`** — must always have `\` before it when preceded by anything.
- **Stray punctuation before `\`** — remove trailing period/comma: `. \` → ` \`.
- **Inline short qualifiers are OK without `\`** — a short qualifier that directly modifies the preceding macro doesn't need `\`: `#advantage(attack) на следующую атаку` is fine on one line. The `\` rule applies to new sentences or distinct effects.

### Saving throws

- **`saved: noDamage` vs `saved: halfDamage`** — DSL default is `halfDamage`. Most spells deal NO damage on a successful save, so explicitly write `saved: noDamage`. Only use `saved: halfDamage` when the description explicitly says "половина при успехе" or "half on a success".
- **Secondary effects of a failed save** — use DSL macros with a "При провале —" prose prefix:
  `#damage("2d6", cold, saving: CON, saved: noDamage)\ При провале — #effect(restrained, saving: CON)`
  Do NOT restate the saving throw stat in the "При провале" prose if it's identical to the preceding `saving:`.

### Symbols to avoid

- **`≤` / `≥`** — avoid Unicode comparators; use prose instead:
  - "≤3 ур." → "3-го ур. и ниже"
  - "≥4 ур." → "4-го ур. и выше"
  - "≤1 атаки" → "не более 1 атаки"
- **Arrow `→`** — avoid; use prose instead.

### Duplication / coverage

- **Duration duplication** — if body says "на 8 ч" or "на X мин" matching the duration field exactly, remove it. Exception: early-termination conditions ("оканчивается при выходе") are fine.
- **Aura radius** — if `target` is `circle(N)`, the radius is already shown; remove "Аура р. N фт" from body. If `target` is `self` or `touch` and the spell creates an aura, the radius IS useful in body.
- **Missing key conditions** — common omissions:
  - "цель должна вас слышать" (vicious-mockery, motivational-speech, etc.)
  - "не враждебного" (friends)
  - Alignment-dependent damage type (spirit-guardians: "некрот. если заклинатель злой")

### Prose style

- **"Тяжело заслоняет" is wrong** — correct term is "сильно заслонённая местность" (heavily obscured).
- **"молния" vs "электричество"** — for the lightning damage type in prose, use "электричество" (matches source descriptions), not "молния" (which is the spell name).
- **Obscure words**: "тактильного" → "физического", "триггер" → describe the trigger in Russian.
- **Level scaling in prose** — use МУД/СИЛ/etc., not MOD. MOD is only valid inside `#damage("...+MOD", ...)`.
- **Prose before macro is cleaner** when prose qualifies how many targets receive an effect:
  "До 6 существ: #heal(\"1d4+MOD\")" — not "#heal(\"1d4+MOD\") до 6 существ".

### DSL structure

- **`+#damage(...)` syntax** — do NOT prefix with `+`; just use `#damage(...)` — context makes "additional" clear.
- **Cantrip scaling** — always `#atHigherLevels[+1кX на уровнях 5, 11 и 17]`, not inline prose. Exception: weapon-attack cantrips with complex multi-value scaling (booming-blade, green-flame-blade) — use prose inside `#atHigherLevels[…]`.
- **Weapon attack spells** — lead with "Рукопашная атака оружием." not the damage macro; the attack roll is separate from the damage DSL.
- **`review: true` spells** — set to `false` during proofread (final pass). Only leave `true` if there is a genuine unresolved mechanical question.
- **Weather prediction** in druidcraft-style spells: "(1 раунд)" → "на следующие 24 ч".

---

## DSL behavior notes

### Variadic functions
`#resist(bludgeoning, piercing, slashing)` — comma-separated, renders as "Сопр.: дроб., кол., руб."
`#immune(type1, type2)`, `#weakness(type1, type2)` — same pattern.
`#cure(disease, blinded, poisoned)` — renders as "Снимает: Болезнь, Ослеплён, Отравлен". Use `disease` constant for disease removal.

### Optional saving throw
`#effect(prone, saving: DEX)` — shows condition icon + DEX save indicator.
`#effect(prone)` — works fine with no save (automatic effect, no save indicator shown).
`#move(fromYou, distance: 10)` — works without `saving:` (automatic push, no save shown).
`#move(fromYou, distance: 10, saving: STR)` — shows STR save.

### `#effect` saving throw stat in area spells
Area spells that impose prone on entry (sleet-storm, etc.) use `#effect(prone, saving: DEX)` — always check that the correct stat is specified.

### `#damage` defaults
Default `saved:` is `halfDamage` — must write `saved: noDamage` explicitly for the majority of spells.
Default `ranged:` is false — write `ranged: true` for ranged attacks.

### `#speed` with string value
`#speed(40, flying)` — integer appends "фт" automatically.
`#speed("÷2")` or `#speed("+10")` — string displays as-is (for speed modifiers, halving, etc.).

### `#formula("TOKEN")`
Renders a formula token as a computed number. Use when a spell grants a numeric bonus equal to a stat modifier (e.g. temp HP = MOD → `#formula("MOD") врем. ОЗ`).

### Shapes in body vs target
Shapes (`#circle`, `#cube`, `#cone`, etc.) work inline in `body` for secondary areas not already shown in `target`. Do NOT repeat a shape that's already encoded in the `target` field.

---

## DSL vocabulary (for reference)

All tokens available in `body`:

```
#damage("Xd6", type, saving: STAT, saved: halfDamage/noDamage, ranged: true)
#heal("Xd8+WIS")
#cure(condition, ...)
#effect(condition, saving: STAT)
#immune(damageType, ...)   #immuneEffect(condition, ...)
#resist(type, ...)   #weakness(type, ...)
#advantage(STAT/attack)   #disadvantage(STAT/attack)
#speed(N, flying/swimming/climbing/burrowing)
#light(bright: N, dim: N)
#move(toYou/fromYou, distance: N, saving: STAT)
#formula("TOKEN")
#atHigherLevels[text]
Shapes: #circle(N) #sphere(N, range: M) #cube(N) #cone(N) #cylinder(r,h) #rectangle(x,y,z) #straightLine(N)
```

Stat tokens: `STR` `DEX` `CON` `INT` `WIS` `CHA` `MOD` `PROF` `LVL`
Damage types: `acid` `bludgeoning` `cold` `fire` `force` `lightning` `necrotic` `piercing` `poison` `psychic` `radiant` `slashing` `thunder`
Conditions: `blinded` `charmed` `deafened` `frightened` `grappled` `incapacitated` `invisible` `paralyzed` `petrified` `poisoned` `prone` `restrained` `stunned` `unconscious`

---

## Progress check

```bash
jq '[.[] | select(.proofread == false or .proofread == null)] | length' resources/data/spellbook.json
```

## Progress log

| Batch | Spells | Done | Total | % |
|-------|--------|------|-------|---|
| 1 | acid-splash → infestation (cantrips) | 20 | 505 | 4% |
| 2 | frostbite → shape-water (cantrips) | 40 | 505 | 8% |
| 3 | thaumaturgy → armor-of-agathys (lvl 0–1) | 60 | 505 | 12% |
| 4 | mage-armor → illusory-script (lvl 1) | 80 | 505 | 16% |
| 5 | unseen-servant → jump (lvl 1) | 100 | 505 | 20% |
| 6 | false-life → shield (lvl 1) | 120 | 505 | 24% |
| 7 | shield-of-faith → borrowed-knowledge (lvl 1–2) | 140 | 505 | 28% |
| 8 | protection-from-poison → zone-of-truth (lvl 2) | 160 | 505 | 32% |
| 9 | detect-thoughts → tashas-mind-whip (lvl 2) | 180 | 505 | 36% |
| 10 | flaming-sphere → wither-and-bloom (lvl 2) | 200 | 505 | 40% |
| 11 | hold-person → catnap (lvl 2–3) | 220 | 505 | 44% |
| 12 | spirit-guardians → motivational-speech (lvl 3) | 240 | 505 | 48% |
| 13 | nondetection → summon-lesser-demons (lvl 3) | 260 | 505 | 51% |
| 14 | vampiric-touch → aura-of-purity (lvl 3) | 280 | 505 | 55% |
| 15 | sickening-radiance → arcane-eye (lvl 4) | 300 | 505 | 59% |
| 16 | hallucinatory-terrain → compulsion (lvl 4) | 320 | 505 | 63% |
| 17 | elemental-bane → contagion (lvl 4–5) | 340 | 505 | 67% |
| 18 | legend-lore → raise-dead (lvl 5) | 360 | 505 | 71% |
| 19 | animate-objects → holy-weapon (lvl 5) | 380 | 505 | 75% |
| 20 | wall-of-force → wall-of-ice (lvl 5–6) | 400 | 505 | 79% |
| 21 | arcane-gate → contingency (lvl 6) | 420 | 505 | 83% |
| 22 | summon-fiend → draconic-transformation (lvl 6–7) | 440 | 505 | 87% |
| 23 | delayed-blast-fireball → forcecage (lvl 7) | 460 | 505 | 91% |
| 24 | plane-shift → power-word-stun (lvl 7–8) | 480 | 505 | 95% |

_Update after each batch: add a row with batch number, first–last spell id, running done count, and %._
