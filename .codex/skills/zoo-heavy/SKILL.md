---
name: zoo-heavy
description: "Spec-based Zoo 2.1 workflow with subagent for each step. Use only when explicitly requested."
---

# Zoo Heavy

Canonical artifact: `.tasks/<task>/spec.md` or `_tasks/<task>/spec.md`, unless the user explicitly asks to use a spec file under `.spec/`.

## Modes

Decide which mode you are in before doing anything else.

### Top-level orchestrator mode

Use the full workflow below only when you are the main agent running the task end to end.

### Delegated single-step sub-agent mode

If the prompt says you are a delegated sub-agent, gives you one specific step, tells you to write one report, or otherwise scopes you to one Zoo Heavy step, then you are not the orchestrator. In that case:

- execute only the assigned step
- do the work yourself
- do not run the full Zoo Heavy workflow
- do not spawn subagents
- do not wait for subagents
- do not do top-level closeout
- write exactly one report for your step, then stop

When there is any ambiguity, prefer delegated single-step mode over full-workflow mode. Accidentally doing one step too little is easier to recover from than accidentally starting a recursive orchestrator loop.

## Spec format

    # Title

    ## User Input

    <summary of changes to be made, 1-3 paragraphs>

    Why: <rationale for the changes if provided>

    Hard constraints: <anything that user said MUST be done or said is a HARD constraint>

    Soft preferences: <anything user said about the shape of the solution>

    Unknowns: <preferences about the solution that user is unsure about>

    Draft ideas to adapt with common sense: <anything that user specified about implementation that was not explicitly mentioned with MUST nor as a HARD constraint -- these are soft implementation preferences and soft ideas>


    ## Spec

    <a detailed top-to-bottom spec on how the solution looks and is implemented, as an itemized list grouped into subheadings, order these MOST CONSEQUENTIAL/VISIBLE to LEAST CONSEQUENTIAL/VISIBLE, group into subheadings by subfeature/subarea, sort those subheadings too from MOST CONSEQUENTIAL/VISIBLE to LEAST CONSEQUENTIAL/VISIBLE, mention everything that must be done as part of implementation>

    ### Add Foo superadmin page

    - Add the Foo feature package

    - Register Foo page below Fubar, with two tabs: Manage and Effective.

    - Manage tab displays a configuration form editor with ... sections showing ... controls

    - Effective tab renders an HTML template superadmin_foos.html which displays a table, each row corresponding to ...

    - Define FooVM struct with at least the following fields:

          Xxx string
          Yyy int
          ...

    - ...


    ### Add Foo section to customer admin page

    - Add a section to shopadmin_customer.html displaying ...

    - This section should be gated by PermissionCustomerSeeFoos.

    - Extend bocustomers.DoShow to load ...

    - Extend vmcustomer.CustomerVM with ...

    - ...


    ### Store the last time X was done in the database

    ...


    ### Extend forms framework with support for editing uvwxyz data type

    ...



    ## Decision log

    <when considering multiple alternatives, mention the decision, the other alternatives rejected, and a very brief why, for example:>

    - Use the established navigation/page registration pattern for the new superadmin page.

    - Gate Foos customer admin with a new PermissionCustomerSeeFoos permission, added to PermissionMacroCustomerView. (We could reuse PermissionCustomerSeeData, but all recent customer admin changes have added dedicated properties for new rows or sections displayed.)

    - In customer admin, mark entire Foos section with access tag (“superadmin-only” or “published”). (We could mark every row, but they all share same access control permission.)

    ...

    <if user later overrides one of your decisions, record the new decision with the user's rationale if provided, and mark (USER INPUT), e.g.:>

    - (USER INPUT) Do not mention re-fribernation in externally visible docs and user interfaces, it's an internal term that only devs understand; instead word it around “queued updates”.


    ## Open product and strategic questions

    <list only the most consequential unclear questions that user should decide -- important product decisions, strategy-level decisions, and super consequential tactical decisions. Don't punt minor implementation decisions to user. Ask these during initial planning whenever possible. After implementation starts, research the uncertainty first: inspect code, history, docs, production configuration, and production data when appropriate; then prefer documenting a reasonable evidence-backed decision in Decision log and proceeding unless the uncertainty is truly unsafe to resolve without the user. Explain the dilemma in detail, and include technical and product CONSEQUENCES of each choice! e.g.:>

    - Can we assume Frubernator will never be used together with Widgerator on the same venue? These two would be clashing on updating the frubenation counter. If these are never used together, we can simply store the counter as a single value. If multiple sources will be contributing the counts, we have to store the contributions separately, and reconcile them somehow, perhaps by taking a max() of the values?

    ...


    ## Execution memory

    <Orchestrator updates this section with learnings from each report, to preserve the key learnings and implementation path for future runs. Keep adding, updating and organizing items as you read each report. Just a brief itemized list, compact format.>

    - Registration points: reg-navitems.go, reg-xxx.go, ambiguouspkg/foobars.go
    - Added sufoos: impl and TestFoos_*
    - Form framework: lifecycle tricky when handling postback on dynamic controls, solved in xxxform.go, needs more testing
    - Tests do not sufficiently cover refrubbernation, broke it and only noticed in browser testing, should expand test suite in follow-up subtasks.
    - ...


    ## Subtasks

    <detailed plan for one next task, plus lightweight current-best-guess outlines or draft plans for future tasks -- but again this is not a waterfall, so future task details are drafts and must be re-planned before that task starts>

    - (next) <title>
      - Acceptance: <outcome>
      - Browser impact: possible, <flow list>
      - Plan: <NNN-plan.md|TBD>
      - Evidence: TBD

    - (future) <title>

    - (future) <title>


