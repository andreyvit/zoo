---
name: zoo-code-impl
description: "Implement the smallest correct code change for an approved Zoo active subtask plan. Use only when explicitly requested."
---

# Zoo Code Implementation

Use this when implementing an approved Zoo active-subtask plan.

Goal: deliver the smallest correct change that passes tests and respects architecture.

Read and follow `.zoo/coding.md` and `.zoo/testing.md` if exists.

## Implementation Method

- Use Rob Pike-style pragmatism: simple code, direct execution, and clarity over ceremony.
- Follow the approved tactical plan for the active `(next)` subtask.
- Keep diffs focused and avoid opportunistic refactors.
- Before claiming code is missing or impossible, search for existing symbols and read the actual implementation path.
- Run or inspect failing tests before changing behavior. Make tests pass without weakening their intent.
- Preserve layering and context-passing rules.
- If the plan or spec conflicts with code reality, stop and surface the conflict.

## Design Guardrails

- Investigate guards, constraints, zero/default handling, tenant checks, and global indexes before removing or bypassing them.
- Keep the constraint and find another path when its purpose is unclear.
- Search for existing configurable, translated, or tenant-customizable patterns before adding user-visible text, labels, messages, tooltips, or accessibility strings.
- When moving behavior, remove the old redundant path unless the plan explicitly requires both paths.
- For browser-impact subtasks, add stable and minimal testability hooks/selectors when existing semantics are insufficient.
- Prefer existing utilities, helpers, and local patterns over new abstractions.
