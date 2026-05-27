# Load Step Context Checklist

Every subagent reads this at the start of its step.

Before loading anything else, confirm that you are in delegated single-step mode:

- you are a sub-agent, not the orchestrator
- you own exactly one step
- you must do that step yourself
- you must not run the full Zoo Heavy workflow
- you must not spawn subagents
- you must not wait for subagents
- you must write exactly one report, then stop

## Base Context (all subagents)

1. Call `mcp__bureau__current_task` to get the current task slug, reports directory, and report filenames.
2. Read `.zoo/zoo.md` if it exists.
3. Open `spec.md` and identify the active `(next)` subtask.
4. Read relevant `User Input`, `Spec`, `Open product and strategic questions`, `Execution memory`, and `Subtasks` entries.
5. Read recent report files needed for your step scope using the report filenames returned by `mcp__bureau__current_task`.

## Tactical Context (execution steps only)

Applies to: `test_writer`, `implementer`, `browser_verifier`, `docs_writer`, `code_reviewer`, `problem_solver`.

1. Read `Plan: <report-file>` from the active `(next)` subtask's indented child lines.
2. If `Plan:` is missing or set to `TBD`, stop and route back to `planner`/`plan_reviewer` via the `orchestrator`.
3. In the current task directory, read:
   - the pointed plan report file
   - every report file after that plan file (chronological filename order)
4. Use this set as the canonical tactical context for execution.