## Workflow

- This section is for top-level orchestrator mode only.
- This workflow is opt-in. Do not create/use Zoo Heavy for routine small tasks unless the user asks.
- Start or switch tasks with Bureau MCP tools.
- Use `.tasks/<task>/spec.md` as the spec source of truth.
- If the user explicitly asks to use a spec file under `.spec/`, that file overrides the default Bureau spec path and becomes the spec source of truth. Keep Bureau for task/report/evidence operations.
- If `spec.md` does not exist, `planner` drafts it from the user request.
- `User Input` records what the user asked for and must be updated when the user clarifies, corrects, or overrides direction.
- If the user request references a ticket, issue, PR, or similar work item, its contents are part of the user request. Read it before planning and capture its hard constraints, soft preferences, unknowns, and draft ideas in `User Input`; direct user chat overrides ticket text when they conflict.
- If the user asks for revisions or follow-up changes to a prior Zoo Heavy run, continue in the same Bureau task and same spec. Do not start a new task/spec unless the user explicitly asks. Update `User Input`, reopen planning by adding or promoting a real `(next)` revision subtask, and preserve prior completed subtasks/evidence.

If spec has no active `(next)` subtask because planning has not started, run `planner` to define the first real `(next)` implementation subtask, draft future subtasks, and write the active-subtask plan for that real work. If all known subtasks are `(done)` and no `(future)` remains, run `planner` as the final task-completion check instead. Do not create a planning-only subtask.

Planning principles:

