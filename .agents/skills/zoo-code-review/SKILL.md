---
name: zoo-code-review
description: "Code review gate: tests, scripted review (scout questions), visual review. Invokable standalone on any diff or inside Zoo workflow."
---

Follow `.zoo/zoo.md`, `.zoo/review.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo code review start (.spec/example.md) r0`, then `Zoo code review finished (.spec/example.md) r0` or `Zoo code review failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Review `finished` means findings delivered, not resolved; emit before fixes/user decisions.

Review change. If no task/research file, run gate anyway.

If the task file has `## False positive or rejected review findings`, skip those findings. Pass that section into reviewer prompts. Do not re-raise them. Do not record a task-local rejection in source.

Pass task path and revision round (unknown: r?) to every reviewer; require `Zoo review session (<spec path>) rN` as a standalone chat line.

Scripted review: one zoo-reviewer pass over one numbered list.
- Scout (`Scout:` line in `.zoo/review.md`): run first, without mode flags, over the reviewed range: uncommitted changes by default; for a committed range pass the range option `.zoo/review.md` documents. Its output, header included, is the list. `NO QUESTIONS`: nothing to answer. Non-zero exit blocks the gate: fix or report, never read it as no questions.
- No scout: `references/fallback-questions.md`.

Then run in parallel:
- prescribed tests, if not already done
- scripted review in zoo-reviewer with that list and the reviewed range in the prompt
- visual review in zoo-reviewer when UI/screenshots matter: look/feel (spacing, hierarchy, alignment, consistency), target-audience clarity (labels, terms, when to use controls), a11y/light/dark/platform norms, all states/interactions/test plans/harness data, broken controls/flows. Inspect existing screenshots, find gaps, redo/add evidence for all relevant UI states and example files.

Quality bar: active-subtask result passes AND right; other findings are explicitly routed.

Route every finding through Zoo skill `references/change-or-suggestion.md`: scripted review, visual review. Never implement or dismiss routed findings merely because review found them. If a finding is a false positive or rejected for this task, add it to `False positive or rejected review findings`. Never ask user during the gate.
