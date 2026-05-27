---
name: zoo-init
description: Research a repository and initialize real project-specific Zoo customization files under .zoo, then verify Bureau MCP access. Use when setting up Zoo workflow customization for a repository.
---

# Zoo Init

Read and follow `.zoo/zoo.md` if it exists.

Initialize repo-local Zoo customization files from actual project research, similar in spirit to `codex /init` or `claude /init`.

Codex only: ensure the global Codex config (`$CODEX_HOME/config.toml`, usually `~/.codex/config.toml`) contains:

```toml
[features]
default_mode_request_user_input = true
```

This is required for Default mode to expose `request_user_input` for Zoo user interviews and other structured questions. If you add it during a running session and the tool remains unavailable, start a new turn/thread or restart Codex. Claude Code does not need this config.

## Workflow

1. Research the repository before writing files:
   - root agent instructions: `AGENTS.md`, `CLAUDE.md`, or equivalents
   - existing docs such as `_ai/`, `docs/`, `_readme/`, or `README*`
   - package/module layout and build/test commands
   - existing app/browser harness docs or scripts
   - existing commit, review, and documentation conventions
2. Create `.zoo/` and `.zoo/review/` if needed.
3. Create only missing `.zoo/*.md` and `.zoo/review/*.md` files. Do not overwrite or edit existing files unless the user explicitly asks.
4. Initialize `.zoo/zoo.md` if missing as an empty file or a very short table of contents linking to the relevant `.zoo` files. Do not copy role-specific rules into it.
5. Initialize `.zoo/subtask-start.md`, `.zoo/task-finish.md`, and `.zoo/rebase.md` as empty files if missing. These are repo-specific workflow hooks; leave them empty unless repository research or the user supplies concrete instructions.
6. Initialize `.zoo/push.md` if missing. Leave it empty unless the repository clearly documents a PR, trunk, or other publishing workflow; when it does, summarize only the concrete commands or constraints Zoo Push must follow.
7. Initialize `.zoo/proposals.md` if missing. If the repository has no existing proposals folder or convention, set new proposals to `.proposals/YYYYMMDD-title.md` and archived proposals to the `archived/` subfolder of that proposals folder.
8. Populate each new role-specific file with concise, real project-specific instructions discovered from the repository. Do not use placeholder boilerplate. Format: concise bullet point list, short and actionable, no fluff.
9. For missing `.zoo/review/*.md` files, start from the user-provided review seed content below, follow the review-file shape below, and adapt it based on the research results: name project-specific risks, source-of-truth docs, commands, production constraints, security boundaries, test patterns, and known failure modes.
10. If a role or review theme has little explicit guidance, infer the repo's spirit from its structure, docs, commands, and examples, then write 1-2 suitable low-risk instructions for that file.
11. Keep each file short: include only guidance that a generic Zoo workflow would not already know.
12. After file setup, call `mcp__bureau__current_task` to verify Bureau MCP is accessible. Do not create or switch Bureau tasks for this check.  If Bureau tools are not exposed, use tool discovery to find the Bureau current-task tool, then call it. A normal empty/no-current-task response still counts as Bureau being accessible; a missing tool or failed MCP call does not. If you're sure Bureau is not accessible, recommend ways to install `https://github.com/andreyvit/bureau-mcp` in the current agent.
13. Report: (1) primary research findings in the repo, (2) status for each dependency (whether Bureau MCP was accessible for now), (3) a table with all .zoo/ files mentioned above, brief description of their role, and the status: created, existing, updated.


## Files

- `.zoo/planning.md`: product context, source-of-truth docs, architecture boundaries, project-specific planning risks.
- `.zoo/planreview.md`: local architecture, planning, migration, risk, and validation expectations reviewers should enforce.
- `.zoo/testing.md`: test placement, commands, fixtures, helpers, deterministic data, and project-specific assertion patterns.
- `.zoo/coding.md`: package boundaries, data/model conventions, settings/config patterns, code generation, migrations, and local helper preferences.
- `.zoo/codereview.md`: local correctness risks, data ownership checks, testing expectations, and project-specific review smells.
- `.zoo/browser.md`: local app/browser harness commands, scenarios, credentials docs, tunnel/callback rules, and UI primitives.
- `.zoo/docs.md`: local documentation destinations, agent instruction destinations, public-doc validation commands, terminology, and audience boundaries.
- `.zoo/zoo.md`: short shared Zoo customization index or common instructions read by all Zoo skills.
- `.zoo/subtask-start.md`: optional hook for Zoo Heavy/Lite before each newly active subtask starts.
- `.zoo/task-finish.md`: optional hook read first during final closeout before `zoo-rebase` and `zoo-report`; its instructions override default Zoo closeout instructions.
- `.zoo/rebase.md`: optional repo-specific rebase and post-rebase validation instructions for `zoo-rebase`.
- `.zoo/push.md`: optional repo-specific publish instructions for `zoo-push`, such as push, PR, or trunk workflow.
- `.zoo/proposals.md`: proposal folder, new proposal naming scheme, archive location, status values, and project-specific proposal rules.

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
