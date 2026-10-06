---
name: zoo-final-uberreview
description: "Cross-agent production-safety review: zoo-ensure-safe-deploy in every uber-review agent. After the whole Zoo task is done when the spec has uberreviews: true, or when explicitly requested."
---

Follow `.zoo/zoo.md`, `.zoo/review.md` and file at `$ZOO_LOCAL_MD` if exists

Standalone chat at boundaries (actual spec path/round): `Zoo final uberreview start (.spec/example.md) r0`, then `Zoo final uberreview finished (.spec/example.md) r0` or `Zoo final uberreview failed (.spec/example.md) r0: <reason>`. Standalone without a spec: `(no spec) r?`.

Review `finished` means findings delivered, not resolved; emit before fixes/user decisions. Start lists selected reviewers; finish reports consolidated actionable findings and raw per-reviewer counts, e.g. `findings=2, codex=2, claude=failed, grok=3`. Report failed reviewers explicitly; total review failure uses `failed`.

Primary orchestrator: enter `stage: FIN`, `stage_complete: false`. Review completion alone does not finish FIN. Pass task path/round to every reviewer; require `Zoo review session (<spec path>) rN` in chat.

Do not start impl except through Zoo subtasks after user approval. Do not treat this as closeout.

Scout (`Scout:` line in `.zoo/review.md`): run with `-uber` over the reviewed scope (the range option `.zoo/review.md` documents; default all unpushed work). Unless `NO QUESTIONS`, add its output to every selected reviewer's prompt. Non-zero exit: fix or report, never read it as no questions. No scout: no questions.

If the spec is not `uberreviews: true`, set that frontmatter key and log the mark.

Resolve the reviewer list per `zoo-spec-uberreview/references/invoke-uberreview.md` first. Load zoo-ensure-safe-deploy; run it in an own-harness subagent only if your harness is listed. Listed other harnesses run via CLI. No production-implementation edits. PROMPT is zoo-ensure-safe-deploy's full instructions plus task/research file paths, reviewed Git range and any scoped paths, scout output if any, and "findings only; do not modify files or implement."

Combine: merge subagent and CLI findings; dedupe; keep which agents raised each; verify every finding against code (external agents share none of your context and can be wrong). Drop only findings that are false about the code; list those under `False positive or rejected review findings`.

Every remaining finding becomes a Pending suggestion (Code changes, or Scope expansion / Spec improvements if that is the width). Do not auto-fix.

In chat, list and explain every remaining finding with recommendations, before asking about any item. Include a clustered deeper-flaw reading and wide/narrow alternatives only when a deeper spec or approach flaw is confirmed. Then ask per Zoo skill `references/pending-suggestions.md`. Where a deeper flaw was confirmed, each ask includes the recommended width and the narrower alternative(s). User must decide each item. Accepted items become real Zoo subtasks ready to run; execute them through the normal subtask loop. Rejected go to Decisions or False positive or rejected review findings.

Log `Final uber-review (<agents>): ...` in `## Log`. Note agents and results (N findings recorded, K skipped / specific error) in that row; show the summary to the user. Status `final uber-review` while running; after findings, `awaiting decision on Pending suggestions` if any remain.

Do not re-run this pass after addressing findings. Offer the user a rerun; never start one automatically.

If no findings remain, caller may close out.
