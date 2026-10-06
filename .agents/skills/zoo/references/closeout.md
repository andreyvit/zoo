Close out task only when no incomplete subtasks remain and `Pending suggestions` is empty. If the spec has `uberreviews: true`, a Final uber-review log line must exist (one automatic pass). Addressing its findings does not require another pass. Offer the user a rerun; never start one automatically. Required input: task file path (`.spec/YYYYMMDD-<task>.md`). If missing, stop and ask; do not guess. Open Pending suggestions uses `references/reapproval.md`, not closeout.

Follow `.zoo/zoo.md`, `.zoo/testing.md`, `.zoo/task-finish.md` and file at `$ZOO_LOCAL_MD` if exists

Enter `stage: FIN`, `stage_complete: false` before finalization; retain the current revision round.

Final checks:

- Run full repo validation if any changes since last done (normally none)
- Ensure full set of screenshots for all states of the UI (some data, lots of data, empty/default, disabled, styled, all relevant states) and all screens relevant to user request, so that user can comprehensively review UI changes. View screenshots to ensure suitability.
- If task had an associated ticket and we have access to reading tickets, re-fetch and review the original ticket again. Make sure covered entirely (or to the extent explicitly requested by user). Flag any discrepancies and omissions in How it works, Scope, Report, and High-level plan:
    1. If user explicitly asked to omit or specified explicit scope, discrepancies/omissions belong in Report / Remaining work.
    2. If user didn't specify an explicit scope or omissions, and you found a forgotten part of the scope, restart Zoo workflow to address anything missed.
    3. If everything is fully covered, add note for confident reporting later.

Closeout:

- Follow `.zoo/task-finish.md` if exists.
- Review references/task-file-template.md for any section/subsection dropped from task file, and add it back
- Verify `Pending suggestions` is empty; every item moved to a subtask, Decisions, or a proposal
- Reconsider and clean How it works, Scope, Report, High-level plan, Low-level plan, and each subtask's technical spec; Report MUST have screenshots as Markdown image refs visible in Markdown preview (images remain in uncommitted evidence dir)
- Unless overridden, run zoo-rebase with parent `closeout` (chat: `Zoo closeout rebase start (.spec/example.md) r0`, then `Zoo closeout rebase finished (.spec/example.md) r0`; failures use `failed: <reason>` after path/round) and follow routing if not clean.
- Only after successful required closeout: set `status: done`, `stage: FIN`, `stage_complete: true`; emit `Zoo task finished (.spec/example.md) r0`. On failure keep FIN unfinished and status specific. Never commit task file.

Display final report in chat:

- start with a clickable link to task file
- clearly give task status, and display a list of subtasks with their statuses
- link other relevant refs (files)
- show How it works, Scope, Report, and High-level plan (at least surprises, risky changes, deployment)
- show screenshots inline
