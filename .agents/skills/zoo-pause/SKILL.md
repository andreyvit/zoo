---
name: zoo-pause
description: "Pause a running Zoo workflow at a safe handoff. Use only when explicitly asked to pause, stop, or leave work resumable."
---

Follow `.zoo/zoo.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo pause start (.spec/example.md) r0`, then `Zoo pause finished (.spec/example.md) r0` or `Zoo pause failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Stop without wasting in-flight work.

- Do not start new subtasks, broad validation, rebase, push, or final closeout.
- Let useful in-flight commands/subagents finish; stop obsolete/destructive/expensive work when safe.
- Finish only the smallest edit/check/state update needed for clean resume.
- Do not commit partial work only because user asked to pause.
- Preserve `revision_round`, `stage`, and `stage_complete` unless actual stage work changed them; pausing is runtime state. Set task frontmatter `status` to `paused during subtask N` or `paused after subtask N`.
- Add one `Log` line: completed work, current step, validation/review state, uncommitted changes, exact resume step.
- If subtask met done condition, record it; mark done only through normal done rules.

Reply with task file link, pause point, completed work, validation/review status, uncommitted changes, exact resume point.
