---
name: zoo-code-impl
description: "Implement the smallest correct code change for an approved Zoo active subtask plan. Use only when explicitly requested."
---

# Zoo Code Implementation

Read and follow `.zoo/zoo.md` if it exists.

Use this when implementing an approved Zoo active-subtask plan.

Goal: deliver the smallest correct change that passes tests and respects architecture.

Read and follow `.zoo/coding.md` and `.zoo/testing.md` if exists.

## Implementation Method

- Use Rob Pike-style pragmatism: simple code, direct execution, and clarity over ceremony.
- Follow the approved tactical plan for the active `(next)` subtask.
- Keep diffs focused and avoid opportunistic refactors.
- Use `zoo-refactoring` before making changes outside the active subtask's scope. It routes consequential cross-cutting changes to proposals, broad mundane refactors to separate subtasks/commits, and small low-pollution edits into the current task.
- If refactoring routes to a proposal, write the proposal when appropriate and mention the path in the implementation report. If it routes to a separate subtask, write a `Refactoring request` and let the orchestrator update workflow state.
- Before claiming code is missing or impossible, search for existing symbols and read the actual implementation path.
- Run or inspect failing tests before changing behavior. Make tests pass without weakening their intent.
- Preserve layering and context-passing rules.
- If the plan or spec conflicts with code reality, stop and surface the conflict.
- Track dependency changes carefully: added/removed/updated dependencies, dependency version or set changes, and code changes in modifiable dependency checkouts. Keep the rationale tied to the implementation choice.
- After the last file change, run the relevant validation when feasible. If you cannot, report exactly why and which command the orchestrator should run before review closeout.

## Design Guardrails

- Investigate guards, constraints, zero/default handling, tenant checks, and global indexes before removing or bypassing them.
- Keep the constraint and find another path when its purpose is unclear.
- Search for existing configurable, translated, or tenant-customizable patterns before adding user-visible text, labels, messages, tooltips, or accessibility strings.
- When moving behavior, remove the old redundant path unless the plan explicitly requires both paths.
- For browser-impact subtasks, add stable and minimal testability hooks/selectors when existing semantics are insufficient.
- Prefer existing utilities, helpers, and local patterns over new abstractions.

## Report Handoff

Include `Dependency changes` in the implementation report:

- added, removed, or updated dependencies
- dependency version or dependency-set changes
- code changes in modifiable dependency checkouts
- rationale for each change
- `none` when there were no dependency changes

Include `Final-state validation` in the implementation report:

- commands run after your last file change
- result on the exact state you left: `passed`, `failed`, or `not run`
- whether any file changed after those commands
- if validation did not pass on the state you left, the exact command the orchestrator should run or the failure to route to fixes
