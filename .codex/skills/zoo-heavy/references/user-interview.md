# User Interview Protocol

Use this when user input is required for consequential unresolved questions.

## Trigger

1. During the initial planning pass, ask all consequential product, strategy, and super consequential tactical questions in one interview round before implementation starts.
2. After implementation starts, continue execution while open product and strategic questions exist but none meet the high blocker bar.
3. Before marking a mid-task question `[blocker]`, research the uncertainty using code, history, docs, production configuration, and production data when appropriate to identify the safest choice.
4. Mid-task `[blocker]` questions are allowed only when there is no safe default and proceeding could cause a high-impact product, strategy, data, security, or compatibility mistake.
5. When a mid-task question does not meet that bar, document the best evidence-backed decision in `Decision log` and proceed.
6. When a true `[blocker]` exists, pause planning/implementation and run one interview round.

## Interview Round

1. Gather pending questions from:
   - `spec.md` `Open product and strategic questions`
   - step reports written since the last `user-interview` report
2. Ask all pending consequential questions in one round, one-by-one.
3. Call `mcp__bureau__start_new_report_file` with suffix `user-interview`, then record the full Q/A in the returned file:
   - each question
   - answer (or `unanswered`)
   - whether it was marked `[blocker]`
4. Invoke `planner` to apply answers to `User Input`, `Spec`, `Decision log`, `Open product and strategic questions`, and `Subtasks` as needed.
5. Run `plan_reviewer` when the edits are material.
6. If any `[blocker]` remains unresolved after updates, stop and wait for user response; do not proceed to planning/implementation.
7. Resume planning/implementation only after spec updates are applied and no `[blocker]` remains unresolved.
