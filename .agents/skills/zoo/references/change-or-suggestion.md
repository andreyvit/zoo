Route work before implementing it. User-requested revisions after spec approval go through zoo-revision; the routing below covers other newly discovered work.

User revision after execution finished: increment `revision_round` once before adding/reopening subtasks, log it, reopen the stage, emit `Zoo revision recorded (.spec/example.md) r1`. Requests during planning/execution and routine review fixes keep the current round.

Protect: cohesive subtasks and commits; user judgment over task, scope, and high-level plan.

Every change belongs to a subtask. Add a subtask before making it. Batch tiny user-requested updates. Otherwise keep that subtask focused.

Before high-level approval: edit How it works, Scope, High-level plan. Spec review may add Pending suggestions.

After high-level approval, still planning: fill low-level and subtasks. Significant How it works / Scope / High-level plan change: stop, present, wait.

After execution starts:

## Active subtask

New work only, no scope expansion, fits this subtask, commit stays cohesive. Tiny adapters and cleanup of new code OK.

Implement and review now.

## Existing subtask

Another listed subtask already covers it, without changing that subtask.

Defer to that subtask.

## Pending suggestions

Else. Record under `Pending suggestions` → `Code changes` (or Scope expansion / Spec improvements when that is what it is). Short: what, why, when/how found, alternatives, do-nothing. Do not implement. After the user decides, move it out per `references/pending-suggestions.md`.

Default: finish the active subtask or a useful subset. Record limitations and deployability. Skip the active subtask and its dependents only when no useful result fits current scope. Continue independent remaining subtasks.

Accepting a Code change is not high-level approval.

When no remaining subtask can proceed, run `references/reapproval.md`.
