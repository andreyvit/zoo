---
name: zoo-spec-review
description: "Review task file spec from all angles: flag omissions, fix uncontroversial problems, punt real decisions to user. Requires task file path."
---

Follow `.zoo/zoo.md`, `.zoo/review.md`, `.zoo/planning.md` and file at `$ZOO_LOCAL_MD` if exists

Review task file against codebase and research file. Do not start impl/full workflow. Question: "Is it right?"

Stage:
- `building high-level plan`: review User request, What happened, How it works, Scope, High-level plan, Decisions. Do not demand Low-level plan or Subtasks.
- `high-level plan approved, building low-level plan` or later: also review Low-level plan and Subtasks. Check they match the approved high-level plan. Do not silently rewrite How it works, Scope, or High-level plan.

Scripted review questions:
- Scout (`Scout:` line in `.zoo/review.md`): run with `-highlevel-plan` at `building high-level plan`, `-plan` later (zoo-spec-uberreview adds `-uber`). Take its numbered items; drop its answer-rules header (everything before the first blank line), the questions file has its own; `NO QUESTIONS`: none. Non-zero exit: fix or report, never read it as no questions.
- No scout: `references/fallback-questions.md`.
- Plus generate 5-10 spec-specific or prompt-specific questions (focus on highest risk/uncertainty/complexity areas).

Merge dups. Renumber continuously. Write the list to a temp markdown file outside the repo per `zoo-spec-review/references/questions-file.md`; put that path in the reviewer prompt.

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