- Keep exactly one active execution target while the task is in progress: `(next)`.
- Each completed subtask must keep the system shippable and tested; browser-impact work must include browser verification.
- Prefer smaller subtasks. Split a standalone functional slice into its own subtask when it either provides independent user value or has complex implementation that can be tested on its own; avoid splitting purely by file/layer when the slice cannot be validated independently.
- Zoo Heavy is not a waterfall. Plan the active `(next)` subtask deeply; future subtasks may include lightweight draft plans or current-best-guess notes, but avoid spending much time on details before promotion.
- Use what was learned in completed subtasks, reports, tests, browser verification, and code review to re-plan the next subtask and adjust future subtask drafts before promoting them.
- Future subtasks are scope boundaries and hypotheses; any tactical notes on them are provisional drafts.
- After each completed subtask, rerun `planner` and `plan_reviewer` before coding the next one so the whole spec and active plan reflect the latest learnings.
- During the initial planning pass, collect all consequential unclear user questions and run one user interview before implementation starts.
- After implementation starts, research the uncertainty before blocking: inspect code, history, docs, production configuration, and production data when appropriate to collect enough evidence for the safest decision. Then use common sense, document the decision in `Decision log`, and proceed unless the choice is a high-impact product/strategy decision or super consequential tactical decision with no safe default.
- `[blocker]` questions in `Open product and strategic questions` or new step reports are a hard gate only when that high bar is met: the orchestrator must run user interview immediately and must not route to other steps until blockers are resolved.
- Default execution mode is continuous: after a subtask is completed, the orchestrator must run `docs_writer`, then `commit`, then continue into the next routed step automatically. Do not stop between subtasks unless blocked, a mandatory step fails, the user asks to pause, or a final `planner` report explicitly declares `Full task status: complete`, `Reviewed: yes`, and `Closed out: yes`.

## Subtask Loop

Execute this loop for the active `(next)` subtask:

1. `planner`: research the codebase, update the whole spec from user input, codebase context, and execution memory; keep future subtasks as lightweight current-best-guess drafts; write the detailed tactical HOW for the active `(next)` subtask in a `plan` report.
2. `plan_reviewer`: review both the overall spec and the active-subtask plan, then issue `approved` or `revise`.
3. `test_writer`: write/update tests and define Browser test intent.
4. `implementer`: implement minimal correct change.
5. `browser_verifier`: run browser checks for browser-impact subtasks with Codex Browser Use, use Codex Computer Use only when Browser Use cannot cover the needed interaction, and produce screenshot/video evidence.
6. `code_reviewer`: review for bugs/regressions/missing tests.
7. `orchestrator` (no report required after this): follow `references/end-of-step.md`, enforce blocker gate, then choose next step.

If blocked, run `problem_solver`.

Browser-impact rule:

- Any subtask that touches or could potentially affect a user in-browser flow is browser-impact work.
- Browser-impact work MUST be tested in browser before the subtask is marked `(done)`.
- Browser verification should use the repo's browser/app harness mode when it exists and covers the needed flow. Read and follow `.zoo/browser.md` if it exists.
- Browser verification should use Codex Browser Use for navigation, interaction, inspection, screenshots, and evidence capture. Use Codex Computer Use only when Browser Use cannot exercise the required browser-visible behavior, or when browser appears frozen (currently happening when native alert or print dialog is displayed, or similar).
- Browser-impact work MUST include screenshot evidence under `.tasks/<task>/evidence/`.
- Video evidence is required when screenshots are insufficient (animation, transient states, timing-sensitive behavior).

Closeout rule:

- `docs_writer` runs during closeout for completed subtasks (not as a normal pre-closeout execution step).

Loop continuation rule:

- Do not stop after "subtask complete" summaries.
- Once a subtask is marked `(done)`, finish closeout (`docs_writer` -> `commit`) and immediately continue the workflow for the active `(next)` subtask.
- A subtask is not fully complete if changes are still uncommitted (unless commit failure is explicitly reported as blocking).
- The full task is not complete just because no `(next)` remains. Before stopping, run `planner` for a final task-completion check. Stop only when that planning report declares the full task fully done, reviewed, and closed out.

Quality bar:

- `planner`: near-perfect User Input capture, top-to-bottom `Spec`, future-subtask current-best-guess drafts, active-subtask acceptance, and tactical HOW in the `plan` report before coding.
- `plan_reviewer`/`code_reviewer`: if a concern is not addressed by the current contract/plan, request revision so the planner can respond; only allow proceeding when the review explicitly states why that concern can be ignored.
- Do not defer omissions that can be resolved now.
- For repo-specific architecture, UI, testing, review, and docs guidance, read the applicable `.zoo/*.md` file if it exists.

Language rule:

