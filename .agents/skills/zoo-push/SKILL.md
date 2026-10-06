---
name: zoo-push
description: Manually publish completed changes by reading repo push instructions, running Zoo Rebase first, and pushing or following repo PR/trunk workflow only when rebase says safe. Use only when explicitly asked to push, publish, open PR, or run Zoo Push.
---

Follow `.zoo/zoo.md`, `.zoo/push.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo push start (.spec/example.md) r0`, then `Zoo push finished (.spec/example.md) r0` or `Zoo push failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Only when user explicitly asks to push/publish.

Do not add push or inline-rebase activity, hashes, or outcomes to the Zoo
task/spec history. Do not add routine closeout corrections to `MISTAKES.md`. If
an unusually serious, reusable mistake warrants an entry, add it to a relevant
commit before push; never leave it as closeout dirt.

1. Run zoo-rebase inline with parent `push` (chat: `Zoo push rebase start (.spec/example.md) r0`, then `Zoo push rebase finished (.spec/example.md) r0`). Bail and follow zoo-rebase routing if outcome is Unsafe; continue if OK.
2. Push.
3. If remote moved, repeat zoo-rebase and retry until published or unsafe.
4. Report command, remote branch, PR URL if applicable, final git status, result - Pushed / Opened PR / Unsafe to push / Failed.

- Do not block push merely because conflicts happened; resolved conflicts + passing validation is safe.
- Do not push unresolved conflicts, failed validation, or uncommitted changes intended for upstream.
- Do not leave unrelated dirty work altered.
