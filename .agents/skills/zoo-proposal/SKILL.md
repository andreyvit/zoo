---
name: zoo-proposal
description: Write durable proposal files for significant future work. Use when user asks for or approves a proposal, or when no active Zoo task file can hold the pending decision.
---

Follow `.zoo/zoo.md`, `.zoo/proposals.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo proposal start (.spec/example.md) r0`, then `Zoo proposal finished (.spec/example.md) r0` or `Zoo proposal failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Write proposal. Do not implement.

Filename: `.proposals/YYYYMMDD-slug.md` unless overridden. Copy `references/proposal-template.md`; replace placeholders.

Quality bar: approvable/rejectable/revisable; explicit scope, non-goals, validation, risks, open questions; no small cleanup/current-task work; no silent design decisions.

If in Zoo task, deciding 'later' on a Pending suggestion means write a proposal. Add:
- `Report > Remaining work`: `- Proposal: <path> - <finding>`
- `Log`: proposal path and current task continues/blocks

Report proposal path, status, finding handled, current-task disposition. Proposal closes finding unless technically blocking.
