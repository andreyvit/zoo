Run only when no remaining subtask can proceed and `Pending suggestions` still has open items. Use `references/change-or-suggestion.md` when discovering or recording changes.

Complete a partial closeout:

- finish review, validation, evidence, docs, and commits for completed work
- update How it works, Scope, Report, High-level plan, and Low-level plan for delivered work
- set exact status, e.g. `completed subtask 5; awaiting decision on Pending suggestions`; never claim done
- show How it works, Report, and every open Pending suggestions item, with a clickable task-file link
- follow `references/pending-suggestions.md`: present each item, ask what to do, move decided items out
- if an accepted item is a significant high-level or scope change, say so; accepting a Code change is not high-level approval
- accepted Code changes, and accepted Scope expansion / Spec improvements that need work, become subtasks ready to run; start them; do not ask a second approval

Resume remaining subtasks. Run final closeout only when no incomplete subtasks remain and Pending suggestions is empty. If the spec has `uberreviews: true` and there is no Final uber-review log yet, run zoo-final-uberreview once; its findings become suggestions and accepted items become subtasks. Do not auto-rerun after those subtasks.
