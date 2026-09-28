Fallback spec review questions, only for repos without a scout. Add legacy question sections of `.zoo/review.md` matching a spec or plan, if any (zoo-tweak-reviews moves them into a scout). Omit `(low-level stage only)` questions at the high-level stage.

1. Is there a simpler end-to-end design that still meets the need?
2. Is a planned chunk, flow, or abstraction not obviously correct at a glance? Can it be planned much more clearly?
3. Is a business rule spread across many planned pieces as an emergent property? Can it be concentrated?
4. Does the plan pessimistically scan, allocate, or copy a large set when a clearly cheaper approach would be no harder?
5. Does the plan add a helper, type, enum, or mechanism that already exists and could be extended?
6. Is any planned change unsafe to deploy in a way the spec does not already acknowledge?
7. Does the spec miss anything the request or ticket implies: edge cases, error paths, legacy data, migrations, settings, permissions, translations, browser flows, tests?
8. Do User request, How it works, Scope, plans, Decisions, or Subtasks contradict each other?
9. Does any spec claim contradict the code? Code wins.
10. Does the spec extend scope in a way that would surprise the user?
11. (low-level stage only) Is the subtask split wrong: a high-level item uncovered, bad ordering, browser impact unflagged, unrelated features or cross-cutting work not separated, fake-progress micro-subtasks?
12. Carefully review the whole spec. Are there any other significant improvements you can suggest?
