- follow `.zoo/planning.md` if exists
- investigate asks: `references/investigate.md` first; only reach this file if the cause is a code bug
- two stages; never fill Low-level plan or Subtasks before explicit high-level approval
- before asking, say concrete options, recommendation, consequences in chat
- ask via AskUserQuestion/similar when available, otherwise chat
- explain the question and context in detail
- ask unrelated questions together; for related questions, ask next batch after prior answers
- decisions and answers are not stage approval
- approval options: Approve, Uber-review, Revise. Uber-review sets `uberreviews: true` if not already set. If this stage has no Spec uber-review log yet, run it once, then ask approval again. If it already ran this stage, Uber-review is an optional extra rerun. If Revise or user refuses to answer, stop Ask User and finish turn, wait for request.

Stage 1 — high-level (`status: building high-level plan`):
- fill How it works, Scope, High-level plan, Decisions as needed
- leave Low-level plan and Subtasks as template placeholders
- in chat: full What happened if this was an investigate ask; then full How it works, then a short summary of Scope and High-level plan; no package, naming, or test detail
- after spec review is fully addressed: if `uberreviews: true` and no high-level Spec uber-review log yet, zoo-spec-uberreview once; then present `Pending suggestions` per `references/pending-suggestions.md`; ask what to do with each
- iterate until the user explicitly approves the high-level plan (approved, looks good, go to low-level, or similar)
- then `status: high-level plan approved, building low-level plan`

Stage 2 — low-level (only after high-level approval):
- fill Low-level plan
- split subtasks per `references/split-subtasks.md`
- put each subtask's technical spec under that subtask
- keep How it works, Scope, High-level plan accurate; significant changes to them need user approval first
- ask only decisions that need the user; do not walk them through every low-level detail
- after low-level spec review is fully addressed: if `uberreviews: true` and no low-level Spec uber-review log yet, zoo-spec-uberreview once
