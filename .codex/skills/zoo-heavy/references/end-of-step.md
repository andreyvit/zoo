# Orchestrator End-of-Step Checklist

1. Verify every delegated subagent run produced its own report.
2. Treat all new reports since the last orchestrator pass as inputs.
3. Apply mechanical `spec.md` updates as single writer:
   - update `Execution memory` with compact implementation learnings from new reports
   - append `Decision log` entries from new reports when they record real alternatives or user overrides
   - if closing a subtask with repo or behavior changes, update that subtask's indented `Evidence:` lines by selecting the most relevant evidence pointers/artifacts from step reports and mapping each acceptance check to those pointers/artifacts
   - if closing a browser-impact subtask (`Browser impact: possible|direct`), require `browser_verifier` evidence and reject closeout when browser evidence is missing
   - when plan-review verdict is `approved`, update the active `(next)` subtask's indented `Plan:` pointer
   - when active subtask is complete and its `Evidence:` lines are sufficient or no evidence is required, mark it `(done)`, choose one `(future)` as new `(next)` if one exists, and set indented `Plan: TBD` until next approved plan; leave substantive future-subtask revision to `planner`
4. If reports imply material changes to `User Input`, `Spec`, `Decision log`, `Open product and strategic questions`, or `Subtasks`, invoke `planner`, then `plan_reviewer`.
5. If a subtask was marked `(done)` in this pass, run `docs_writer` to capture durable learnings before proceeding.
6. If `docs_writer` fails, stop and treat it as blocking; do not proceed to other steps.
7. If a subtask was marked `(done)` in this pass, you MUST then run `commit` before choosing/starting any next step.
8. If `commit` fails, stop and treat it as blocking; do not proceed to other steps.
9. Hard blocker gate: if any `[blocker]` question exists in `Open product and strategic questions` or new step reports, verify the agent researched the uncertainty first, using code, history, docs, production configuration, and production data when appropriate to identify the safest choice.
10. Verify the question still meets the high bar for mid-task blocking: no safe default and high-impact product, strategy, data, security, or compatibility consequences.
11. If it meets that bar, run `references/user-interview.md` immediately and do not choose or execute any other next step while any `[blocker]` remains unresolved.
12. If it does not meet that bar, invoke `planner` to document the best evidence-backed decision in `Decision log`, remove the blocker tag, and proceed.
13. After interview + spec updates, restart this checklist from step 1.
14. If active `(next)` has `Plan: TBD`, route immediately to `planner` (do not pause); `planner` must refresh the whole spec and future-subtask drafts from `Execution memory` before writing the next detailed plan.
15. If no active `(next)` exists and no `(future)` remains, route immediately to `planner` for a final task-completion check. Do not stop until a `plan` report declares `Full task status: complete`, `Reviewed: yes`, and `Closed out: yes`; if planner finds missing work, it must add a real `(next)` and plan it.
16. Decide next step only when no `[blocker]` remains:
    - spec or plan flawed -> loop back to `planner`/`plan_reviewer`
    - implementation incomplete -> loop back to `test_writer`/`implementer`
    - browser-impact checks/evidence incomplete -> route to `browser_verifier`
    - blocked or uncertain -> `problem_solver`
17. Continuous mode: once next step is chosen, start it immediately. Do not stop with a status summary unless blocked, a final planner report explicitly closed the full task, or the user explicitly asks to pause.