- Use straightforward, down-to-earth language.
- Avoid vague high-level wording and buzzwords.
- Prefer concrete statements with behavior, file paths, commands, and measurable outcomes.
- If a sentence sounds like strategy-speak, rewrite it in plain language.
- Write so a teammate can understand it on first read without "translation".

Be explicit about transitions, e.g. `Starting planner on <subtask>`.

Only the top-level orchestrator may delegate. A delegated single-step sub-agent must never delegate again.

When the top-level orchestrator launches a delegated step, the prompt must explicitly state that the recipient is a delegated sub-agent and must execute exactly one step itself. The prompt must also explicitly forbid running the full Zoo Heavy workflow, spawning subagents, and waiting on subagents.

Use subagents for each step. Exact step-name match -> delegate. Else use best matching subagent by description. Else launch a general subagent, but always do each step in a subagent.

Thread hygiene:

- Close completed subagent threads immediately after their report is written and results are consumed.
- Keep only currently active subagent threads open to avoid agent thread-limit stalls.

Reference checklists (progressive disclosure):

- `references/end-of-step.md`: mandatory for the `orchestrator` at end of every step loop.
- `references/user-interview.md`: mandatory during initial planning when consequential user questions exist, and later only when a `[blocker]` question meets the high bar in `Open product and strategic questions` or new step reports.
- `references/load-context.md`: mandatory at the start of every delegated subagent step.

## Bureau

- Task root: `.tasks/`
- Canonical spec path: `.tasks/<task>/spec.md`
- Explicit user-requested `.spec/...` files override the canonical spec path for spec reads/writes only.
- Evidence dir: `.tasks/<task>/evidence/`
- Use Bureau MCP for all task and report operations; do not use shell commands for these.
- Do not list task/report directories or invent sequential report filenames manually; Bureau MCP handles that.
- Before each step/subagent run, call `mcp__bureau__current_task` to get the current task slug, report directory, and report filenames.
- When launching a delegated step, include the report suffix it must use.

Switching:

- Start a new task with `mcp__bureau__start_new_task({task_slug})`.
- Switch tasks with `mcp__bureau__switch_task({task_slug})`.
- Use `mcp__bureau__list_recent_tasks()` when you need to find the exact recent task slug.
- Use `mcp__bureau__current_task()` to inspect the active task.

After each delegated subagent run, that subagent calls `mcp__bureau__start_new_report_file({suffix})` and writes exactly one report to the returned file.

A delegated subagent run (including blocked/failed) is incomplete until its report exists. The orchestrator closeout step itself does not require a report.

Delegated sub-agents do not own routing. After they write their one report, they stop and hand control back to the orchestrator.

Typical suffixes: `explore`, `user-request`, `plan`, `plan-review`, `tests`, `impl`, `browser-verify`, `docs`, `code-review`, `user-interview`, `solver`.

Every delegated subagent report must include:

- what was done and why
- report-level findings and supporting artifacts (for that step)
- result (`pass`/`fail` + short note)
- evidence file paths (when relevant) for that step
- decisions/tradeoffs
- open questions only when they meet the Zoo Heavy question policy; tag only true blockers as `[blocker]`
- next recommended step

Execution-agent evidence requirements (`test_writer`, `implementer`, `browser_verifier`, `docs_writer`, `code_reviewer`, `problem_solver`):

- In each report, include a clear `Evidence produced` section.
- For each evidence item, include: pointer + one plain line saying what it proves.
- Prefer pointers to existing files (`path[:line]`) for code/tests/docs.
- Do not copy source files, test files, or docs into `.tasks/<task>/evidence/`.
- Use `.tasks/<task>/evidence/` only for generated artifacts that do not already live in the repo (screenshots, dumps, logs, exports, etc.).
- If a step produced no concrete evidence, say why. Name the next step that must produce it, unless the subtask has no repo or behavior change and no evidence is required.

Plan report conventions:

