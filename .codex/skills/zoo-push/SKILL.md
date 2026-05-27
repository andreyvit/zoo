---
name: zoo-push
description: Manually publish completed Zoo workflow changes by reading repo push instructions, running Zoo Rebase first, and pushing or following the repo's prescribed PR/trunk workflow only when rebase is clean. Use only when the user explicitly asks to push, publish, open a PR, or run Zoo Push.
---

# Zoo Push

Read and follow `.zoo/zoo.md` if it exists.
Read and follow `.zoo/push.md` if it exists.

Zoo Push is manual only. Do not invoke it from ordinary Zoo closeout unless the user explicitly asks to push or publish.

## Workflow

1. Read `.zoo/push.md` if it exists and treat it as the repo-specific publishing contract. If it is empty or missing, default to pushing the current branch to its upstream with `git push`.
2. Run `zoo-rebase` first.
3. Read the `rebase` Bureau report and current git status.
4. If Zoo Rebase is not clean, do not push. Follow the Zoo Rebase routing:
   - report incoming broken commits with diagnostics and proposed fix approach without fixing them
   - route this workflow's breakage back into Heavy/Lite as a fix subtask, or into Zoo Zero outside Heavy/Lite
5. If Zoo Rebase is clean, publish according to `.zoo/push.md`; otherwise run `git push`.
6. Write a Bureau report with suffix `push` recording:
   - rebase report used and whether it was clean
   - push or PR/trunk command followed
   - remote branch, PR URL, or other publication target when available
   - final git status
   - `Push result: pushed|opened PR|not pushed|failed`

## Guardrails

- Push only when the user explicitly invoked Zoo Push or otherwise explicitly asked to publish.
- Do not push if rebase is not clean.
- Do not push unresolved conflicts, failing validation, or uncommitted trackable Zoo workflow changes outside ignored task roots.
- If a task root such as `.tasks/`, `_tasks/`, or a repo-specific alternate is ignored by git, never stage, force-add, commit, or push files under it to satisfy push cleanliness.
- Do not alter unrelated pre-existing dirty work.
