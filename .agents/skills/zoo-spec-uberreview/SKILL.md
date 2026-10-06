---
name: zoo-spec-uberreview
description: "Cross-agent spec review: zoo-spec-review plus the same questions in other agents via CLI. After spec review is fully addressed when the spec has uberreviews: true, or when explicitly requested."
---

Follow `.zoo/zoo.md`, `.zoo/review.md`, `.zoo/planning.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo spec uberreview start (.spec/example.md) r0: stage=HL`, then `Zoo spec uberreview finished (.spec/example.md) r0: stage=HL` or `Zoo spec uberreview failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Review `finished` means findings delivered, not resolved; emit before fixes/user decisions. Use `stage=LL` for low-level review. Start lists selected reviewers; finish reports consolidated actionable findings and raw per-reviewer counts, e.g. `findings=2, codex=2, claude=failed, grok=3`. Report failed reviewers explicitly; total review failure uses `failed`.

Resolve the reviewer list per `references/invoke-uberreview.md` first. Follow zoo-spec-review, adding `-uber` to the scout's plan flag; run its own-harness subagent only if your harness is listed. Send the same scripted review prompt to listed other harnesses via CLI. Do not start impl/full workflow.

If the spec is not `uberreviews: true`, set that frontmatter key and log the mark.

Combine: merge subagent and CLI findings; dedupe; keep which agents raised each; verify every finding against code (external agents share none of your context and can be wrong). Then act per zoo-spec-review: fix, Pending suggestions, ask user, false positives. Do not re-run this cross-agent pass after that. Offer the user a rerun; never start one automatically.

Log `Spec uber-review (high-level|low-level, <agents>): ...` in `## Log`. Note agents and results (N findings recorded, K skipped / specific error) in that row; show the summary to the user.
