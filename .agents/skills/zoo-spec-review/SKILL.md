---
name: zoo-spec-review
description: "Review task file spec from all angles: flag omissions, fix uncontroversial problems, punt real decisions to user. Requires task file path."
---

Follow `.zoo/zoo.md`, `.zoo/planning.md`, `.zoo/planreview.md` if exists.

Review task file against codebase and research file. Do not start impl/full workflow. Do not run scripted checks. Question: "Is it right?"

Stage:
- `building high-level plan`: review User request, What happened, How it works, Scope, High-level plan, Decisions. Do not demand Low-level plan or Subtasks.
- `high-level plan approved, building low-level plan` or later: also review Low-level plan and Subtasks. Check they match the approved high-level plan. Do not silently rewrite How it works, Scope, or High-level plan.

Questions: from `.zoo/planreview.md` if exists, plus generate 5-10 spec-specific or prompt-specific questions (focus on highest risk/uncertainty/complexity areas), plus builtins below. Merge dups. Omit `(low-level stage only)` questions at the high-level stage. Renumber continuously. Write the list to a temp markdown file outside the repo per `zoo-spec-review/references/questions-file.md`; put that path in the reviewer prompt.

Built-in questions:

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

Run the review in a subagent (general-purpose, read-only), not in the orchestrator. Prompt, with paths filled in:

    Review spec <task file> at stage <stage> against the codebase and research file <research file>. Answer every question in <questions file> following its instructions. Do not modify any file or implement anything; reply with findings only.

Skip findings listed in `False positive or rejected review findings`. If a finding is a false positive or rejected for this task, add it there.

Act on findings (orchestrator):
- Verify each finding against the code first. Fix clear uncontroversial mistakes/omissions in the current stage's sections.
- Material scope or strategy changes: add under `Pending suggestions` → Spec improvements. Extra work the user might want: Scope expansion. Do not apply until the user decides. Orchestrator presents each item per Zoo skill `references/pending-suggestions.md`. If running standalone, present each item, ask what to do, and move decided items out.
- If orchestrator keeps a flagged non-violation, require reason in `Decisions` or list it under `False positive or rejected review findings`.
- Ask user for product decisions, important technical decisions, controversial/unclear technical decisions. Use AskUserQuestion if available; otherwise chat. Give concrete options, recommendation first, consequences. Record answers in `Decisions` marked `(USER)`.
- High-level stage: do not drag the user into package, naming, or test detail.
- Scope extensions: follow Zoo skill `references/change-or-suggestion.md`.
- Decide mundane judgment calls on spot when not worth user attention.
- Log each round/outcome to `## Log`.
- Loop after any update until no findings.
