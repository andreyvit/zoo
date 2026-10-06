- follow `.zoo/planning.md` if exists
- investigate asks: `references/investigate.md` first; only reach this file if the cause is a code bug
- two stages; never fill Low-level plan or Subtasks before explicit high-level approval
- before asking, say concrete options and recommendation in chat. When explaining suggestions and options, explain their final consequences: what behavior/UX each would produce, AND what other actions we would need to take to get the behavior/UX we want.
- ask via AskUserQuestion/similar when available, otherwise chat
- explain the question and context in detail
- ask unrelated questions together; for related questions, ask next batch after prior answers
- decisions and answers are not stage approval
- approval options: Approve, Uber-review, Revise. Uber-review sets `uberreviews: true` if not already set. If this stage has no Spec uber-review log yet, run it once, then ask approval again. If it already ran this stage, Uber-review is an optional extra rerun. If Revise or user refuses to answer, stop Ask User and finish turn, wait for request.

On stage entry/reopen, set `stage_complete: false`; when ready for review/approval, set true. Substitute task path/round in standalone chat receipts below.

Stage 1 — high-level (`stage: HL`, `status: building high-level plan`):
- Chat: `Zoo high-level planning start (.spec/example.md) r0`; when ready: `Zoo high-level planning finished (.spec/example.md) r0`.
- fill How it works, Scope, High-level plan, Decisions as needed
- leave Low-level plan and Subtasks as template placeholders
- in chat: full What happened if this was an investigate ask; then full How it works, then a short summary of Scope and High-level plan; no package, naming, or test detail
- after spec review is fully addressed: if `uberreviews: true` and no high-level Spec uber-review log yet, zoo-spec-uberreview once; then present `Pending suggestions` per `references/pending-suggestions.md`; ask what to do with each
- iterate until the user explicitly approves the high-level plan (approved, looks good, go to low-level, or similar)
- then `status: high-level plan approved, building low-level plan`

Stage 2 — low-level (`stage: LL`, only after high-level approval):
- Chat: `Zoo low-level planning start (.spec/example.md) r0`; when ready: `Zoo low-level planning finished (.spec/example.md) r0`.
- fill Low-level plan
- split subtasks per `references/split-subtasks.md`
- put each subtask's technical spec under that subtask
- keep How it works, Scope, High-level plan accurate; significant changes to them need user approval first
- ask only decisions that need the user; do not walk them through every low-level detail
- after low-level spec review is fully addressed: if `uberreviews: true` and no low-level Spec uber-review log yet, zoo-spec-uberreview once
