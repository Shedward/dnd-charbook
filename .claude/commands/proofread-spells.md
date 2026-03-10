---
description: Style reference for spellbook.json body strings (proofreading complete)
allowed-tools: Read, Bash
---

# Spell Body Style Reference

All 505 spells are proofread. This file is a **reference document** — use it when writing or editing spell bodies manually, or when running `/create-spell`.

For creating new spells, use `/create-spell` instead (it incorporates all rules here).

---

## Body DSL quick reference

```
#damage("Xd6", type, saving: STAT, saved: halfDamage/noDamage, ranged: true)
#heal("Xd8+MOD")
#cure(condition, ...)
#effect(condition, saving: STAT)
#immune(type, ...)   #immuneEffect(condition, ...)
#resist(type, ...)   #weakness(type, ...)
#advantage(STAT/attack)   #disadvantage(STAT/attack)
#speed(N, flying/swimming/climbing/burrowing)
#move(toYou/fromYou, distance: N, saving: STAT)
#light(bright: N, dim: N)
#formula("TOKEN")
#atHigherLevels[text]
Shapes: #circle(N) #sphere(N, range: M) #cube(N) #cone(N) #cylinder(r,h) #rectangle(x,y,z) #straightLine(N)
```

Stat tokens: `STR DEX CON INT WIS CHA MOD PROF LVL`
Damage types: `acid bludgeoning cold fire force lightning necrotic piercing poison psychic radiant slashing thunder`
Conditions: `blinded charmed deafened frightened grappled incapacitated invisible paralyzed petrified poisoned prone restrained stunned unconscious`

---

## Style checklist

1. **Coverage** — all mechanically important details present. Nothing relevant for play omitted.
2. **No column duplication** — do NOT restate: casting time, duration, range/area, component letters.
   - Exception: early-termination conditions ("оканчивается при выходе из купола") are fine.
   - Exception: target count qualifier ("до 6 существ") stays if not visible elsewhere.
3. **No target-field duplication** — if `target` encodes the shape (`circle(15)`, `cube(20, range: 60)`, etc.), do NOT repeat it in `body`. If `target` is `target(N)` (point only), the shape IS useful in body.
4. **No duration duplication** — remove "на 8 ч" / "на X мин" if it matches the duration field. Keep early-termination conditions.
5. **No internal repetition** — each fact stated once.
6. **Readable lists** — multiple distinct effects use `\` line breaks, not comma-run-on sentences.
7. **Length** — 1–3 lines max. Cut all flavor text.
8. **Language** — all prose must be Russian. DSL tokens inside `#macro(…)` are exempt.
9. **Structure order**: primary effect macro → secondary effects → prose exceptions → `#atHigherLevels[…]`

---

## Separator rules

- `\` required between a DSL macro and a following new sentence or distinct effect.
- `\` required before `#atHigherLevels` when preceded by anything.
- No trailing period/comma before `\`: `. \` → ` \`
- Short inline qualifiers modifying the preceding macro are OK without `\`:
  `#advantage(attack) на следующую атаку`

---

## Saving throw rules

- Default `saved:` is `halfDamage` — explicitly write `saved: noDamage` for the majority of spells.
- Use `saved: halfDamage` only when description says "половина при успехе".
- Secondary condition on a failed save — prefix "При провале —", don't restate the stat:
  `#damage("2d6", cold, saving: CON, saved: noDamage)\ При провале — #effect(restrained, saving: CON)`

---

## Symbols to avoid

- `≤` / `≥` — use prose: "3-го ур. и ниже", "4-го ур. и выше", "не более 1 атаки"
- `→` — use "—" or rewrite as prose

---

## Prose style

- Stats in prose: **СИЛ ЛОВ ТЕЛ ИНТ МУД ХАР** (ХАР not СХА). `MOD` only inside `#damage("…+MOD", …)`.
- Lightning damage in prose: "электричество", not "молния".
- "Heavily obscured" → "сильно заслонённая местность".
- Prose before macro when prose qualifies the target count:
  "До 6 существ: #heal(\"1d4+MOD\")" — not "#heal(\"1d4+MOD\") до 6 существ".
- Weapon attack spells: lead with "Рукопашная атака оружием." not the damage macro.
- Cantrip scaling: always `#atHigherLevels[+1кX на уровнях 5, 11 и 17]`, not inline prose.
- No `+#damage(...)` — never prefix macros with `+`.

---

## Render preview

To see how a body string will look rendered:

```bash
scripts/spells-render-body.sh 'body string here'
```

Output abbreviations: псих. некр. огн. кисл. хол. элект. яд. сил. грм. изл. дроб. кол. руб.
