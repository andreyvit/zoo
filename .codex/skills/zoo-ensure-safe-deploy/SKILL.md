---
name: zoo-ensure-safe-deploy
description: "Manual deployment-safety validation for unpushed commits by default, or user-specified changes. Use only when explicitly requested, especially inside Codex /goal or Claude /loop, to de-risk deployment by adversarially hunting missed production rollout failures, legacy-data and migration hazards, mixed-version issues, and other real-world deployment risks before producing a firm safety guarantee or concrete proof of unsafety."
---

# Zoo Ensure Safe Deploy

Read and follow `.zoo/zoo.md` if it exists.

Use this when you are the top-level agent asked to prove changes are safe to deploy. This skill is adversarial deployment-risk discovery first; do not treat it as ordinary code review, planning, feature implementation, or a test-running checklist.

## Mission

Default scope: unpushed commits on the current branch. If the user specifies a commit range, PR, files, ticket, or other change set, use that instead. Do not include unrelated uncommitted work unless the user asks; report it separately if it can affect validation.

Goal: remove deployment fear by finding the deployment failures that ordinary reviews, CI, and happy-path tests missed. Dig until you can either:

- give a firm 100% deployment-safety guarantee for the scoped changes, backed by concrete evidence; or
- produce failing tests, reproducible scripts, or exact proof for real-world problems that make the deployment unsafe.

Do not end with "looks good", "low risk", or "probably safe" as the main conclusion. If safety is not proven, keep working unless blocked by missing access, credentials, destructive steps, ambiguity about scope, or an explicit user stop.

## Ground Rules

- Read and follow `.zoo/coding.md`, `.zoo/testing.md`, `.zoo/codereview.md`, and `.zoo/browser.md` when relevant.
- Assume this is the last layer of defense before production. Spend real effort, loop back after each conclusion, and ask what rare, old, tenant-specific, or deployment-timing state could still break.
- Prioritize creative production-risk hunting over formal verification. Tests, linters, and standard suites are supporting evidence; they are not the center of the work and never substitute for tracing deployment realities.
- Do not skip basic deployment hazards while chasing rare cases; repeatedly check both obvious breakpoints and tricky production states.
- Prefer read-only inspection for production configuration and data. Never mutate production while validating safety.
- Query production data only to answer concrete safety questions. Use the smallest useful aggregate counts, samples, or invariant checks, and do not expose secrets or sensitive records in reports.
- Treat the guarantee as earned. Do not use "100% safe" language unless every real deployment surface affected by the change has been traced and validated.
- Do not fix production behavior while proving safety unless the user asks. Adding minimal failing tests or repro artifacts for real bugs is allowed.

## Workflow

1. Establish the deployment scope:
   - Record branch, upstream, git status, and whether uncommitted changes exist.
   - If the user did not specify a scope and an upstream exists, use `@{u}..HEAD` for unpushed commits and the merge base with upstream as the before point.
   - If no upstream or base is clear, infer from `origin/main`, `origin/master`, `main`, or `master` only when unambiguous; otherwise ask for the base.
   - List commits, changed files, diff stats, migrations, config changes, background jobs, API surfaces, UI surfaces, infra/deploy files, and data-shape changes.

2. Build the deployment risk inventory:
   - Categorize risks by API behavior, UI behavior, data correctness, database migrations, permissions/auth, billing/payments, background jobs, external integrations, configuration/feature flags, timezones, concurrency, caching, rollout, rollback, and mixed-version deploy behavior.
   - For each changed behavior, trace from entry points through the relevant functions, templates, jobs, migrations, config, and tests.
   - Compare before and after with `git show <base>:<path>`, checked-out throwaway worktrees, docs, or tests when direct code reading is not enough.
   - Identify assumptions that depend on production configuration, production data shape, queued jobs, existing records, or third-party state.

3. Hunt for missed production failures:
   - Attack the change from multiple angles: "What if the record is old?", "What if the tenant has a weird config?", "What if a job was queued before deploy?", "What if old and new code overlap?", "What if rollback happens after partial migration?", "What if the external system retries an old payload?"
   - Search for persisted field names, enum values, API names, config props, route names, job kinds, queue payloads, webhook payloads, cache keys, template references, and analytics/log consumers that could outlive the code change.
   - Inspect legacy-data shapes: missing fields, zero values, invalid monetary values, old enum values, deleted references, duplicate rows, tenantless or cross-tenant records, partially configured tenants, archived entities, and historical payload formats.
   - Inspect migration and rollout hazards: backfill idempotency, partial progress, large-table locks, index build impact, default/null semantics, old-code/new-schema compatibility, new-code/old-schema compatibility, rollback after writes, and retry behavior after deploy interruption.
   - Inspect operational paths that tests often miss: scheduled jobs, pending jobs, webhooks, third-party retries, cached rendered pages, stale sessions, mobile or old clients, feature-flag transitions, tenant-specific overrides, production-only secrets/hooks, and rate limits.

4. Prove before/after behavior:
   - Maintain a behavior matrix: input/state/config, before behavior, after behavior, expected deployment effect, proof collected, and remaining uncertainty.
   - Validate compatibility with existing records, old clients, pending jobs, queued messages, caches, retries, idempotency expectations, and rollbacks when relevant.
   - For database changes, verify forward migration behavior, data preservation, null/default/backfill semantics, index/lock impact, and old-code/new-schema or new-code/old-schema compatibility when deployment can overlap.
   - For configuration changes, verify the deployed values or feature-flag states for every environment that matters.

5. Use execution as supporting evidence:
   - Run tests and commands that answer specific deployment-risk questions first. Then run the broader suite appropriate to the blast radius.
   - Add or tighten tests for every meaningful real-world invariant that is not already covered.
   - If a real bug is found, produce the smallest failing regression test, fixture, script, query, browser repro, or command that proves it.
   - Use browser/integration validation for browser-visible changes. Capture evidence when screenshots, generated files, logs, or command output prove behavior better than prose.
   - Re-run validation after adding tests or repros so the final state is unambiguous.

6. Seek independent review when useful:
   - Use `code_reviewer`, `zoo-uberreview`, or other reviewer subagents when available and proportionate to risk.
   - Focus reviewer prompts on missed deployment failures, production data/config assumptions, legacy-data hazards, rollout/rollback timing, migration safety, and real-world failure modes.
   - Resolve reviewer concerns with code evidence, production-safe inspection, tests, or failing repros.

7. Report the result:
   - Scope: exact commits/range/files validated, base compared against, and any excluded dirty work.
   - Guarantee: say "safe to deploy" only when the guarantee is actually proven; otherwise say "not proven safe" or "unsafe".
   - Evidence: risk inventory, missed-failure scenarios investigated, before/after behavior matrix summary, production configuration/data inspected, tests/commands run, browser or integration evidence, and reviewer passes.
   - Problems: failing tests/repros for real-world issues, with paths and commands.
   - Residual risk: any remaining unknowns, missing access, skipped environments, unvalidated paths, or operational preconditions.

## Stop Conditions

Stop only when one of these is true:

- The scoped changes are proven safe to deploy, with no unresolved reviewer findings, no unvalidated affected deployment surfaces, and passing relevant validation.
- A real-world unsafe behavior is proven with a failing test, repro script, query, browser repro, or concrete evidence.
- Progress is blocked by missing access, missing credentials, destructive-operation approval, ambiguous scope/base, or an explicit user stop.
