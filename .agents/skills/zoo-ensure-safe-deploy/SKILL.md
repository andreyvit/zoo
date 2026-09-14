---
name: zoo-ensure-safe-deploy
description: "Prolonged adversarial production-failure analysis for unpushed commits or user-scoped changes. Explicit invocation, or via zoo-final-uberreview. Find failures missed by development checks and reviews before deployment."
---

Find every plausible way scoped changes could fail in production. Treat misses as catastrophic. Spend exceptional time/tokens; optimize for assurance, not a quick verdict.

Default scope: unpushed commits on current branch; use user-specified range/PR/files/ticket when given. Exclude unrelated dirty work unless it affects analysis.

Follow `.zoo/zoo.md` if exists.

Assume tests, CI, linters, repo/browser checks, and agent/human reviews already passed. Do not rerun/delegate them or change production implementation. Existing results are clues, never safety evidence.

Method:

1. Establish exact scope/base, intended invariants, actual deploy/restart/rollback model, and before/after behavior. Trace changed inputs, outputs, writes, persistent forms, jobs/payloads, readers, caches, and external consumers.
2. Record each failure hypothesis: preconditions/exposure, deploy phase/trigger sequence, exact mechanism, impact/persistence/detection, rollback/recovery, evidence/confidence/unknowns.
3. Analyze distinct lenses: legacy/malformed/partial data and unusual tenants/config; interruption, pending work, retry/order/duplication/idempotency/time/concurrency; durable/external compatibility and actual rollout/rollback/failover/rebuild; auth/isolation/privacy/money/load/rate/observability; removed behavior, unchanged consumers, combined rare states, and second-order effects. Search history, migrations, identifiers, payloads, templates, analytics/exports, and production-only paths.
4. Challenge every safety assumption and dismissal, especially shared implementer/test/reviewer assumptions. Try to disprove both scenarios and dismissals. Re-read the diff after discoveries. Continue after clean passes and confirmed bugs; each new scenario resets saturation.
5. Prove discoveries with focused deterministic tests/probes or runtime evidence when useful. Make repros reproducible. Keep production access read-only; never expose sensitive data.

Stop only after repeated independent passes following the last discovery find no new credible scenario and each material scenario is ruled out, proven unsafe, or unresolved after exhausting read-only evidence. Otherwise stop only for user direction, irreducible scope ambiguity, or total access/authority block.

After the finding set is stable, consider whether it shows a deeper spec or approach flaw. Only if that deeper flaw is confirmed, propose an optional deeper remedy (improve the spec, redo part of the work, or restart from scratch with a modified approach) and pair it with a narrower alternative: one narrow, or one narrowest plus one narrower. User chooses width. Related failures that share a missing invariant are one cluster. Ordinary local bugs get a local recommendation only — do not invent a wider rewrite.

Report scope/base/deploy model; `unsafe`, `not proven safe`, or `safe to deploy`; scenarios ranked by severity/plausibility with mechanics, affected population, evidence, confidence, and repro commands; ruled-out scenarios; residual unknowns; rollback/recovery/observability gaps; recommendation per finding; deeper option only when a deeper flaw is confirmed. Use `safe to deploy` only with no credible material scenario unresolved and evidence for every material deployment assumption. Never substitute passing checks or "looks good."
