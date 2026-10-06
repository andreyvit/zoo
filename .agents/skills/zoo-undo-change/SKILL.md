---
name: zoo-undo-change
description: "Undo an already completed change back to the exact prior code. Use only when explicitly asked to remove, undo, or revert a completed change."
---

Follow `.zoo/zoo.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo undo change start (.spec/example.md) r0`, then `Zoo undo change finished (.spec/example.md) r0` or `Zoo undo change failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

When the user asks to remove or undo an already completed change.

Remove unwanted changes such that when squashed with the prior unwanted change, the result is no diff (or only a diff of desirable remaining changes). Go back to the exact prior code from before the unwanted diff, not leaving dangling accidental changes.
