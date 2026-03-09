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
jq '[.[] | select(.id | IN("id1","id2",...))]' resources/data/spellbook.json
```

### Step 3 — Read original Russian descriptions

```bash
scripts/spells-read.sh --text id1 id2 ...
```

### Step 4 — Review each spell

Compare `body` against the full description. Apply the style checklist below.
Set `"proofread": true` on every spell regardless of whether it was changed.

### Step 4.5 — Optional: check how a body renders

When uncertain how a body actually looks rendered:

```bash
scripts/spells-render-body.sh 'body string here'
```

Outputs a plain-text line of what will appear in the spell table.

### Step 5 — Write updated batch to `/tmp/proofread-batch.json`

Use the `Write` tool (not Bash) to avoid shell-quoting issues with escaped quotes inside body strings.

### Step 6 — Update spellbook.json

```bash
scripts/spells-update.sh "$(cat /tmp/proofread-batch.json)"
```

### Step 7 — Verify build

```bash
scripts/spells-preview.sh --full
```

Fix any DSL eval errors before committing.

### Step 8 — Report

List each changed spell: name + what was fixed.
Summary line: "N reviewed, M changed."

### Step 9 — Commit

```bash
git add resources/data/spellbook.json
git commit -m "Proofread spells batch N: level X (first-id through last-id)"
```

---

## Style checklist

Apply to every spell. Check each point:

1. **Coverage** — `body` contains all mechanically important details from the description. Nothing skippable for actual play omitted.

2. **No duplication of visible fields** — Do NOT restate: casting time, duration, range/area, component letters. These are shown in other columns.
   - Exception: early-termination conditions are fine ("ends if caster moves >60 фт").

3. **No internal repetition** — each mechanical fact stated exactly once.

4. **Readable lists** — multiple distinct options must use `\\` line breaks, not a comma-run-on sentence.

5. **Length** — 1–3 lines max. Cut all flavor text. Cut re-statements of other fields.

6. **Abbreviations** — use only clear universal ones:
   - Stats: СИЛ ЛОВ ТЕЛ ИНТ МУД ХАР
   - Common: ОЗ КД фт мин ч к4 к6 к8 к10 к12 к20
   - Avoid anything a player might not immediately recognize

7. **Language** — all prose must be Russian. DSL tokens inside `#macro(…)` are exempt (they render to icons/labels, not raw text).

8. **Coherent structure** — consistent order across all spells:
   - DSL macro for the primary effect first (`#damage`, `#heal`, `#effect`)
   - Secondary effects after
   - Prose exceptions/conditions last
   - `#atHigherLevels[…]` always last

9. **`review` flag** — always set to `false`. Proofreading is the final review pass; the flag is no longer needed after this.

---

## DSL vocabulary (for reference)

All tokens available in `body`:

```
#damage("Xd6", type, saving: STAT, saved: halfDamage/noDamage, ranged: true)
#heal("Xd8+WIS")
#cure(condition)
#effect(condition, saving: STAT)
#immune(damageType)   #immuneEffect(condition)
#resist(type)   #weakness(type)
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

## Typst markup pitfalls

- **Line breaks**: `\\` (double backslash) in a JSON string, which means `\\\\` if you need to write it in a Bash here-doc. Use the `Write` tool to avoid this.
- **Escaped quotes in body**: inner double quotes must be `\"` in the JSON string.
- **`if/else` must be on one line** in markup mode.

---

## Progress check

```bash
jq '[.[] | select(.proofread != true)] | length' resources/data/spellbook.json
```
