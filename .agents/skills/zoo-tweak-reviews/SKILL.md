---
name: zoo-tweak-reviews
description: "Update the repo's Zoo review setup, including the scout (script that prints each review's questions); create a scout if missing. Use only when explicitly asked."
---

Follow `.zoo/zoo.md`, `.zoo/review.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo tweak reviews start (.spec/example.md) r0`, then `Zoo tweak reviews finished (.spec/example.md) r0` or `Zoo tweak reviews failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Update project's Zoo review setup: `.zoo/review.md` and scout. No scout: create one. Reference design: `references/scout-design.md`, an example for Go; adapt to the repo's language.

While working on scout, skills, or review system:
- Do NOT call scout.
- Do NOT run broad project tests; scout's own tests only.
- Do NOT use Zoo workflow. DO run zoo-reviewer on the diff (questions: zoo-code-review `references/fallback-questions.md` plus the design reference) and commit after each change.

Questions:
- Every repo question: gated (file group or spot source) when possible; plain only if every review in that mode should ask it. Never restate a gated question as plain.
- Rule checkable in files → violation check with a spot source. Judgment call → question at a precise spot. Neither checkable nor spot-able → plain question, or leave in docs.
- Rule about agent command lines, editors, or other state outside the repo → not a check (false confidence). Record rejected ideas in the scout's rejected-checks list.

False positives:
- Sources: reviewer `OK` answers with why on `Violation?` items; recurring entries in task files' `False positive or rejected review findings`. Task-local rejections stay in task files.
- Fix recurring ones in check code, per the design's list. Add the case as a test.
- No suppression comments in code. Found some: remove support and markers; turn recurring reasons into check fixes.

New scout:
- Seed plain questions from zoo-code-review and zoo-spec-review `references/fallback-questions.md`, plus repo rules mined from agent instructions and docs.
- Add next to it: design doc (repo's copy of the reference design, with real names), agent instructions (rules above plus pointer to design doc), rejected-checks list.

Keep `.zoo/review.md` current: `Scout:` line with command, mode flags, range options; what to do when a check is wrong. No questions there.

Legacy:
- Question sections in `.zoo/review.md`, `.zoo/planreview.md`, `.zoo/codereview.md`: move questions into scout per rules above; delete the sections and the other two files.
- `Scout:` line in `.zoo/zoo.md`: move to `.zoo/review.md`.
- `Scripted check command:`, `Review question generator`, or `Spotter:` line in `.zoo/zoo.md`: turn that tool into a scout per the design, put the line in `.zoo/review.md` as `Scout:`, drop its agent-running modes and zoo-check-* agents.
