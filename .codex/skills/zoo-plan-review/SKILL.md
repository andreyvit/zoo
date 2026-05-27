---
name: zoo-plan-review
description: "Review Zoo Workflow specs and active-subtask implementation plans for correctness, completeness, evidence, and clarity. Use only when explicitly requested."
---

# Zoo Plan Review

Read and follow `.zoo/zoo.md` if it exists.

Use this when reviewing a Zoo Workflow spec and active-subtask implementation plan.

Goal: catch weak implementation plans and material spec gaps before coding starts.

Read and follow `.zoo/planning.md` and `.zoo/planreview.md` if exists.

## Review Method

- Review only; do not edit files except proposal files created through `zoo-proposal` for proposal-worthy refactoring findings.
- Use a blunt technical review posture: adversarial to bad assumptions, strict on design correctness, and light on ceremony.
- Spend most effort on substance: missed acceptance criteria, wrong code paths, bad data flow, broken compatibility assumptions, missing tests, missing browser checks, security/data risks, sequencing bugs, and edge cases.
- First try to break the implementation plan against the codebase and product contract. Map each acceptance point to the planned files, functions, templates, routes, jobs, migrations, tests, browser flows, and assumptions.
- Name the key code paths, integration points, tests, browser flows, and assumptions you checked. If you cannot name them, keep reading before deciding.

## Substantive Checks

- Verify the plan addresses the original user request or ticket's primary use case. A limitation that skips the main point must be revised or explicitly decided by the user.
- Verify the plan uses relevant execution memory, completed-subtask learnings, research reports, and existing code patterns.
- Require an execution trace for behavior changes: entry points, key conditions, and dependent code paths.
- Require pattern discovery before new mechanisms. Flag new enum values, APIs, helpers, UI mechanisms, or transient model fields that duplicate an existing mechanism.
- Challenge workarounds around first-party dependencies and shared first-party packages; require comparison against fixing the dependency.
- Check that the plan uses existing patterns when they fit, improves shared abstractions when they are insufficient but fixable, and invents new abstractions only when existing options are inadequate.
- Use `zoo-refactoring` when a finding needs changes outside the active plan, would expand scope, or would make the touched path diverge from similar code. It routes consequential cross-cutting or local-divergence changes to proposals, broad mundane refactors to separate subtasks/commits, and small low-pollution edits into the current task.
- When you write a proposal, mention its path and the finding it handles in the review report. If you cannot create proposal files, include the draft proposal entry for the orchestrator. Put separate-subtask outcomes in a `Refactoring request` section instead of editing specs, subtasks, or code.
- Before requiring complex changes in the active task, ask whether they were explicitly requested, naturally expected, technically blocking, or the only reasonable path. If the answer is no, require a proposal instead of scope expansion.
- If the task follows an existing common framework and a security, debuggability, modularity, or simplicity gap would require replacing that framework or shared plumbing, prefer a project-wide proposal unless the current task cannot make useful progress without it.
- Flag local refactors that make one touched path cleaner but less consistent with similar code still using the shared pattern. Require a project-wide proposal for the better pattern and a simple consistent current-task plan.
- Do not let required changes disappear into "out of scope." Proposal findings must explain why the change is desired, what it improves, and what alternatives exist.
- Preserve domain type distinctions. Do not approve cross-type fallback behavior unless the user or spec explicitly calls for it.
- Check that discovered facts are validated against production correctness, not only against expected test output.
- Flag scope creep, missing acceptance coverage, layering violations, backwards compatibility risks, data/security risks, and hidden coupling.
- For browser-impact subtasks, require a browser verification plan naming flows, checks, evidence, harness coverage, and Browser Use or Computer Use needs.
- Require evidence planning to match the change type: screenshots for browser-visible behavior, generated files for exports, input files for imports, and representative test names for tested behavior.
- When plan validity depends on user decisions, first require research into code, history, docs, production configuration, and production data when appropriate; then decide whether a reasonable default can be recorded.
- Ask user questions only for consequential product, strategy, or super consequential tactical decisions. Treat blockers skeptically.

## Spec Structure Checks

- Require the Zoo spec sections exactly: `User Input`, `Spec`, `Decision log`, `Open product and strategic questions`, `Execution memory`, `Refactorings`, `Subtasks`.
- Verify `User Input` preserves hard constraints, soft preferences, unknowns, and draft ideas separately from agent interpretation.
- Verify `Spec` is itemized, concrete, grouped by subfeature/subarea, and ordered from most consequential/visible to least.
- Reject filler, generic background, generic risks, restated requests, and formal prose that does not change implementation or review.
- Verify `Decision log` records only real alternatives or user overrides.
- Verify `Open product and strategic questions` contains only consequential user decisions.
- Verify `Execution memory` is compact and useful.
- Verify `Refactorings` records proposal paths with the findings they cover and completed refactorings with the subtask, commit, or report pointer. Proposal entries must not be routed back into current-task subtasks unless marked blocking pending approval.
- Verify the spec is not treated as a waterfall: only `(next)` is planned in detail, while future subtasks stay lightweight until promotion.
- Reject vague or hand-wavy plan statements; require plain language and concrete done conditions.
