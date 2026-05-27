---
name: zoo-refactoring
description: Classify and route Zoo refactorings, local structural cleanups, and cross-cutting changes to proposals, separate subtasks, or current-task work. Use in Zoo workflows, planning, implementation, tests, and reviews when a needed or suggested change affects pre-existing code outside the active task, creates a broad mechanism, touches many call sites/files, changes subsystem behavior, introduces a one-off local pattern for a broader concern, or would otherwise expand the task beyond its approved scope.
---

# Zoo Refactoring

Read and follow `.zoo/zoo.md` if it exists.

Use this before doing or requesting cross-cutting work outside the active task, or before doing a local structural cleanup that would make the touched code follow a better-but-different pattern than similar code elsewhere.

## Scope Discipline

Working code that covers every identified gap is not the only goal. Keep the current task simple and straightforward unless the larger change is truly part of the task.

As you write or review code, use existing patterns when they fit. Improve existing abstractions and shared patterns when they are insufficient but fixable. Invent new abstractions or approaches only when the existing options are inadequate.

Prefer current-task work when the finding is about new code written for the task and the fix is small, natural, and does not blow up the task.

Prefer a separate subtask when the task adds a genuinely novel side of the system and a general foundation is naturally part of making that side work.

Prefer a proposal when the task works within an existing scope or common framework and closing the gap would require abandoning that common approach, replacing shared plumbing, or expanding the diff well beyond the request. A project-wide improvement to shared code is usually lower debt than a one-off local escape hatch.

Do not classify solely by how many files the immediate edit touches. A local refactor can still be proposal-worthy when it creates a special cleaner shape for one call site while the rest of the system keeps using the old shared pattern. Keep local changes simple and consistent with nearby code, then propose the global refactor that would make the better pattern available everywhere.

Before scoping complex changes into the active task, ask:

- Were these complex changes explicitly requested?
- Would the user naturally expect them, or would the expansion be surprising?
- Is there one reasonable implementation path, or several plausible approaches needing a decision?
- Can a useful version of the requested task ship without them, or are they technically blocking progress?

If the changes are explicitly requested, natural, or technically blocking with one reasonable path, include them in scope as current-task work or a separate subtask. If they are surprising, non-blocking, or have multiple plausible approaches, write a proposal instead.

Do not ignore required changes. When routing to a proposal, explain exactly why the change is desired, what it improves, and what alternatives exist.

## Classification

Classify the change into exactly one category.

### Significant Cross-Cutting Or Local-Divergence Change

Use this category for consequential changes that should get human approval before implementation:

- new or materially changed product behavior across a subsystem
- new security, rate limiting, permission, privacy, deployment, scalability, storage, upload, rendering, streaming, API, or rollout mechanism
- changes that alter how future code should be written in a broad area
- architecture or layering changes with meaningful consequences
- broad remediation of a real security, data, compatibility, or operational gap
- local cleanup that solves a system-wide framework or pattern problem only for the current code path

Action:

1. Use `zoo-proposal` to write a proposal in the configured proposals folder. The initiating agent should write the proposal when its role allows creating proposal artifacts.
2. Do not implement the cross-cutting change as part of the current task.
3. Mention the proposal path in the initiating report, along with the finding it resolves.
4. If a Zoo spec exists, record the proposal in `Refactorings` with the finding it covers.
5. If the current task can proceed with the existing system or a reasonable subset of functionality, treat the proposal as satisfying the review finding for this task and continue. Do not return to that proposal as part of the current task.
6. If the current task technically cannot proceed without this work, write the proposal, mark the current task blocked pending human approval, and do not invent a parallel one-off mechanism.

### Mundane Cross-Cutting Change

Use this category for broad but ordinary codebase work that should be reviewed and committed separately:

- changing a shared function or interface signature across many call sites
- mechanical package moves or helper extraction across many files
- moving code across existing package boundaries without changing layering strategy
- broad test helper cleanup or call-site migration
- other low-consequence changes whose main risk is diff pollution or review separation

Orchestrator action:

1. Put the work in a separate subtask or separate commit from the active feature work.
2. If the active subtask can finish first, finish and commit it, then do the cross-cutting subtask afterward.
3. If this work blocks the active subtask, stash active-subtask changes when needed, note the stash on the current subtask or report trail, add or promote the refactoring subtask before the current subtask, complete and commit it separately, then resume the current subtask.
4. Express this as separate workflow work, record the split in the workflow's durable trail, and keep commits separate.
5. After the separate work is done, record it in `Refactorings` with the subtask, commit, or report pointer and what changed.

### Non-Cross-Cutting Change

Use this category for small, low-risk changes that do not pollute the current diff or make the touched path a one-off departure from similar code:

- extracting a helper used by the current code and one or a few nearby callers
- adding a small argument or adapter across a handful of simple call sites
- tightening names or structure in files already being meaningfully touched

Action: do the work inside the current subtask when your current role is allowed to edit that code.

The threshold is review clarity, not a fixed number. Three to five simple call sites usually fit the current task. Twenty or more call sites usually need a separate subtask. Around ten depends on how many files the current diff already touches and whether the refactor would obscure the feature change.

## Blocking Test

Blocking means technically blocking: not even a reasonable subset of the requested behavior can be implemented with the existing mechanism. A serious security or design issue may block shipping, but it does not block writing the current task's code if the task can be implemented against the current system and the larger fix can be proposed.

## Workflow Ownership

First decide whether you are the top-level orchestrator or a delegated agent. Use the current execution context: if you own the workflow state, task list, spec updates, final routing, or agent coordination for this user request, you are the orchestrator for this decision. Do not infer that you are delegated just because this skill says delegated agents hand work off.

- Top-level orchestrator: consume the classification yourself. You are the destination for the routing decision, so do not write a `Refactoring request` to yourself. Update the workflow state used by the active Zoo workflow, decide before-vs-after routing, stash only when necessary, and keep refactoring commits separate.
- Delegated agent: do not own workflow state by default. Unless the delegated prompt explicitly assigned planning/spec maintenance or the refactoring implementation itself, do not edit `spec.md`, reorder subtasks, stash work, switch tasks, commit, or implement a separate cross-cutting change.

Proposal handling closes that finding for the current task unless the issue is technically blocking. The task continues, and the workflow does not return to that finding as current-task work. A delegated agent that can create proposal artifacts may write the proposal itself with `zoo-proposal`, then mention the proposal path and finding in its report. If the delegated agent does not own spec edits, it must include the exact `Refactorings` entry for the orchestrator to add.

Separate-subtask handling is different from proposal handling because it changes workflow state. When a top-level orchestrator initiates separate-subtask refactoring, it applies the workflow change directly. When a delegated agent initiates separate-subtask refactoring, it must write the handoff in its own report even if another step will apply it to the workflow state. Include a `Refactoring request` section with:

- classification
- proposed subtask title
- whether it should run before or after the active subtask
- technical-blocker assessment and stash recommendation, if any
- problem statement and desired system-wide outcome
- scope: affected subsystems, representative files/call sites, and non-goals
- acceptance/done condition
- implementation outline at the level needed for planning
- validation needed

The orchestrator consumes delegated `Refactoring request`s: it updates workflow state, decides before-vs-after routing, stashes active work only when necessary, and keeps refactoring commits separate.

## Output

When invoked, state:

- classification
- why the finding is or is not technically blocking
- required action: proposal path, separate subtask/commit, or current-task implementation
- how the current task should continue

For review findings, do not expand the current task to include significant cross-cutting work. Route it through a proposal or separate subtask according to this classification.
