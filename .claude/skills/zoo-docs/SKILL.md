---
name: zoo-docs
description: Update durable documentation for completed Zoo workflow work. Use when a Zoo docs writer or orchestrator needs to preserve practical learnings, behavior, or public documentation changes.
---

# Zoo Docs

Read and follow `.zoo/zoo.md` if it exists.

Use this when updating durable docs after Zoo implementation work.

Goal: preserve useful, accurate learnings without turning docs into a commit log.

Read and follow `.zoo/docs.md` if it exists.

## Documentation Method

- Update actual durable docs, not only the Zoo report.
- Capture learnings that will help future agents or maintainers avoid repeating mistakes.
- Keep docs consistent with actual code and tests.
- Prefer terse internal docs with code pointers over long explanations or commit-level trivia.
- For public docs, verify every example field name against the code, schema, or JSON tags that serve it.
- Avoid speculative future claims unless explicitly marked as speculative.
- Consider amending `.zoo/*.md` only for high-importance lessons that should change future Zoo behavior across tasks. Use a high bar: repeated failure mode, costly repo-specific pitfall, or durable convention not already captured.
- If no durable docs need changes, say so and explain why in the report.
- Use straightforward, down-to-earth language; avoid vague high-level wording.
