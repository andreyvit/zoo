---
name: zoo-plan
description: "Plan Zoo Workflow subtasks by researching code, maintaining the spec contract, and producing detailed tactical HOW for the active subtask. Use only when explicitly requested."
metadata:
  short-description: Plan Zoo Workflow subtasks
---

# Zoo Plan

Use this when you are the planner for a Zoo Workflow delegated step.

Goal: keep the whole spec useful while producing a detailed implementation plan for the active `(next)` subtask.

Read and follow `.zoo/planning.md` if it exists.

Rules:

- Research the codebase yourself before planning. Read the relevant files, similar implementations, tests, docs, and recent reports needed to make the spec and active plan concrete.
- Infuse planning with Don Melton-style pragmatism: shipping-first, concrete, and no hand-wavy steps.
- Trace behavior from entry points through the relevant code path before planning behavior changes. Name key functions, conditions, and data flow in the tactical HOW.
- Search for existing patterns before designing new mechanisms. Prefer extending established validation, error, UI, settings, routing, enum, and helper patterns unless the plan records why they cannot fit.
- Treat limitations in shared first-party dependencies as fixable code, not external constraints. Compare fixing the dependency against carrying a workaround.
- Preserve domain type distinctions. Do not add fallback behavior between different business concepts unless the user or existing contract explicitly calls for it.
- When research discovers facts that differ from assumptions, validate those facts against production correctness and real configurations, not only against expected test output.
- If bounded researcher reports exist, fold their findings into the spec and plan. If research is missing for a non-trivial area, do that research before planning instead of guessing.
- Blend two planning levels in one step:
  - update the spec file as the whole-task contract: user input, product/behavior spec, decisions, open strategic questions, execution memory, subtask boundaries, and lightweight current-best-guess drafts for future subtasks
  - produce detailed tactical HOW for the active `(next)` subtask only
- Use the required spec format exactly: `User Input`, `Spec`, `Decision log`, `Open product and strategic questions`, `Execution memory`, `Subtasks`.
- Keep `User Input` separate from agent interpretation; update it when the user clarifies, corrects, or overrides direction.
- If the user asks for revisions or follow-up changes after prior work in the same Zoo task, update the existing spec file instead of creating a new one. Preserve completed subtasks and evidence, add the new request to `User Input`, and create/promote a real `(next)` revision subtask.
- If the user request references a ticket, issue, PR, or similar work item, read it and treat its contents as part of the user request. Preserve its hard constraints, soft preferences, unknowns, and draft ideas in `User Input`; direct user chat overrides ticket text when they conflict.
- Mark completed itemized lines under `User Input` and `Spec` with `(done)` immediately after the bullet marker, e.g. `- (done) Add Foo feature package`.
- Separate hard constraints, soft preferences, unknowns, and draft implementation ideas according to the user wording.
- Keep `Spec` as an itemized top-to-bottom contract, grouped by subfeature/subarea, ordered most consequential/visible to least consequential/visible.
- Include concrete implementation surface in `Spec`: packages, routes, templates, structs, fields, permissions, jobs, migrations, and integration points.
- Remove filler, generic background, generic risks, and restatements of the request in longer words.
- Use `Decision log` only for real alternatives considered or user overrides.
- Use `Open product and strategic questions` only for the most consequential unclear user decisions: important product decisions, strategy-level decisions, and super consequential tactical decisions.
- During initial planning, surface all such questions for one upfront user interview when possible.
- After implementation starts, research uncertainty before blocking: inspect code, history, docs, production configuration, and production data when appropriate to identify the safest choice.
- Prefer documenting a reasonable, evidence-backed decision in `Decision log` and proceeding; mark `[blocker]` only when there is no safe default and the wrong choice could cause a high-impact product, strategy, data, security, or compatibility mistake.
- Keep `Execution memory` compact and useful for future runs.
- Keep the `Subtasks` list outcome-focused, with `(done)` / `(next)` / `(future)` status on the primary line.
- Split subtasks by standalone functionality: if a piece of functionality stands on its own and either provides independent user value or has a complex implementation that can be tested on its own, make it a separate subtask. Prefer smaller subtasks; avoid bundling separate standalone slices into one broad `(next)`.
- If the spec has no active `(next)` subtask, or the active subtask is only a placeholder/TBD, define the first real implementation subtask, draft future subtasks, and plan that actual work in the same pass. Do not create or plan a separate planning-only subtask.
- If all known subtasks are `(done)` and there is no `(future)` work left, run a final task-completion planning pass instead of inventing work. Verify the whole task against `User Input`, `Spec`, reports, evidence, reviews, docs, and commits. If anything remains, add a real `(next)` subtask and plan it. If everything is complete, declare that the task is fully done, reviewed, and closed out, with the evidence/review/commit basis for that declaration.
- Do not treat the spec as a waterfall: plan the active `(next)` subtask in detail; `(future)` subtasks may include lightweight current-best-guess drafts, but avoid spending much time on details before promotion.
- When promoting or editing the next subtask, use `Execution memory` and learnings from completed subtasks, reports, tests, browser verification, and code review to re-plan the next subtask and revise future drafts.
- Put subtask details on indented child lines: `Acceptance:`, `Browser impact:`, `Plan:`, and `Evidence:` when relevant.
- For each subtask, include `Browser impact: none|possible|direct`; for `possible|direct`, include the flow list on the same `Browser impact:` line.
- Resolve ambiguities with explicit decisions and rationale.
- Keep subtasks shippable and reviewable.
- Prefer a narrow next subtask over broad speculative planning.
- Convert the current `User Input`, `Spec`, and active subtask acceptance into concrete HOW steps.
- Treat the spec as contract. If the contract needs to change, update the spec and record the decision before producing the final tactical HOW.
- Do not invent scope that is not in the active `(next)` subtask.
- Name expected files/packages and test strategy.
- For browser-impact subtasks, include explicit browser verification scope: impacted flows, expected checks, required screenshots, when video evidence is required, whether the repo's browser/app harness mode covers the flow, and whether Codex Browser Use is sufficient or Codex Computer Use is needed.
- Include the completion evidence plan: browser screenshots for browser-visible changes, example generated files for CSV/file generation, example input files for CSV/file importing plus import screenshots when there is a browser UI, and 1-2 representative test names for tested behavior.
- Surface migration risks, rollback approach, and validation steps.
- Keep plan steps small enough for clean review commits.
- Avoid vague steps; every step should have a clear done condition.
- Use straightforward, down-to-earth language; avoid abstract or hand-wavy plan text. Keep steps short and specific; avoid strategy wording.
