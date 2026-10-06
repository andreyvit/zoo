---
name: zoo-revision
description: "Turn user-requested revisions into Zoo subtasks after the spec is approved. Use automatically for revision requests during an approved Zoo workflow, or when explicitly invoked. Queue behind active work; otherwise resume execution."
---

Follow `.zoo/zoo.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo revision start (.spec/example.md) r0`, then `Zoo revision finished (.spec/example.md) r0` or `Zoo revision failed (.spec/example.md) r0: <reason>`. These receipts cover recording/scheduling the revision; execution uses Zoo subtask receipts.

Turn the request into approved work, then follow Zoo. Never implement outside its subtask loop.

- Use the active spec or user's path; ask if ambiguous. Record the request in `User request` and `Log`, preserving the original request and completed work.
- `revision_round` counts completed-execution revision rounds, not requests. Increment once only if this request reopens finished execution; check before changing subtasks. Requests during planning/execution keep the round. Log and emit `Zoo revision recorded (.spec/example.md) r1` when incrementing.
- Add one or more focused subtasks, or amend future subtasks that cover the request. Default to the end; insert earlier when dependencies or the requested behavior require it. Preserve existing subtask IDs. Batch tiny related updates; avoid duplicates.
- Update affected plans, Scope, How it works, and Report. The user requested this revision: do not park it in Pending suggestions or ask for the same approval again. Ask only for unresolved scope/strategy choices; follow Zoo's suggestion routing for extra work the user did not request.
- Active subtask: queue the revision and continue that subtask. Interrupt only if the request invalidates current work or makes continuing harmful. Log queued vs interrupting status; keep the active subtask's status accurate.
- No active subtask: start the next ready subtask through the main Zoo execution loop, including validation, reviews, docs, and commit. Set `stage: EX`, `stage_complete: false`, and `status: executing subtask N`. A completed task reopens. Honor an explicit request to defer or remain paused.
- If only high-level approval exists, update the pending plan and finish normal low-level planning/approval before execution.
