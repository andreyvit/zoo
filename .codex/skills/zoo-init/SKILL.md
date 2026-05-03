---
name: zoo-init
description: Research a repository and initialize real project-specific Zoo customization files under .zoo, then verify Bureau MCP access. Use when setting up Zoo workflow customization for a repository.
---

# Zoo Init

Initialize repo-local Zoo customization files from actual project research, similar in spirit to `codex /init` or `claude /init`.

## Workflow

1. Research the repository before writing files:
   - root agent instructions: `AGENTS.md`, `CLAUDE.md`, or equivalents
   - existing docs such as `_ai/`, `docs/`, `_readme/`, or `README*`
   - package/module layout and build/test commands
   - existing app/browser harness docs or scripts
   - existing commit, review, and documentation conventions
2. Create `.zoo/` and `.zoo/review/` if needed.
3. Create only missing `.zoo/*.md` and `.zoo/review/*.md` files. Do not overwrite or edit existing files unless the user explicitly asks.
4. Populate each new file with concise, real project-specific instructions discovered from the repository. Do not use placeholder boilerplate. Format: concise bullet point list, short and actionable, no fluff.
5. For missing `.zoo/review/*.md` files, start from the user-provided review seed content below, follow the review-file shape below, and adapt it based on the research results: name project-specific risks, source-of-truth docs, commands, production constraints, security boundaries, test patterns, and known failure modes.
6. If a role or review theme has little explicit guidance, infer the repo's spirit from its structure, docs, commands, and examples, then write 1-2 suitable low-risk instructions for that file.
7. Keep each file short: include only guidance that a generic Zoo workflow would not already know.
8. After file setup, call `mcp__bureau__current_task` to verify Bureau MCP is accessible. Do not create or switch Bureau tasks for this check.  If Bureau tools are not exposed, use tool discovery to find the Bureau current-task tool, then call it. A normal empty/no-current-task response still counts as Bureau being accessible; a missing tool or failed MCP call does not. If you're sure Bureau is not accessible, recommend ways to install `https://github.com/andreyvit/bureau-mcp` in the current agent.
9. Report research sources, created files, skipped existing files, and whether Bureau MCP was accessible.


## Files

- `.zoo/planning.md`: product context, source-of-truth docs, architecture boundaries, project-specific planning risks.
- `.zoo/planreview.md`: local architecture, planning, migration, risk, and validation expectations reviewers should enforce.
- `.zoo/testing.md`: test placement, commands, fixtures, helpers, deterministic data, and project-specific assertion patterns.
- `.zoo/coding.md`: package boundaries, data/model conventions, settings/config patterns, code generation, migrations, and local helper preferences.
- `.zoo/codereview.md`: local correctness risks, data ownership checks, testing expectations, and project-specific review smells.
- `.zoo/browser.md`: local app/browser harness commands, scenarios, credentials docs, tunnel/callback rules, and UI primitives.
- `.zoo/docs.md`: local documentation destinations, agent instruction destinations, public-doc validation commands, terminology, and audience boundaries.

## Uberreview Seed Files

Create any missing files below under `.zoo/review/`. Use these as the user's seed content, then adapt each file from repository research instead of copying generic boilerplate.

Each `.zoo/review/*.md` file should look like a short reviewer brief:

- Start with one sentence naming the review lens and why it matters for this repository.
- Add 3-7 concrete checks. Prefer repo-specific checks over generic software advice.
- Name source files, docs, commands, configs, packages, fixtures, or production references the reviewer should inspect when that evidence exists.
- Tell the reviewer what kind of findings to report: concrete refactorings, missing tests, design corrections, rollout or recovery gaps, or user-approval-needed larger changes.
- Keep the tone direct. These files are instructions to a skeptical reviewer, not documentation for end users.
- Do not pad the files. If research only supports a few strong bullets, write a few strong bullets.

- `debuggability.md`: focus on whether production failures can be detected, investigated, limited, rolled back, and recovered from. Include repo-specific logging, metrics, fault reporting, migration preview, rollout, tenant/customer blast-radius, and data recovery expectations when discovered.
- `duplication.md`: focus on duplicated helpers, duplicated business rules, duplicated decision logic, repeated magic constants, and existing local helpers/packages that should be reused.
- `modularity.md`: focus on whether functions, packages, state ownership, data flow, edge cases, and responsibilities are easy to reason about in isolation. Call out unclear abstraction boundaries and emergent behavior that should be coded or tested explicitly.
- `readability.md`: focus on whether the code is easy to read and understand. Look for murky states, unclear edge cases, over-delegation, excessive mutability, mixed levels of abstraction, and repeated core business logic.
- `security.md`: focus on privilege escalation, data leaks, guessable or unsecured URLs, missing permissions, missing rate limits, cross-domain form or URL abuse, and whether security is obvious from clear common checks plus explicit exceptions.
- `simplicity.md`: focus on simplicity as the ultimate sophistication. This is one of the most important uberreview lenses, not a nitpick pass. Push hard on simpler alternatives, leaky concepts, poor names, unnecessary abstractions, large blocks that are hard to trust, low cohesion, high coupling, and whether a more direct design would be easier to explain and maintain. Tell reviewers to challenge the whole approach when a simpler design may exist, and to mark larger redesigns with `[user approval needed]` when they exceed the current task.
- `tests.md`: focus on testability, coverage, tests as readable specs, naming, meaningful scenarios, production configurations, legacy data, migrations, and whether modified behavior is covered by repo-appropriate validation.