- `plan` report is written by `planner` and includes `Subtask: <exact active subtask title>`, a brief note on spec changes or "none", and detailed tactical HOW for the active `(next)` subtask.
- `plan-review` report is written by `plan_reviewer` and includes `Plan: <plan-report-file>` and `Verdict: approved|revise`.
- `plan-review` reviews both the whole spec and the active-subtask plan.
- Any unaddressed concern in plan review requires `Verdict: revise` unless the report explicitly records why that concern is safe to ignore.
- Only `approved` plans can be referenced from `Subtasks` as active `Plan:` pointer.

Evidence flow:

- Step reports are provenance. They are not completion evidence by themselves.
- Completion evidence lives on the relevant `Subtasks` item as indented `Evidence:` lines.
- The orchestrator closes a subtask and updates that subtask's `Evidence:` lines when evidence is required.
- The orchestrator pulls candidate evidence pointers/artifacts from step reports and their outputs, especially:
  - `test_writer`: representative test names, test file pointers when useful, and Browser test intent for browser-impact subtasks (flows/assertions/hook gaps)
  - `implementer`: pointers to code changes + validation outputs from implementation
  - `browser_verifier`: browser run results + screenshot/video artifacts + Browser Use/Computer Use evidence notes
  - `docs_writer` (closeout): pointers to docs updates that preserve useful learnings for future work
  - `code_reviewer`: pointers to blocking findings and regression checks (when any)
  - `planner`/`plan_reviewer`: material spec/plan outputs when they change acceptance definitions, decisions, or execution memory
- The orchestrator picks the best, most relevant evidence pieces and maps each acceptance check to those artifacts.
- If evidence is missing for any acceptance check, the orchestrator must route back to the relevant execution agent(s) to produce it before marking the subtask done.

Backlog routing:

- Refactoring/cleanup we can do immediately -> add future subtask to spec.
- Refactoring/cleanup we discover we should do BEFORE current task -> add subtask to spec and make it next, make current task future.
- Follow-up product ideas -> `.docs/TODO-ideas.md`.
- Follow-up larger refactoring/cleanup we should not do immediately or lightly -> `.docs/TODO-refactoring.md`.

Browser evidence rule:

- Any browser-impact subtask (`Browser impact: possible|direct`) must route through `browser_verifier` before completion.
- Browser-impact subtasks must include screenshot evidence under `.tasks/<task>/evidence/` for each impacted flow or acceptance checkpoint.
- Add video evidence when screenshots alone cannot prove behavior (animation, transient states, timing-sensitive interactions).

Evidence type rules:

- If a subtask affects anything visible in the browser, completion evidence is browser screenshots. Use video only when screenshots cannot prove the behavior.
- If a subtask affects CSV or file generation/export, completion evidence includes example generated files under `.tasks/<task>/evidence/`.
- If a subtask affects CSV or file importing/uploading, completion evidence includes an example file to import under `.tasks/<task>/evidence/`; add browser screenshots of the import process when there is a browser UI.
- If a subtask is covered by tests, completion evidence lists the 1-2 most representative test names directly under the subtask's `Evidence:` lines; do not create a separate evidence file just to store test names.
- If a subtask has no repo changes and no behavior changes, no completion evidence is required.

## Spec Maintenance

Use exactly the sections from `Spec format`, in that order.

Section guidance:

- `User Input`: preserve the user's request separately from agent interpretation. Update it whenever the user clarifies, corrects, or overrides direction.
  - If the user references a ticket, issue, PR, or similar work item, treat its contents as part of the user request and preserve the relevant details here.
  - Direct user chat overrides ticket text when they conflict.
  - `Hard constraints`: only user-stated MUST/HARD constraints.
  - `Soft preferences`: user-stated preferences about solution shape.
  - `Unknowns`: preferences or decisions the user is unsure about.
  - `Draft ideas to adapt with common sense`: user-suggested implementation ideas that were not stated as MUST/HARD constraints.
  - Mark completed itemized lines with `(done)` immediately after the bullet marker.
