Questions file: a temp markdown file outside the repo. `mktemp "${TMPDIR:-/tmp}/zoo-spec-questions.XXXXXX"` (X's must trail). Orchestrator writes it each round (fill `<...>`, paste the assembled numbered list); reviewer reads it. Discard after the round.

```
# Spec review questions

Task file: <task file>. Research file: <research file>. Stage: <stage>.

Reviewer rules:
- Read-only. Edit nothing. Findings are your final message.
- Read the task file, the research file, and the code they point at. Check spec claims against code; code wins.
- Stage `building high-level plan`: review User request, What happened, How it works, Scope, High-level plan, Decisions; do not demand Low-level plan or Subtasks. Later stages: also review Low-level plan and Subtasks against the approved high-level plan.
- Skip findings listed under `## False positive or rejected review findings` in the task file.
- Unpushed code can change freely. When judging a planned deletion or edit, compare the result to the pushed codebase (`@{upstream}`, else `origin/master`), not to the current code: dropping what only unpushed work added is fine; a field, tag, job kind, migration, or API present at the pushed point still needs compatibility, even if earlier unpushed commits already changed it.
- Answer every question: `N. OK`, or `N.` + finding: what is wrong, where (section), evidence (`file:line`), proposed fix. Generic concerns are useless. Default `OK`.
- Tag each finding `fix` (clear, uncontroversial) or `decision` (product call, material scope/strategy change, unclear or controversial technical choice).
- Max terse.

Questions:

1. <...>
2. <...>
```
