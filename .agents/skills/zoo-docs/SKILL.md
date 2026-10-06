---
name: zoo-docs
description: Update durable documentation for completed Zoo work. Use when a Zoo docs writer or orchestrator should preserve practical learnings, behavior, or public documentation changes.
---

Follow `.zoo/zoo.md`, `.zoo/docs.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo docs start (.spec/example.md) r0`, then `Zoo docs finished (.spec/example.md) r0` or `Zoo docs failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Preserve useful learnings. Do not write commit log.

- Update durable docs, not only the task file.
- Capture lessons future agents/maintainers need.
- Keep docs consistent with code/tests.
- Prefer terse internal docs with code pointers.
- Public docs: verify example fields against code, schema, or JSON tags.
- Mark speculation explicitly.
- Amend `.zoo/*.md` only for high-importance future Zoo behavior: repeated failure mode, costly repo pitfall, durable convention not captured.
- If no durable docs need changes, say why.
