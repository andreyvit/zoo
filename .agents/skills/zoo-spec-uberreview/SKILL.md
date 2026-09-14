---
name: zoo-spec-uberreview
description: "Cross-agent spec review: zoo-spec-review plus the same questions in other agents via CLI. After spec review is fully addressed when the spec has uberreviews: true, or when explicitly requested."
---

Follow `.zoo/zoo.md`, `.zoo/planning.md`, `.zoo/planreview.md` if exists.

Load zoo-spec-review skill and follow it in full; its subagent review covers your own harness. Then read `zoo-spec-uberreview/references/invoke-uberreview.md` and run the same prompt in the other harnesses. Do not start impl/full workflow.

If the spec is not `uberreviews: true`, set that frontmatter key and log the mark.

Combine: merge subagent and CLI findings; dedupe; keep which agents raised each; verify every finding against code (external agents share none of your context and can be wrong). Then act per zoo-spec-review: fix, Pending suggestions, ask user, false positives. Do not re-run this cross-agent pass after that. Offer the user a rerun; never start one automatically.

Log `Spec uber-review (high-level|low-level, <agents>): ...` in `## Log`. Note agents and results (N findings recorded, K skipped / specific error) in that row; show the summary to the user.