- `Spec`: the working contract for the solution.
  - Write an itemized, top-to-bottom description of what the implemented solution will look like.
  - Group by subfeature/subarea with `###` headings.
  - Order headings and bullets from most consequential/visible to least consequential/visible.
  - Include concrete implementation surface when it matters for review: packages, templates, routes, structs, fields, permissions, jobs, migrations, and integration points.
  - Mark completed itemized lines with `(done)` immediately after the bullet marker, e.g. `- (done) Add Foo feature package`.
  - Avoid filler, background prose, generic risks, and restating the request in longer words.
- `Decision log`: record real alternatives considered and the chosen path with a brief reason.
  - Mark user overrides as `(USER INPUT)` and include the user's rationale when provided.
- `Open product and strategic questions`: only questions the user should decide.
  - Ask only the most consequential unclear questions: important product decisions, strategy-level decisions, and super consequential tactical decisions.
  - During initial planning, identify and ask all of these questions in one batch when possible.
  - Do not punt minor implementation decisions to the user.
  - After implementation starts, research the uncertainty first: inspect code, history, docs, production configuration, and production data when appropriate to identify the safest choice.
  - Prefer documenting a reasonable, evidence-backed decision in `Decision log` and proceeding.
  - Mark a later question `[blocker]` only when there is no safe default and proceeding could cause a high-impact product, strategy, data, security, or compatibility mistake.
  - Explain the dilemma and the product/technical consequences of each choice.
- `Execution memory`: compact notes the orchestrator updates from reports.
  - Preserve key implementation learnings, registration points, tricky areas, tests added, and known follow-up risk.
  - Use this memory to re-plan the next subtask and future subtasks after each completed subtask.
  - Keep this section brief and organized; do not paste report summaries.
- `Subtasks`: detailed plan for one active next task plus lightweight current-best-guess outlines or draft plans for future tasks.
  - exactly one `(next)` while the task is still in progress
  - plan only the active `(next)` subtask in detail
  - split standalone functional slices into separate subtasks when they have independent user value or complex independently testable implementation
  - prefer smaller subtasks; avoid broad catch-all subtasks that combine multiple independently valuable or independently testable slices
  - future subtask plans may include brief draft notes, but do not over-invest before promotion
  - primary line contains only status and title
  - `(next)` includes indented `Acceptance:`, `Browser impact:`, `Plan:`, and `Evidence:` lines
  - `(future)` items are outlines or current-best-guess drafts and may be title-only until promoted
  - before promoting a `(future)` item to `(next)`, re-plan it using `Execution memory` and what the previous subtasks learned
  - `Browser impact:` uses `none|possible|direct`; for `possible|direct`, include the flow list on the same line
  - completed items include indented `Evidence:` lines unless no evidence is required
  - keep subtask text outcome-oriented; detailed tactical HOW belongs in plan reports

Spec vs plan boundary:

- `spec.md` is durable whole-task planning: user input, product/behavior contract, decisions, execution memory, subtask status, and lightweight future-subtask drafts.
- Detailed tactical HOW for the active `(next)` subtask lives in `plan` / `plan-review` reports.
- Material spec edits go through `planner` and `plan_reviewer`.
- The `orchestrator` is the mechanical single writer for status/log updates.

Evidence gate:

- A subtask cannot be marked `(done)` until its `Evidence:` lines contain the required completion evidence, unless the subtask has no repo changes and no behavior changes.
- A subtask with one or more `[blocker]` unresolved cannot be marked `(done)`.
- Step reports are provenance; they are not sufficient evidence by themselves.
- Subtask evidence that only links to reports is invalid.
- Minimum subtask evidence coverage:
  - each non-trivial acceptance check maps to the matching evidence type above
  - browser-visible behavior maps to screenshot artifacts from `browser_verifier`
  - CSV/file generation maps to example generated files
  - CSV/file importing maps to an example input file and browser screenshots when the import has a browser UI
  - tested behavior maps to 1-2 representative test names written directly in the evidence list

Clarity gate:

- Vague or abstract wording is a quality failure.
- `plan_reviewer` should request revision when wording is hard to understand on first read.
