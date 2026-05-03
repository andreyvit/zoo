# Orchestrator End-of-Step Checklist

1. Verify every delegated researcher, browser verifier, or reviewer run produced its own report.
2. Treat all new reports since the last orchestrator pass as inputs.
3. Apply mechanical spec file updates as single writer:
   - update `Execution memory` with compact implementation learnings from new reports and direct orchestration work
   - append `Decision log` entries from reports or implementation work when they record real alternatives or user overrides
   - if closing a subtask with repo or behavior changes, update that subtask's indented `Evidence:` lines by selecting the most relevant evidence pointers/artifacts and mapping each acceptance check to those pointers/artifacts
   - if closing a browser-impact subtask (`Browser impact: possible|direct`), require screenshot evidence and reject closeout when browser evidence is missing
   - when plan-review verdict is `approved` and the follow-up plan uberreview has no unresolved findings, update the active `(next)` subtask's indented `Plan:` pointer
   - when active subtask is complete, its `Evidence:` lines are sufficient or no evidence is required, and normal code review plus code uberreview have no unresolved findings, mark it `(done)`, choose one `(future)` as new `(next)` if one exists, and set indented `Plan: TBD` until next approved plan; leave substantive future-subtask revision to `zoo-plan`
4. If reports or implementation imply material changes to `User Input`, `Spec`, `Decision log`, `Open product and strategic questions`, or `Subtasks`, run `zoo-plan`, then `plan_reviewer`, then plan uberreview.
5. If plan uberreview reports findings, route to `zoo-plan`, then `plan_reviewer`, then plan uberreview again.
6. If `code_reviewer` or code uberreview reports findings, fix them directly when the fix is inside the approved plan and spec; otherwise rerun `zoo-plan`, `plan_reviewer`, and plan uberreview before fixing.
7. If a subtask was marked `(done)` in this pass, update durable docs directly when the subtask produced learnings or behavior that docs should preserve.
8. If a subtask was marked `(done)` in this pass, you MUST then use the `commit` skill before choosing/starting any next step.
9. If `commit` fails, stop and treat it as blocking; do not proceed to other steps.
10. Hard blocker gate: if any `[blocker]` question exists in `Open product and strategic questions` or new reports, verify the agent researched the uncertainty first, using code, history, docs, production configuration, and production data when appropriate to identify the safest choice.
11. Verify the question still meets the high bar for mid-task blocking: no safe default and high-impact product, strategy, data, security, or compatibility consequences.
12. If it meets that bar, run `references/user-interview.md` immediately and do not choose or execute any other next step while any `[blocker]` remains unresolved.
13. If it does not meet that bar, use `zoo-plan` to document the best evidence-backed decision in `Decision log`, remove the blocker tag, and proceed.
14. After interview + spec updates, restart this checklist from step 1.
15. If active `(next)` has `Plan: TBD`, route immediately to `zoo-plan`; the planning pass must run one or more read-only researcher agents for bounded codebase questions when the subtask is non-trivial, then refresh the whole spec and future-subtask drafts from `Execution memory` before writing the next detailed plan.
16. If no active `(next)` exists and no `(future)` remains, route immediately to `zoo-plan` for a final task-completion check. Do not stop until a `plan` report declares `Full task status: complete`, `Reviewed: yes`, and `Closed out: yes`; if `zoo-plan` finds missing work, it must add a real `(next)` and plan it.
17. Decide next step only when no `[blocker]` remains:
    - spec or plan flawed -> loop back to `zoo-plan`/`plan_reviewer`/plan uberreview
    - implementation incomplete or review findings unresolved -> continue top-level tests/implementation/docs, then `code_reviewer`/code uberreview
    - browser-impact checks/evidence incomplete -> route to `browser_verifier`
    - blocked or uncertain -> investigate directly, then document the result in the spec file or implementation report
18. Continuous mode: once next step is chosen, start it immediately. Do not stop with a status summary unless blocked, a final `zoo-plan` report explicitly closed the full task, or the user explicitly asks to pause.
