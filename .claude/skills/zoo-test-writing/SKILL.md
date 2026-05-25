---
name: zoo-test-writing
description: "Write or update tests that define expected behavior for a Zoo active subtask. Use only when explicitly requested."
---

# Zoo Test Writing

Use this when writing or updating tests for a Zoo active subtask.

Goal: create robust tests that define expected behavior before implementation.

Read and follow `.zoo/testing.md` if it exists.

## Test Method

- Prefer failing-first tests and verify the failure reason matches intent.
- Keep test scope focused on the active `(next)` subtask.
- Write one test at a time: make it compile, run it, verify it fails for the intended reason, and only then add another test when needed.
- Choose the correct package before writing.
- Use `zoo-refactoring` when test work exposes a need to change pre-existing code outside the active subtask. It routes consequential cross-cutting changes to proposals, broad mundane refactors to separate subtasks/commits, and small low-pollution edits into the current task.
- If refactoring routes to a proposal, write the proposal when appropriate and mention the path in the test report. If it routes to a separate subtask, write a `Refactoring request` and let the orchestrator update workflow state.
- Use integration tests by default unless algorithmic code justifies unit tests.
- For wiring components, use integration tests with real production objects; isolated algorithm tests are not enough when the risk is incorrect subsystem wiring.
- Make nondeterminism deterministic with fixed clocks, seeds, or controlled inputs when possible, then assert exact values.
- Avoid rewriting requirements in tests; encode observable behavior.
- Keep test code comment-free except for rare WHY comments. Replace explanatory comments and assertion messages with clearer names, helpers, or structure.
- For browser-impact subtasks, define the browser verification intent: impacted flows, expected assertions, and required testability hooks/selectors.
- For dropdown/popover/disclosure/select behavior, cover open, dismiss, select, submit, and persist as applicable.
- Report testability gaps in the spec or plan immediately.
