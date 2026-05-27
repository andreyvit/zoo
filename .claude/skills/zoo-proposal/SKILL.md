---
name: zoo-proposal
description: Write durable Zoo proposal files for significant cross-cutting work that needs human approval before implementation. Use when the user asks for a proposal, or when Zoo Refactoring, planning, implementation, code review, plan review, uberreview, or another Zoo workflow classifies a finding as proposal-worthy instead of current-task implementation.
---

# Zoo Proposal

Read and follow `.zoo/zoo.md` if it exists.

Capture significant cross-cutting work as a proposal without expanding the current task.

## Workflow

1. Read `.zoo/proposals.md` first. It defines the proposal folder, naming scheme, archive location, and project-specific proposal rules.
2. If `.zoo/proposals.md` is missing, use `.proposals/YYYYMMDD-title.md` as the fallback for new proposals and mention that `zoo-init` should initialize `.zoo/proposals.md`.
3. Create needed proposal directories. Do not create unrelated docs, task reports, or implementation files.
4. Choose a short title and filename slug. Use the current local date in `YYYYMMDD` form. If the target path already exists, append a small numeric suffix.
5. New proposals start with this frontmatter:

   ```yaml
   ---
   status: "proposed"
   ---
   ```

   Valid statuses are `draft`, `proposed`, `accepted`, `done`, and `rejected`. Use `proposed` for new proposals unless the user explicitly asks for a draft.
6. Write the proposal in plain Markdown with these sections:
   - `# <Title>`
   - `## Trigger`: what task, review, incident, or user request raised the issue.
   - `## Problem`: the gap between the current system and the desired system-wide behavior.
   - `## Proposal`: the cross-cutting change to make, including the common mechanism to use across the system.
   - `## Scope`: affected subsystems, representative call sites, existing behavior to preserve, and explicit non-goals.
   - `## Execution Plan`: high-level phases suitable for future approved implementation work.
   - `## Validation`: tests, browser checks, rollout checks, migration checks, or production evidence needed.
   - `## Risks and Open Questions`: unresolved decisions and consequences.
   - `## Current Task Disposition`: whether the current task can continue, is technically blocked, or was only a proposal-writing request.
7. Report the created proposal path and status, and name the finding it handles. If the proposal came from review, state whether it satisfies the review finding for the current task or blocks the current task pending human approval.
8. If the current task has a Zoo Heavy/Lite spec, ensure the proposal is recorded in `Refactorings` as:

   ```markdown
   - Proposal: `<proposal path>` - <finding>
   ```

   If your role does not own spec edits, mention this exact entry in your report for the orchestrator to add.

## Quality Bar

- Make the proposal specific enough for a human to approve, reject, or ask for changes.
- Keep implementation details at the level needed to evaluate scope and consequences; do not silently make design decisions that belong in the approved implementation task.
- Do not use a proposal for small local cleanup, ordinary low-risk helper extraction, or work that clearly belongs inside the current task.
- Do not implement the proposed cross-cutting change unless a human has already approved it and the active Zoo workflow has routed to that implementation work.
- A proposal closes that finding for the current task unless the issue is technically blocking. After recording the path in the report and `Refactorings`, continue the current task instead of adding follow-up work for that proposal.
